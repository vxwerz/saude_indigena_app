class AgenteFunai {
  final String nome;
  final String matricula;
  final String? cargo;

  AgenteFunai({
    required this.nome,
    required this.matricula,
    this.cargo,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'matricula': matricula,
        'cargo': cargo,
      };

  factory AgenteFunai.fromJson(Map<String, dynamic> json) => AgenteFunai(
        nome: json['nome'] as String,
        matricula: json['matricula'] as String,
        cargo: json['cargo'] as String?,
      );
}