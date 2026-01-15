package com.cartola.api.repository;

import com.cartola.api.model.Clube;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ClubeRepository extends JpaRepository<Clube, Long> {
    Optional<Clube> findByNome(String nome);
}
