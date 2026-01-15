package com.cartola.api.dto;

import lombok.*;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EstatisticasClubeDTO {
    private String clube;
    private Integer totalJogadores;
    private Double mediaPontuacao;
    private Integer totalGols;
    private Integer totalAssistencias;
    private List<JogadorDTO> topJogadores;
}
