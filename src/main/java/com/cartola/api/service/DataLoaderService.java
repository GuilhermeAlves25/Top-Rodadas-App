package com.cartola.api.service;

import com.cartola.api.model.*;
import com.cartola.api.repository.*;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class DataLoaderService implements CommandLineRunner {
    
    private final ClubeRepository clubeRepository;
    private final JogadorRepository jogadorRepository;
    private final JogadorRodadaRepository jogadorRodadaRepository;
    private final ObjectMapper objectMapper;
    
    @Override
    @Transactional
    public void run(String... args) throws Exception {
        log.info("Iniciando carga de dados...");
        
        // 1. Carregar clubes
        carregarClubes();
        
        // 2. Carregar jogadores e rodadas
        carregarJogadoresERodadas();
        
        log.info("Carga de dados concluída!");
    }
    
    private void carregarClubes() throws Exception {
        log.info("Carregando clubes...");
        
        ClassPathResource resource = new ClassPathResource("clubes.csv");
        try (BufferedReader br = new BufferedReader(new InputStreamReader(resource.getInputStream()))) {
            String line;
            boolean firstLine = true;
            
            while ((line = br.readLine()) != null) {
                if (firstLine) {
                    firstLine = false;
                    continue;
                }
                
                String[] parts = line.split(",");
                if (parts.length >= 2) {
                    Clube clube = Clube.builder()
                        .id(Long.parseLong(parts[0].trim()))
                        .nome(parts[1].trim())
                        .build();
                    clubeRepository.save(clube);
                }
            }
        }
        
        log.info("Clubes carregados: {}", clubeRepository.count());
    }
    
    private void carregarJogadoresERodadas() throws Exception {
        log.info("Carregando jogadores e rodadas...");
        
        ClassPathResource resource = new ClassPathResource("jogadores_rodadas.json");
        List<Map<String, Object>> dados = objectMapper.readValue(
            resource.getInputStream(),
            new TypeReference<List<Map<String, Object>>>() {}
        );
        
        // Agrupar por atleta_id
        Map<Long, List<Map<String, Object>>> dadosPorAtleta = dados.stream()
            .collect(Collectors.groupingBy(m -> Long.parseLong(m.get("atleta_id").toString())));
        
        for (Map.Entry<Long, List<Map<String, Object>>> entry : dadosPorAtleta.entrySet()) {
            Long atletaId = entry.getKey();
            List<Map<String, Object>> rodadas = entry.getValue();
            
            // Ordenar por rodada
            rodadas.sort(Comparator.comparing(m -> Integer.parseInt(m.get("rodada_id").toString())));
            
            // Pegar dados da última rodada para informações do jogador
            Map<String, Object> ultimaRodada = rodadas.get(rodadas.size() - 1);
            
            // Buscar clube
            Long clubeId = Long.parseLong(ultimaRodada.get("clube_id").toString());
            Clube clube = clubeRepository.findById(clubeId).orElse(null);
            
            // Criar jogador com totais acumulados (última rodada tem os totais)
            Jogador jogador = Jogador.builder()
                .atletaId(atletaId)
                .apelido(ultimaRodada.get("apelido").toString())
                .clube(clube)
                .posicaoId(Integer.parseInt(ultimaRodada.get("posicao_id").toString()))
                .pontuacaoFantasyTotal(getDouble(ultimaRodada, "pontuacao_fantasy"))
                .g(getInt(ultimaRodada, "G"))
                .a(getInt(ultimaRodada, "A"))
                .ds(getInt(ultimaRodada, "DS"))
                .fc(getInt(ultimaRodada, "FC"))
                .gc(getInt(ultimaRodada, "GC"))
                .ca(getInt(ultimaRodada, "CA"))
                .cv(getInt(ultimaRodada, "CV"))
                .pc(getInt(ultimaRodada, "PC"))
                .fs(getInt(ultimaRodada, "FS"))
                .pe(getInt(ultimaRodada, "PE"))
                .ft(getInt(ultimaRodada, "FT"))
                .fd(getInt(ultimaRodada, "FD"))
                .ff(getInt(ultimaRodada, "FF"))
                .i(getInt(ultimaRodada, "I"))
                .pp(getInt(ultimaRodada, "PP"))
                .ps(getInt(ultimaRodada, "PS"))
                .sg(getInt(ultimaRodada, "SG"))
                .de(getInt(ultimaRodada, "DE"))
                .dp(getInt(ultimaRodada, "DP"))
                .gs(getInt(ultimaRodada, "GS"))
                .build();
            
            jogadorRepository.save(jogador);
            
            // Processar rodadas e calcular deltas
            Map<String, Object> rodadaAnterior = null;
            
            for (Map<String, Object> rodadaAtual : rodadas) {
                Integer rodadaId = Integer.parseInt(rodadaAtual.get("rodada_id").toString());
                
                // Calcular deltas (diferença entre rodada atual e anterior)
                JogadorRodada jr = JogadorRodada.builder()
                    .jogador(jogador)
                    .rodadaId(rodadaId)
                    .pontuacaoFantasyReal(calcularDelta(rodadaAtual, rodadaAnterior, "pontuacao_fantasy"))
                    .gReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "G"))
                    .aReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "A"))
                    .dsReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "DS"))
                    .fcReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "FC"))
                    .gcReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "GC"))
                    .caReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "CA"))
                    .cvReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "CV"))
                    .pcReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "PC"))
                    .fsReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "FS"))
                    .peReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "PE"))
                    .ftReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "FT"))
                    .fdReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "FD"))
                    .ffReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "FF"))
                    .iReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "I"))
                    .ppReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "PP"))
                    .psReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "PS"))
                    .sgReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "SG"))
                    .deReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "DE"))
                    .dpReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "DP"))
                    .gsReal(calcularDeltaInt(rodadaAtual, rodadaAnterior, "GS"))
                    .build();
                
                jogadorRodadaRepository.save(jr);
                rodadaAnterior = rodadaAtual;
            }
        }
        
        log.info("Jogadores carregados: {}", jogadorRepository.count());
        log.info("Rodadas carregadas: {}", jogadorRodadaRepository.count());
    }
    
    private Integer getInt(Map<String, Object> map, String key) {
        Object value = map.get(key);
        if (value == null) return 0;
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        return 0;
    }
    
    private Double getDouble(Map<String, Object> map, String key) {
        Object value = map.get(key);
        if (value == null) return 0.0;
        if (value instanceof Number) {
            return ((Number) value).doubleValue();
        }
        return 0.0;
    }
    
    private Integer calcularDeltaInt(Map<String, Object> atual, Map<String, Object> anterior, String key) {
        int valorAtual = getInt(atual, key);
        if (anterior == null) {
            return valorAtual; // Primeira rodada
        }
        int valorAnterior = getInt(anterior, key);
        return valorAtual - valorAnterior;
    }
    
    private Double calcularDelta(Map<String, Object> atual, Map<String, Object> anterior, String key) {
        double valorAtual = getDouble(atual, key);
        if (anterior == null) {
            return valorAtual; // Primeira rodada
        }
        double valorAnterior = getDouble(anterior, key);
        return valorAtual - valorAnterior;
    }
}
