package com.cartola.api.model;

import jakarta.persistence.*;
import lombok.*;
import java.util.List;

@Entity
@Table(name = "jogadores")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Jogador {
    
    @Id
    @Column(name = "atleta_id")
    private Long atletaId;
    
    @Column(nullable = false)
    private String apelido;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "clube_id")
    private Clube clube;
    
    @Column(name = "posicao_id")
    private Integer posicaoId;
    
    // Totais acumulados da temporada
    @Column(name = "pontuacao_fantasy_total")
    private Double pontuacaoFantasyTotal = 0.0;
    
    private Integer g = 0;
    private Integer a = 0;
    private Integer ds = 0;
    private Integer fc = 0;
    private Integer gc = 0;
    private Integer ca = 0;
    private Integer cv = 0;
    private Integer pc = 0;
    private Integer fs = 0;
    private Integer pe = 0;
    private Integer ft = 0;
    private Integer fd = 0;
    private Integer ff = 0;
    private Integer i = 0;
    private Integer pp = 0;
    private Integer ps = 0;
    private Integer sg = 0;
    private Integer de = 0;
    private Integer dp = 0;
    private Integer gs = 0;
    
    @OneToMany(mappedBy = "jogador", cascade = CascadeType.ALL)
    private List<JogadorRodada> rodadas;
}
