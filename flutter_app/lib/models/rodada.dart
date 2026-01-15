import 'package:equatable/equatable.dart';

class Rodada extends Equatable {
  final int rodadaId;
  final double pontuacao;
  final int? gols;
  final int? assistencias;
  final int? desarmes;
  final int? faltasSofridas;
  final int? faltasCometidas;
  final int? finalizacoesDefendidas;
  final int? finalizacoesNaTrave;
  final int? defesasDificeis;
  final int? penaltisDefendidos;
  final int? jogosSemGol;

  const Rodada({
    required this.rodadaId,
    required this.pontuacao,
    this.gols,
    this.assistencias,
    this.desarmes,
    this.faltasSofridas,
    this.faltasCometidas,
    this.finalizacoesDefendidas,
    this.finalizacoesNaTrave,
    this.defesasDificeis,
    this.penaltisDefendidos,
    this.jogosSemGol,
  });

  factory Rodada.fromJson(Map<String, dynamic> json) {
    return Rodada(
      rodadaId: json['rodadaId'] as int,
      pontuacao: (json['pontuacao'] as num?)?.toDouble() ?? 0.0,
      gols: json['gols'] as int?,
      assistencias: json['assistencias'] as int?,
      desarmes: json['desarmes'] as int?,
      faltasSofridas: json['faltasSofridas'] as int?,
      faltasCometidas: json['faltasCometidas'] as int?,
      finalizacoesDefendidas: json['finalizacoesDefendidas'] as int?,
      finalizacoesNaTrave: json['finalizacoesNaTrave'] as int?,
      defesasDificeis: json['defesasDificeis'] as int?,
      penaltisDefendidos: json['penaltisDefendidos'] as int?,
      jogosSemGol: json['jogosSemGol'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rodadaId': rodadaId,
      'pontuacao': pontuacao,
      'gols': gols,
      'assistencias': assistencias,
      'desarmes': desarmes,
      'faltasSofridas': faltasSofridas,
      'faltasCometidas': faltasCometidas,
      'finalizacoesDefendidas': finalizacoesDefendidas,
      'finalizacoesNaTrave': finalizacoesNaTrave,
      'defesasDificeis': defesasDificeis,
      'penaltisDefendidos': penaltisDefendidos,
      'jogosSemGol': jogosSemGol,
    };
  }

  @override
  List<Object?> get props => [
    rodadaId, pontuacao, gols, assistencias, desarmes, faltasSofridas, 
    faltasCometidas, finalizacoesDefendidas, finalizacoesNaTrave,
    defesasDificeis, penaltisDefendidos, jogosSemGol
  ];
}
