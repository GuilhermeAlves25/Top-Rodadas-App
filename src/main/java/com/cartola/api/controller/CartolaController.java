package com.cartola.api.controller;

import com.cartola.api.dto.*;
import com.cartola.api.service.CartolaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CartolaController {
    
    private final CartolaService cartolaService;
    
    // Endpoints Básicos
    
    @GetMapping("/clubes")
    public ResponseEntity<List<String>> listarClubes() {
        List<String> clubes = cartolaService.listarClubes();
        return ResponseEntity.ok(clubes);
    }
    
    @GetMapping("/jogadores")
    public ResponseEntity<List<JogadorDTO>> listarJogadores(
            @RequestParam(required = false) String clube,
            @RequestParam(required = false) String posicao,
            @RequestParam(required = false) String nome) {
        
        List<JogadorDTO> jogadores = cartolaService.buscarJogadores(clube, posicao, nome);
        return ResponseEntity.ok(jogadores);
    }
    
    @GetMapping("/jogadores/{id}")
    public ResponseEntity<JogadorDetalheDTO> buscarJogadorPorId(@PathVariable Long id) {
        JogadorDetalheDTO jogador = cartolaService.buscarJogadorPorId(id);
        return ResponseEntity.ok(jogador);
    }
    
    @GetMapping("/jogadores/{id}/rodadas")
    public ResponseEntity<List<RodadaDTO>> buscarRodadasJogador(
            @PathVariable Long id,
            @RequestParam(required = false) Integer limite) {
        
        List<RodadaDTO> rodadas = cartolaService.buscarRodadasJogador(id, limite);
        return ResponseEntity.ok(rodadas);
    }
    
    @GetMapping("/ranking/rodada")
    public ResponseEntity<List<JogadorDTO>> buscarRankingRodada(
            @RequestParam Integer rodada,
            @RequestParam(required = false) String posicao,
            @RequestParam(required = false, defaultValue = "10") Integer limite) {
        
        List<JogadorDTO> ranking = cartolaService.buscarRankingRodada(rodada, posicao, limite);
        return ResponseEntity.ok(ranking);
    }
    
    @GetMapping("/comparacao")
    public ResponseEntity<ComparacaoDTO> compararJogadores(
            @RequestParam Long id1,
            @RequestParam Long id2) {
        
        ComparacaoDTO comparacao = cartolaService.compararJogadores(id1, id2);
        return ResponseEntity.ok(comparacao);
    }
    
    @GetMapping("/estatisticas/clube/{clube}")
    public ResponseEntity<EstatisticasClubeDTO> buscarEstatisticasClube(@PathVariable String clube) {
        EstatisticasClubeDTO estatisticas = cartolaService.buscarEstatisticasClube(clube);
        return ResponseEntity.ok(estatisticas);
    }
    
    // Scouts Específicos - Ataque
    
    @GetMapping("/scouts/ataque/top-assistencias")
    public ResponseEntity<List<JogadorDTO>> buscarTopAssistencias(
            @RequestParam(required = false) Integer rodada,
            @RequestParam(required = false) String clube,
            @RequestParam(required = false) String posicao,
            @RequestParam(required = false, defaultValue = "10") Integer limite) {
        
        if (rodada != null) {
            List<JogadorDTO> ranking = cartolaService.buscarTopAssistenciasRodada(rodada, clube, posicao, limite);
            return ResponseEntity.ok(ranking);
        }
        
        List<JogadorDTO> ranking = cartolaService.buscarTopAssistencias(clube, posicao, limite);
        return ResponseEntity.ok(ranking);
    }
    
    @GetMapping("/scouts/ataque/top-gols")
    public ResponseEntity<List<JogadorDTO>> buscarTopGols(
            @RequestParam(required = false) Integer rodada,
            @RequestParam(required = false) String clube,
            @RequestParam(required = false) String posicao,
            @RequestParam(required = false, defaultValue = "10") Integer limite) {
        
        if (rodada != null) {
            List<JogadorDTO> ranking = cartolaService.buscarTopGolsRodada(rodada, clube, posicao, limite);
            return ResponseEntity.ok(ranking);
        }
        
        List<JogadorDTO> ranking = cartolaService.buscarTopGols(clube, posicao, limite);
        return ResponseEntity.ok(ranking);
    }
    
    @GetMapping("/scouts/ataque/top-faltas-sofridas")
    public ResponseEntity<List<JogadorDTO>> buscarTopFaltasSofridas(
            @RequestParam(required = false) Integer rodada,
            @RequestParam(required = false) String clube,
            @RequestParam(required = false) String posicao,
            @RequestParam(required = false, defaultValue = "10") Integer limite) {
        
        if (rodada != null) {
            List<JogadorDTO> ranking = cartolaService.buscarTopFaltasSofridasRodada(rodada, clube, posicao, limite);
            return ResponseEntity.ok(ranking);
        }
        
        List<JogadorDTO> ranking = cartolaService.buscarTopFaltasSofridas(clube, posicao, limite);
        return ResponseEntity.ok(ranking);
    }
    
    @GetMapping("/scouts/ataque/top-finalizacoes-perigosas")
    public ResponseEntity<List<JogadorDTO>> buscarTopFinalizacoes(
            @RequestParam(required = false) Integer rodada,
            @RequestParam(required = false) String clube,
            @RequestParam(required = false) String posicao,
            @RequestParam(required = false, defaultValue = "10") Integer limite) {
        
        if (rodada != null) {
            List<JogadorDTO> ranking = cartolaService.buscarTopFinalizacoesRodada(rodada, clube, posicao, limite);
            return ResponseEntity.ok(ranking);
        }
        
        List<JogadorDTO> ranking = cartolaService.buscarTopFinalizacoes(clube, posicao, limite);
        return ResponseEntity.ok(ranking);
    }
    
    // Scouts Específicos - Defesa
    
    @GetMapping("/scouts/defesa/top-desarmes")
    public ResponseEntity<List<JogadorDTO>> buscarTopDesarmes(
            @RequestParam(required = false) Integer rodada,
            @RequestParam(required = false) String clube,
            @RequestParam(required = false) String posicao,
            @RequestParam(required = false, defaultValue = "10") Integer limite) {
        
        if (rodada != null) {
            List<JogadorDTO> ranking = cartolaService.buscarTopDesarmesRodada(rodada, clube, posicao, limite);
            return ResponseEntity.ok(ranking);
        }
        
        List<JogadorDTO> ranking = cartolaService.buscarTopDesarmes(clube, posicao, limite);
        return ResponseEntity.ok(ranking);
    }
    
    @GetMapping("/scouts/defesa/top-faltas-cometidas")
    public ResponseEntity<List<JogadorDTO>> buscarTopFaltasCometidas(
            @RequestParam(required = false) Integer rodada,
            @RequestParam(required = false) String clube,
            @RequestParam(required = false) String posicao,
            @RequestParam(required = false, defaultValue = "10") Integer limite) {
        
        if (rodada != null) {
            List<JogadorDTO> ranking = cartolaService.buscarTopFaltasCometidasRodada(rodada, clube, posicao, limite);
            return ResponseEntity.ok(ranking);
        }
        
        List<JogadorDTO> ranking = cartolaService.buscarTopFaltasCometidas(clube, posicao, limite);
        return ResponseEntity.ok(ranking);
    }
    
    @GetMapping("/scouts/defesa/top-jogos-sem-gol")
    public ResponseEntity<List<JogadorDTO>> buscarTopJogosSemGol(
            @RequestParam(required = false) Integer rodada,
            @RequestParam(required = false) String clube,
            @RequestParam(required = false, defaultValue = "10") Integer limite) {
        
        if (rodada != null) {
            List<JogadorDTO> ranking = cartolaService.buscarTopJogosSemGolRodada(rodada, clube, limite);
            return ResponseEntity.ok(ranking);
        }
        
        List<JogadorDTO> ranking = cartolaService.buscarTopJogosSemGol(clube, limite);
        return ResponseEntity.ok(ranking);
    }
    
    // Scouts Específicos - Goleiros
    
    @GetMapping("/scouts/goleiros/top-defesas-dificeis")
    public ResponseEntity<List<JogadorDTO>> buscarTopDefesasDificeis(
            @RequestParam(required = false) Integer rodada,
            @RequestParam(required = false) String clube,
            @RequestParam(required = false, defaultValue = "10") Integer limite) {
        
        if (rodada != null) {
            List<JogadorDTO> ranking = cartolaService.buscarTopDefesasDificeisRodada(rodada, clube, limite);
            return ResponseEntity.ok(ranking);
        }
        
        List<JogadorDTO> ranking = cartolaService.buscarTopDefesasDificeis(clube, limite);
        return ResponseEntity.ok(ranking);
    }
    
    @GetMapping("/scouts/goleiros/top-penaltis-defendidos")
    public ResponseEntity<List<JogadorDTO>> buscarTopPenaltisDefendidos(
            @RequestParam(required = false) Integer rodada,
            @RequestParam(required = false) String clube,
            @RequestParam(required = false, defaultValue = "10") Integer limite) {
        
        if (rodada != null) {
            List<JogadorDTO> ranking = cartolaService.buscarTopPenaltisDefendidosRodada(rodada, clube, limite);
            return ResponseEntity.ok(ranking);
        }
        
        List<JogadorDTO> ranking = cartolaService.buscarTopPenaltisDefendidos(clube, limite);
        return ResponseEntity.ok(ranking);
    }
}
