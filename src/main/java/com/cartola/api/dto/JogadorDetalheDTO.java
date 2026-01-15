package com.cartola.api.dto;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class JogadorDetalheDTO {
    private Long atletaId;
    private String apelido;
    private String clube;
    private String posicao;
    private Double pontuacaoTotal;
    
    // Scouts totais
    private Integer g;
    private Integer a;
    private Integer ds;
    private Integer fc;
    private Integer gc;
    private Integer ca;
    private Integer cv;
    private Integer pc;
    private Integer fs;
    private Integer pe;
    private Integer ft;
    private Integer fd;
    private Integer ff;
    private Integer i;
    private Integer pp;
    private Integer ps;
    private Integer sg;
    private Integer de;
    private Integer dp;
    private Integer gs;
}
