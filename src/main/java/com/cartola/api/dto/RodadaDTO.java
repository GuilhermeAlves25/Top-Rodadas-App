package com.cartola.api.dto;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RodadaDTO {
    private Integer rodadaId;
    private Double pontuacao;
    private Integer gols;
    private Integer assistencias;
    private Integer desarmes;
    private Integer faltasSofridas;
    private Integer faltasCometidas;
    private Integer finalizacoesDefendidas;
    private Integer finalizacoesNaTrave;
    private Integer defesasDificeis;
    private Integer penaltisDefendidos;
    private Integer jogosSemGol;
}
