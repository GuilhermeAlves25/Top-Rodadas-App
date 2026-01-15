package com.cartola.api.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "jogadores_rodadas")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class JogadorRodada {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "atleta_id")
    private Jogador jogador;
    
    @Column(name = "rodada_id", nullable = false)
    private Integer rodadaId;
    
    // Valores REAIS da rodada (deltas)
    @Column(name = "pontuacao_fantasy_real")
    private Double pontuacaoFantasyReal = 0.0;
    
    @Column(name = "g_real")
    private Integer gReal = 0;
    
    @Column(name = "a_real")
    private Integer aReal = 0;
    
    @Column(name = "ds_real")
    private Integer dsReal = 0;
    
    @Column(name = "fc_real")
    private Integer fcReal = 0;
    
    @Column(name = "gc_real")
    private Integer gcReal = 0;
    
    @Column(name = "ca_real")
    private Integer caReal = 0;
    
    @Column(name = "cv_real")
    private Integer cvReal = 0;
    
    @Column(name = "pc_real")
    private Integer pcReal = 0;
    
    @Column(name = "fs_real")
    private Integer fsReal = 0;
    
    @Column(name = "pe_real")
    private Integer peReal = 0;
    
    @Column(name = "ft_real")
    private Integer ftReal = 0;
    
    @Column(name = "fd_real")
    private Integer fdReal = 0;
    
    @Column(name = "ff_real")
    private Integer ffReal = 0;
    
    @Column(name = "i_real")
    private Integer iReal = 0;
    
    @Column(name = "pp_real")
    private Integer ppReal = 0;
    
    @Column(name = "ps_real")
    private Integer psReal = 0;
    
    @Column(name = "sg_real")
    private Integer sgReal = 0;
    
    @Column(name = "de_real")
    private Integer deReal = 0;
    
    @Column(name = "dp_real")
    private Integer dpReal = 0;
    
    @Column(name = "gs_real")
    private Integer gsReal = 0;
}
