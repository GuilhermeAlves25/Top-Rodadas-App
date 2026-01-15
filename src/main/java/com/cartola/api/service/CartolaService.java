package com.cartola.api.service;

import com.cartola.api.dto.*;
import com.cartola.api.model.*;
import com.cartola.api.repository.*;
import com.cartola.api.util.PosicaoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CartolaService {
    
    private final JogadorRepository jogadorRepository;
    private final JogadorRodadaRepository jogadorRodadaRepository;
    private final ClubeRepository clubeRepository;
    
    public List<String> listarClubes() {
        return clubeRepository.findAll().stream()
            .map(Clube::getNome)
            .sorted()
            .collect(Collectors.toList());
    }
    
    public List<JogadorDTO> buscarJogadores(String clube, String posicao, String nome) {
        Integer posicaoId = posicao != null ? PosicaoMapper.getPosicaoId(posicao) : null;
        
        List<Jogador> jogadores = jogadorRepository.findByFiltros(clube, posicaoId, nome);
        
        return jogadores.stream()
            .map(this::converterParaDTO)
            .collect(Collectors.toList());
    }
    
    public JogadorDetalheDTO buscarJogadorPorId(Long id) {
        Jogador jogador = jogadorRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Jogador não encontrado"));
        
        return converterParaDetalheDTO(jogador);
    }
    
    public List<RodadaDTO> buscarRodadasJogador(Long id, Integer limite) {
        List<JogadorRodada> rodadas = jogadorRodadaRepository.findByJogadorAtletaIdOrderByRodadaIdDesc(id);
        
        if (limite != null && limite > 0) {
            rodadas = rodadas.stream()
                .limit(limite)
                .collect(Collectors.toList());
        }
        
        return rodadas.stream()
            .map(this::converterRodadaParaDTO)
            .collect(Collectors.toList());
    }
    
    public List<JogadorDTO> buscarRankingRodada(Integer rodada, String posicao, Integer limite) {
        Integer posicaoId = posicao != null ? PosicaoMapper.getPosicaoId(posicao) : null;
        int limiteDefault = limite != null ? limite : 10;
        
        List<JogadorRodada> rodadas = jogadorRodadaRepository.findTopByPontuacao(
            rodada, null, posicaoId, PageRequest.of(0, limiteDefault)
        );
        
        return rodadas.stream()
            .map(jr -> JogadorDTO.builder()
                .atletaId(jr.getJogador().getAtletaId())
                .apelido(jr.getJogador().getApelido())
                .clube(jr.getJogador().getClube() != null ? jr.getJogador().getClube().getNome() : null)
                .posicao(PosicaoMapper.getPosicaoNome(jr.getJogador().getPosicaoId()))
                .pontuacaoTotal(jr.getPontuacaoFantasyReal())
                .gols(jr.getGReal())
                .assistencias(jr.getAReal())
                .build())
            .collect(Collectors.toList());
    }
    
    public ComparacaoDTO compararJogadores(Long id1, Long id2) {
        Jogador j1 = jogadorRepository.findById(id1)
            .orElseThrow(() -> new RuntimeException("Jogador 1 não encontrado"));
        Jogador j2 = jogadorRepository.findById(id2)
            .orElseThrow(() -> new RuntimeException("Jogador 2 não encontrado"));
        
        List<JogadorRodada> rodadas1 = jogadorRodadaRepository.findByJogadorAtletaIdOrderByRodadaIdDesc(id1);
        List<JogadorRodada> rodadas2 = jogadorRodadaRepository.findByJogadorAtletaIdOrderByRodadaIdDesc(id2);
        
        double media1 = rodadas1.stream()
            .mapToDouble(JogadorRodada::getPontuacaoFantasyReal)
            .average()
            .orElse(0.0);
        
        double media2 = rodadas2.stream()
            .mapToDouble(JogadorRodada::getPontuacaoFantasyReal)
            .average()
            .orElse(0.0);
        
        return ComparacaoDTO.builder()
            .jogador1(converterParaDetalheDTO(j1))
            .jogador2(converterParaDetalheDTO(j2))
            .mediaPontosJogador1(media1)
            .mediaPontosJogador2(media2)
            .build();
    }
    
    public EstatisticasClubeDTO buscarEstatisticasClube(String clube) {
        List<Jogador> jogadores = jogadorRepository.findByClubeNome(clube);
        
        if (jogadores.isEmpty()) {
            throw new RuntimeException("Clube não encontrado ou sem jogadores");
        }
        
        int totalGols = jogadores.stream().mapToInt(Jogador::getG).sum();
        int totalAssistencias = jogadores.stream().mapToInt(Jogador::getA).sum();
        double mediaPontuacao = jogadores.stream()
            .mapToDouble(Jogador::getPontuacaoFantasyTotal)
            .average()
            .orElse(0.0);
        
        List<JogadorDTO> topJogadores = jogadores.stream()
            .sorted(Comparator.comparing(Jogador::getPontuacaoFantasyTotal).reversed())
            .limit(5)
            .map(this::converterParaDTO)
            .collect(Collectors.toList());
        
        return EstatisticasClubeDTO.builder()
            .clube(clube)
            .totalJogadores(jogadores.size())
            .mediaPontuacao(mediaPontuacao)
            .totalGols(totalGols)
            .totalAssistencias(totalAssistencias)
            .topJogadores(topJogadores)
            .build();
    }
    
    // Métodos scouts para acumulados
    public List<JogadorDTO> buscarTopAssistencias(String clube, String posicao, Integer limite) {
        Integer posicaoId = posicao != null ? PosicaoMapper.getPosicaoId(posicao) : null;
        List<Jogador> jogadores = jogadorRepository.findByFiltros(clube, posicaoId, null);
        
        return jogadores.stream()
            .sorted(Comparator.comparing(Jogador::getA).reversed())
            .limit(limite != null ? limite : 10)
            .map(this::converterParaDTO)
            .collect(Collectors.toList());
    }
    
    public List<JogadorDTO> buscarTopGols(String clube, String posicao, Integer limite) {
        Integer posicaoId = posicao != null ? PosicaoMapper.getPosicaoId(posicao) : null;
        List<Jogador> jogadores = jogadorRepository.findByFiltros(clube, posicaoId, null);
        
        return jogadores.stream()
            .sorted(Comparator.comparing(Jogador::getG).reversed())
            .limit(limite != null ? limite : 10)
            .map(this::converterParaDTO)
            .collect(Collectors.toList());
    }
    
    public List<JogadorDTO> buscarTopDesarmes(String clube, String posicao, Integer limite) {
        Integer posicaoId = posicao != null ? PosicaoMapper.getPosicaoId(posicao) : null;
        List<Jogador> jogadores = jogadorRepository.findByFiltros(clube, posicaoId, null);
        
        return jogadores.stream()
            .sorted(Comparator.comparing(Jogador::getDs).reversed())
            .limit(limite != null ? limite : 10)
            .map(this::converterParaDTO)
            .collect(Collectors.toList());
    }
    
    public List<JogadorDTO> buscarTopFaltasSofridas(String clube, String posicao, Integer limite) {
        Integer posicaoId = posicao != null ? PosicaoMapper.getPosicaoId(posicao) : null;
        List<Jogador> jogadores = jogadorRepository.findByFiltros(clube, posicaoId, null);
        
        return jogadores.stream()
            .sorted(Comparator.comparing(Jogador::getFs).reversed())
            .limit(limite != null ? limite : 10)
            .map(this::converterParaDTO)
            .collect(Collectors.toList());
    }
    
    public List<JogadorDTO> buscarTopFaltasCometidas(String clube, String posicao, Integer limite) {
        Integer posicaoId = posicao != null ? PosicaoMapper.getPosicaoId(posicao) : null;
        List<Jogador> jogadores = jogadorRepository.findByFiltros(clube, posicaoId, null);
        
        return jogadores.stream()
            .sorted(Comparator.comparing(Jogador::getFc).reversed())
            .limit(limite != null ? limite : 10)
            .map(this::converterParaDTO)
            .collect(Collectors.toList());
    }
    
    public List<JogadorDTO> buscarTopFinalizacoes(String clube, String posicao, Integer limite) {
        Integer posicaoId = posicao != null ? PosicaoMapper.getPosicaoId(posicao) : null;
        List<Jogador> jogadores = jogadorRepository.findByFiltros(clube, posicaoId, null);
        
        return jogadores.stream()
            .sorted(Comparator.comparing((Jogador j) -> j.getFd() + j.getFt()).reversed())
            .limit(limite != null ? limite : 10)
            .map(this::converterParaDTO)
            .collect(Collectors.toList());
    }
    
    public List<JogadorDTO> buscarTopDefesasDificeis(String clube, Integer limite) {
        List<Jogador> jogadores = jogadorRepository.findByFiltros(clube, 1, null); // 1 = GOL
        
        return jogadores.stream()
            .sorted(Comparator.comparing(Jogador::getDe).reversed())
            .limit(limite != null ? limite : 10)
            .map(this::converterParaDTO)
            .collect(Collectors.toList());
    }
    
    public List<JogadorDTO> buscarTopPenaltisDefendidos(String clube, Integer limite) {
        List<Jogador> jogadores = jogadorRepository.findByFiltros(clube, 1, null); // 1 = GOL
        
        return jogadores.stream()
            .sorted(Comparator.comparing(Jogador::getDp).reversed())
            .limit(limite != null ? limite : 10)
            .map(this::converterParaDTO)
            .collect(Collectors.toList());
    }
    
    public List<JogadorDTO> buscarTopJogosSemGol(String clube, Integer limite) {
        // Posições defensivas: GOL, LAT, ZAG
        List<Jogador> jogadores = jogadorRepository.findAll().stream()
            .filter(j -> j.getPosicaoId() >= 1 && j.getPosicaoId() <= 3)
            .filter(j -> clube == null || (j.getClube() != null && j.getClube().getNome().equals(clube)))
            .sorted(Comparator.comparing(Jogador::getSg).reversed())
            .limit(limite != null ? limite : 10)
            .collect(Collectors.toList());
        
        return jogadores.stream()
            .map(this::converterParaDTO)
            .collect(Collectors.toList());
    }
    
    // Métodos scouts para rodada específica
    public List<JogadorDTO> buscarTopAssistenciasRodada(Integer rodada, String clube, String posicao, Integer limite) {
        Integer posicaoId = posicao != null ? PosicaoMapper.getPosicaoId(posicao) : null;
        int limiteDefault = limite != null ? limite : 10;
        
        List<JogadorRodada> rodadas = jogadorRodadaRepository.findTopAssistenciasRodada(
            rodada, clube, posicaoId, PageRequest.of(0, limiteDefault)
        );
        
        return converterRodadasParaDTO(rodadas);
    }
    
    public List<JogadorDTO> buscarTopGolsRodada(Integer rodada, String clube, String posicao, Integer limite) {
        Integer posicaoId = posicao != null ? PosicaoMapper.getPosicaoId(posicao) : null;
        int limiteDefault = limite != null ? limite : 10;
        
        List<JogadorRodada> rodadas = jogadorRodadaRepository.findTopGolsRodada(
            rodada, clube, posicaoId, PageRequest.of(0, limiteDefault)
        );
        
        return converterRodadasParaDTO(rodadas);
    }
    
    public List<JogadorDTO> buscarTopDesarmesRodada(Integer rodada, String clube, String posicao, Integer limite) {
        Integer posicaoId = posicao != null ? PosicaoMapper.getPosicaoId(posicao) : null;
        int limiteDefault = limite != null ? limite : 10;
        
        List<JogadorRodada> rodadas = jogadorRodadaRepository.findTopDesarmesRodada(
            rodada, clube, posicaoId, PageRequest.of(0, limiteDefault)
        );
        
        return converterRodadasParaDTO(rodadas);
    }
    
    public List<JogadorDTO> buscarTopFaltasSofridasRodada(Integer rodada, String clube, String posicao, Integer limite) {
        Integer posicaoId = posicao != null ? PosicaoMapper.getPosicaoId(posicao) : null;
        int limiteDefault = limite != null ? limite : 10;
        
        List<JogadorRodada> rodadas = jogadorRodadaRepository.findTopFaltasSofridasRodada(
            rodada, clube, posicaoId, PageRequest.of(0, limiteDefault)
        );
        
        return converterRodadasParaDTO(rodadas);
    }
    
    public List<JogadorDTO> buscarTopFaltasCometidasRodada(Integer rodada, String clube, String posicao, Integer limite) {
        Integer posicaoId = posicao != null ? PosicaoMapper.getPosicaoId(posicao) : null;
        int limiteDefault = limite != null ? limite : 10;
        
        List<JogadorRodada> rodadas = jogadorRodadaRepository.findTopFaltasCometidasRodada(
            rodada, clube, posicaoId, PageRequest.of(0, limiteDefault)
        );
        
        return converterRodadasParaDTO(rodadas);
    }
    
    public List<JogadorDTO> buscarTopFinalizacoesRodada(Integer rodada, String clube, String posicao, Integer limite) {
        Integer posicaoId = posicao != null ? PosicaoMapper.getPosicaoId(posicao) : null;
        int limiteDefault = limite != null ? limite : 10;
        
        List<JogadorRodada> rodadas = jogadorRodadaRepository.findTopFinalizacoesRodada(
            rodada, clube, posicaoId, PageRequest.of(0, limiteDefault)
        );
        
        return converterRodadasParaDTO(rodadas);
    }
    
    public List<JogadorDTO> buscarTopDefesasDificeisRodada(Integer rodada, String clube, Integer limite) {
        int limiteDefault = limite != null ? limite : 10;
        
        List<JogadorRodada> rodadas = jogadorRodadaRepository.findTopDefesasDificeisRodada(
            rodada, clube, PageRequest.of(0, limiteDefault)
        );
        
        return converterRodadasParaDTO(rodadas);
    }
    
    public List<JogadorDTO> buscarTopPenaltisDefendidosRodada(Integer rodada, String clube, Integer limite) {
        int limiteDefault = limite != null ? limite : 10;
        
        List<JogadorRodada> rodadas = jogadorRodadaRepository.findTopPenaltisDefendidosRodada(
            rodada, clube, PageRequest.of(0, limiteDefault)
        );
        
        return converterRodadasParaDTO(rodadas);
    }
    
    public List<JogadorDTO> buscarTopJogosSemGolRodada(Integer rodada, String clube, Integer limite) {
        int limiteDefault = limite != null ? limite : 10;
        
        List<JogadorRodada> rodadas = jogadorRodadaRepository.findTopJogosSemGolRodada(
            rodada, clube, PageRequest.of(0, limiteDefault)
        );
        
        return converterRodadasParaDTO(rodadas);
    }
    
    // Métodos auxiliares de conversão
    private JogadorDTO converterParaDTO(Jogador jogador) {
        return JogadorDTO.builder()
            .atletaId(jogador.getAtletaId())
            .apelido(jogador.getApelido())
            .clube(jogador.getClube() != null ? jogador.getClube().getNome() : null)
            .posicao(PosicaoMapper.getPosicaoNome(jogador.getPosicaoId()))
            .pontuacaoTotal(jogador.getPontuacaoFantasyTotal())
            .gols(jogador.getG())
            .assistencias(jogador.getA())
            .build();
    }
    
    private JogadorDetalheDTO converterParaDetalheDTO(Jogador jogador) {
        return JogadorDetalheDTO.builder()
            .atletaId(jogador.getAtletaId())
            .apelido(jogador.getApelido())
            .clube(jogador.getClube() != null ? jogador.getClube().getNome() : null)
            .posicao(PosicaoMapper.getPosicaoNome(jogador.getPosicaoId()))
            .pontuacaoTotal(jogador.getPontuacaoFantasyTotal())
            .g(jogador.getG())
            .a(jogador.getA())
            .ds(jogador.getDs())
            .fc(jogador.getFc())
            .gc(jogador.getGc())
            .ca(jogador.getCa())
            .cv(jogador.getCv())
            .pc(jogador.getPc())
            .fs(jogador.getFs())
            .pe(jogador.getPe())
            .ft(jogador.getFt())
            .fd(jogador.getFd())
            .ff(jogador.getFf())
            .i(jogador.getI())
            .pp(jogador.getPp())
            .ps(jogador.getPs())
            .sg(jogador.getSg())
            .de(jogador.getDe())
            .dp(jogador.getDp())
            .gs(jogador.getGs())
            .build();
    }
    
    private RodadaDTO converterRodadaParaDTO(JogadorRodada rodada) {
        return RodadaDTO.builder()
            .rodadaId(rodada.getRodadaId())
            .pontuacao(rodada.getPontuacaoFantasyReal())
            .gols(rodada.getGReal())
            .assistencias(rodada.getAReal())
            .desarmes(rodada.getDsReal())
            .faltasSofridas(rodada.getFsReal())
            .faltasCometidas(rodada.getFcReal())
            .finalizacoesDefendidas(rodada.getFdReal())
            .finalizacoesNaTrave(rodada.getFtReal())
            .defesasDificeis(rodada.getDeReal())
            .penaltisDefendidos(rodada.getDpReal())
            .jogosSemGol(rodada.getSgReal())
            .build();
    }
    
    private List<JogadorDTO> converterRodadasParaDTO(List<JogadorRodada> rodadas) {
        return rodadas.stream()
            .map(jr -> JogadorDTO.builder()
                .atletaId(jr.getJogador().getAtletaId())
                .apelido(jr.getJogador().getApelido())
                .clube(jr.getJogador().getClube() != null ? jr.getJogador().getClube().getNome() : null)
                .posicao(PosicaoMapper.getPosicaoNome(jr.getJogador().getPosicaoId()))
                .pontuacaoTotal(jr.getPontuacaoFantasyReal())
                .gols(jr.getGReal())
                .assistencias(jr.getAReal())
                .build())
            .collect(Collectors.toList());
    }
}
