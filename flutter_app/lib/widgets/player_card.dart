import 'package:flutter/material.dart';
import '../models/jogador.dart';

class PlayerCard extends StatelessWidget {
  final Jogador jogador;
  final VoidCallback? onTap;
  
  const PlayerCard({
    Key? key,
    required this.jogador,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar do jogador
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFFFEBF0),
                child: Text(
                  jogador.apelido.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B1538),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Informações do jogador
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jogador.apelido,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (jogador.clube != null) ...[
                          Icon(Icons.shield, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            jogador.clube!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (jogador.posicao != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getPosicaoColor(jogador.posicao!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              jogador.posicao!,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // Estatísticas
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    jogador.pontuacaoTotal.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B1538),
                    ),
                  ),
                  const Text(
                    'pontos',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  if (jogador.gols != null || jogador.assistencias != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (jogador.gols != null && jogador.gols! > 0) ...[
                          const Icon(Icons.sports_soccer, size: 12, color: Colors.blue),
                          const SizedBox(width: 2),
                          Text('${jogador.gols}', style: const TextStyle(fontSize: 11)),
                          const SizedBox(width: 6),
                        ],
                        if (jogador.assistencias != null && jogador.assistencias! > 0) ...[
                          const Icon(Icons.assist_walker, size: 12, color: Colors.orange),
                          const SizedBox(width: 2),
                          Text('${jogador.assistencias}', style: const TextStyle(fontSize: 11)),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getPosicaoColor(String posicao) {
    switch (posicao) {
      case 'GOL':
        return Colors.orange;
      case 'LAT':
      case 'ZAG':
        return Colors.blue;
      case 'MEI':
        return const Color(0xFF8B1538);
      case 'ATA':
        return Colors.red;
      case 'TEC':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
