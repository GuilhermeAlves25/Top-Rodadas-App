import 'package:equatable/equatable.dart';

class Jogador extends Equatable {
  final int atletaId;
  final String apelido;
  final String? clube;
  final String? posicao;
  final double pontuacaoTotal;
  final int? gols;
  final int? assistencias;

  const Jogador({
    required this.atletaId,
    required this.apelido,
    this.clube,
    this.posicao,
    required this.pontuacaoTotal,
    this.gols,
    this.assistencias,
  });

  factory Jogador.fromJson(Map<String, dynamic> json) {
    return Jogador(
      atletaId: json['atletaId'] as int,
      apelido: json['apelido'] as String,
      clube: json['clube'] as String?,
      posicao: json['posicao'] as String?,
      pontuacaoTotal: (json['pontuacaoTotal'] as num?)?.toDouble() ?? 0.0,
      gols: json['gols'] as int?,
      assistencias: json['assistencias'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'atletaId': atletaId,
      'apelido': apelido,
      'clube': clube,
      'posicao': posicao,
      'pontuacaoTotal': pontuacaoTotal,
      'gols': gols,
      'assistencias': assistencias,
    };
  }

  @override
  List<Object?> get props => [atletaId, apelido, clube, posicao, pontuacaoTotal, gols, assistencias];
}
