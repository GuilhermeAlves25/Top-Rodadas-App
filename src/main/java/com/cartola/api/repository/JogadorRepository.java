package com.cartola.api.repository;

import com.cartola.api.model.Jogador;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface JogadorRepository extends JpaRepository<Jogador, Long>, JpaSpecificationExecutor<Jogador> {
    
    @Query("SELECT DISTINCT j FROM Jogador j LEFT JOIN FETCH j.clube WHERE " +
           "(:clube IS NULL OR LOWER(j.clube.nome) LIKE LOWER(CONCAT('%', :clube, '%'))) AND " +
           "(:posicaoId IS NULL OR j.posicaoId = :posicaoId) AND " +
           "(:nome IS NULL OR LOWER(j.apelido) LIKE LOWER(CONCAT('%', :nome, '%')))")
    List<Jogador> findByFiltros(
        @Param("clube") String clube,
        @Param("posicaoId") Integer posicaoId,
        @Param("nome") String nome
    );
    
    List<Jogador> findByClubeNome(String clubeNome);
}
