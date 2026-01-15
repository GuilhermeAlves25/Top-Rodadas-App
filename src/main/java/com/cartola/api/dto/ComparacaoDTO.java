package com.cartola.api.dto;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ComparacaoDTO {
    private JogadorDetalheDTO jogador1;
    private JogadorDetalheDTO jogador2;
    private Double mediaPontosJogador1;
    private Double mediaPontosJogador2;
}
