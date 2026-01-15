package com.cartola.api.repository;

import com.cartola.api.model.JogadorRodada;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface JogadorRodadaRepository extends JpaRepository<JogadorRodada, Long> {
    
    List<JogadorRodada> findByJogadorAtletaIdOrderByRodadaIdDesc(Long atletaId);
    
    @Query("SELECT jr FROM JogadorRodada jr WHERE " +
           "(:rodada IS NULL OR jr.rodadaId = :rodada) AND " +
           "(:clube IS NULL OR jr.jogador.clube.nome = :clube) AND " +
           "(:posicaoId IS NULL OR jr.jogador.posicaoId = :posicaoId) " +
           "ORDER BY jr.pontuacaoFantasyReal DESC")
    List<JogadorRodada> findTopByPontuacao(
        @Param("rodada") Integer rodada,
        @Param("clube") String clube,
        @Param("posicaoId") Integer posicaoId,
        Pageable pageable
    );
    
    // Queries para scouts - rodada específica
    @Query("SELECT jr FROM JogadorRodada jr WHERE " +
           "jr.rodadaId = :rodada AND " +
           "(:clube IS NULL OR jr.jogador.clube.nome = :clube) AND " +
           "(:posicaoId IS NULL OR jr.jogador.posicaoId = :posicaoId) " +
           "ORDER BY jr.aReal DESC")
    List<JogadorRodada> findTopAssistenciasRodada(
        @Param("rodada") Integer rodada,
        @Param("clube") String clube,
        @Param("posicaoId") Integer posicaoId,
        Pageable pageable
    );
    
    @Query("SELECT jr FROM JogadorRodada jr WHERE " +
           "jr.rodadaId = :rodada AND " +
           "(:clube IS NULL OR jr.jogador.clube.nome = :clube) AND " +
           "(:posicaoId IS NULL OR jr.jogador.posicaoId = :posicaoId) " +
           "ORDER BY jr.gReal DESC")
    List<JogadorRodada> findTopGolsRodada(
        @Param("rodada") Integer rodada,
        @Param("clube") String clube,
        @Param("posicaoId") Integer posicaoId,
        Pageable pageable
    );
    
    @Query("SELECT jr FROM JogadorRodada jr WHERE " +
           "jr.rodadaId = :rodada AND " +
           "(:clube IS NULL OR jr.jogador.clube.nome = :clube) AND " +
           "(:posicaoId IS NULL OR jr.jogador.posicaoId = :posicaoId) " +
           "ORDER BY jr.dsReal DESC")
    List<JogadorRodada> findTopDesarmesRodada(
        @Param("rodada") Integer rodada,
        @Param("clube") String clube,
        @Param("posicaoId") Integer posicaoId,
        Pageable pageable
    );
    
    @Query("SELECT jr FROM JogadorRodada jr WHERE " +
           "jr.rodadaId = :rodada AND " +
           "(:clube IS NULL OR jr.jogador.clube.nome = :clube) AND " +
           "(:posicaoId IS NULL OR jr.jogador.posicaoId = :posicaoId) " +
           "ORDER BY jr.fsReal DESC")
    List<JogadorRodada> findTopFaltasSofridasRodada(
        @Param("rodada") Integer rodada,
        @Param("clube") String clube,
        @Param("posicaoId") Integer posicaoId,
        Pageable pageable
    );
    
    @Query("SELECT jr FROM JogadorRodada jr WHERE " +
           "jr.rodadaId = :rodada AND " +
           "(:clube IS NULL OR jr.jogador.clube.nome = :clube) AND " +
           "(:posicaoId IS NULL OR jr.jogador.posicaoId = :posicaoId) " +
           "ORDER BY jr.fcReal DESC")
    List<JogadorRodada> findTopFaltasCometidasRodada(
        @Param("rodada") Integer rodada,
        @Param("clube") String clube,
        @Param("posicaoId") Integer posicaoId,
        Pageable pageable
    );
    
    @Query("SELECT jr FROM JogadorRodada jr WHERE " +
           "jr.rodadaId = :rodada AND " +
           "(:clube IS NULL OR jr.jogador.clube.nome = :clube) AND " +
           "(:posicaoId IS NULL OR jr.jogador.posicaoId = :posicaoId) " +
           "ORDER BY (jr.fdReal + jr.ftReal) DESC")
    List<JogadorRodada> findTopFinalizacoesRodada(
        @Param("rodada") Integer rodada,
        @Param("clube") String clube,
        @Param("posicaoId") Integer posicaoId,
        Pageable pageable
    );
    
    @Query("SELECT jr FROM JogadorRodada jr WHERE " +
           "jr.rodadaId = :rodada AND " +
           "jr.jogador.posicaoId = 1 AND " +
           "(:clube IS NULL OR jr.jogador.clube.nome = :clube) " +
           "ORDER BY jr.deReal DESC")
    List<JogadorRodada> findTopDefesasDificeisRodada(
        @Param("rodada") Integer rodada,
        @Param("clube") String clube,
        Pageable pageable
    );
    
    @Query("SELECT jr FROM JogadorRodada jr WHERE " +
           "jr.rodadaId = :rodada AND " +
           "jr.jogador.posicaoId = 1 AND " +
           "(:clube IS NULL OR jr.jogador.clube.nome = :clube) " +
           "ORDER BY jr.dpReal DESC")
    List<JogadorRodada> findTopPenaltisDefendidosRodada(
        @Param("rodada") Integer rodada,
        @Param("clube") String clube,
        Pageable pageable
    );
    
    @Query("SELECT jr FROM JogadorRodada jr WHERE " +
           "jr.rodadaId = :rodada AND " +
           "jr.jogador.posicaoId IN (1, 2, 3) AND " +
           "(:clube IS NULL OR jr.jogador.clube.nome = :clube) " +
           "ORDER BY jr.sgReal DESC")
    List<JogadorRodada> findTopJogosSemGolRodada(
        @Param("rodada") Integer rodada,
        @Param("clube") String clube,
        Pageable pageable
    );
}
