package com.cartola.api.util;

import java.util.Map;

public class PosicaoMapper {
    
    public static final Map<String, Integer> POSICOES = Map.of(
        "GOL", 1,
        "LAT", 2,
        "ZAG", 3,
        "MEI", 4,
        "ATA", 5,
        "TEC", 6
    );
    
    public static final Map<Integer, String> POSICOES_REVERSE = Map.of(
        1, "GOL",
        2, "LAT",
        3, "ZAG",
        4, "MEI",
        5, "ATA",
        6, "TEC"
    );
    
    public static Integer getPosicaoId(String sigla) {
        if (sigla == null) return null;
        return POSICOES.get(sigla.toUpperCase());
    }
    
    public static String getPosicaoNome(Integer id) {
        if (id == null) return null;
        return POSICOES_REVERSE.get(id);
    }
}
