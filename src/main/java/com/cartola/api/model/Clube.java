package com.cartola.api.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "clubes")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Clube {
    
    @Id
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String nome;
}
