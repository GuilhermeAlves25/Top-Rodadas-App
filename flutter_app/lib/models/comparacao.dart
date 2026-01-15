import 'package:equatable/equatable.dart';
import 'jogador_detalhe.dart';

class Comparacao extends Equatable {
  final JogadorDetalhe jogador1;
  final JogadorDetalhe jogador2;
  final double mediaPontosJogador1;
  final double mediaPontosJogador2;

  const Comparacao({
    required this.jogador1,
    required this.jogador2,
    required this.mediaPontosJogador1,
    required this.mediaPontosJogador2,
  });

  factory Comparacao.fromJson(Map<String, dynamic> json) {
    return Comparacao(
      jogador1: JogadorDetalhe.fromJson(json['jogador1'] as Map<String, dynamic>),
      jogador2: JogadorDetalhe.fromJson(json['jogador2'] as Map<String, dynamic>),
      mediaPontosJogador1: (json['mediaPontosJogador1'] as num?)?.toDouble() ?? 0.0,
      mediaPontosJogador2: (json['mediaPontosJogador2'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [jogador1, jogador2, mediaPontosJogador1, mediaPontosJogador2];
}
