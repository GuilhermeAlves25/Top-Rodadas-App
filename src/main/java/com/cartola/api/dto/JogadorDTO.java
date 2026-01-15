package com.cartola.api.dto;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class JogadorDTO {
    private Long atletaId;
    private String apelido;
    private String clube;
    private String posicao;
    private Double pontuacaoTotal;
    private Integer gols;
    private Integer assistencias;
}
