import 'package:equatable/equatable.dart';

class JogadorDetalhe extends Equatable {
  final int atletaId;
  final String apelido;
  final String? clube;
  final String? posicao;
  final double pontuacaoTotal;
  
  // Scouts totais
  final int g;
  final int a;
  final int ds;
  final int fc;
  final int gc;
  final int ca;
  final int cv;
  final int pc;
  final int fs;
  final int pe;
  final int ft;
  final int fd;
  final int ff;
  final int i;
  final int pp;
  final int ps;
  final int sg;
  final int de;
  final int dp;
  final int gs;

  const JogadorDetalhe({
    required this.atletaId,
    required this.apelido,
    this.clube,
    this.posicao,
    required this.pontuacaoTotal,
    required this.g,
    required this.a,
    required this.ds,
    required this.fc,
    required this.gc,
    required this.ca,
    required this.cv,
    required this.pc,
    required this.fs,
    required this.pe,
    required this.ft,
    required this.fd,
    required this.ff,
    required this.i,
    required this.pp,
    required this.ps,
    required this.sg,
    required this.de,
    required this.dp,
    required this.gs,
  });

  factory JogadorDetalhe.fromJson(Map<String, dynamic> json) {
    return JogadorDetalhe(
      atletaId: json['atletaId'] as int,
      apelido: json['apelido'] as String,
      clube: json['clube'] as String?,
      posicao: json['posicao'] as String?,
      pontuacaoTotal: (json['pontuacaoTotal'] as num?)?.toDouble() ?? 0.0,
      g: json['g'] as int? ?? 0,
      a: json['a'] as int? ?? 0,
      ds: json['ds'] as int? ?? 0,
      fc: json['fc'] as int? ?? 0,
      gc: json['gc'] as int? ?? 0,
      ca: json['ca'] as int? ?? 0,
      cv: json['cv'] as int? ?? 0,
      pc: json['pc'] as int? ?? 0,
      fs: json['fs'] as int? ?? 0,
      pe: json['pe'] as int? ?? 0,
      ft: json['ft'] as int? ?? 0,
      fd: json['fd'] as int? ?? 0,
      ff: json['ff'] as int? ?? 0,
      i: json['i'] as int? ?? 0,
      pp: json['pp'] as int? ?? 0,
      ps: json['ps'] as int? ?? 0,
      sg: json['sg'] as int? ?? 0,
      de: json['de'] as int? ?? 0,
      dp: json['dp'] as int? ?? 0,
      gs: json['gs'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    atletaId, apelido, clube, posicao, pontuacaoTotal,
    g, a, ds, fc, gc, ca, cv, pc, fs, pe, ft, fd, ff, i, pp, ps, sg, de, dp, gs
  ];
}
