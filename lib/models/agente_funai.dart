class AgenteFunai {
  final String nome;
  final String matricula;
  final String? cargo;

  AgenteFunai({
    required this.nome,
    required this.matricula,
    this.cargo,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'matricula': matricula,
      'cargo': cargo,
    };
  }

  factory AgenteFunai.fromJson(Map<String, dynamic> json) {
    return AgenteFunai(
      nome: json['nome']?.toString() ?? '',
      matricula: json['matricula']?.toString() ?? '',
      cargo: json['cargo']?.toString(),
    );
  }
}