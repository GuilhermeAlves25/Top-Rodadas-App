import 'package:equatable/equatable.dart';

class Clube extends Equatable {
  final int id;
  final String nome;

  const Clube({
    required this.id,
    required this.nome,
  });

  factory Clube.fromJson(Map<String, dynamic> json) {
    return Clube(
      id: json['id'] as int,
      nome: json['nome'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  @override
  List<Object?> get props => [id, nome];
}
