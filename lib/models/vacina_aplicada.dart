class VacinaAplicada {
  final String nome;
  final String dose;
  final String lote;
  final DateTime dataAplicacao;
  final String aplicador;

  VacinaAplicada({
    required this.nome,
    required this.dose,
    required this.lote,
    required this.dataAplicacao,
    required this.aplicador,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'dose': dose,
        'lote': lote,
        'dataAplicacao': dataAplicacao.toIso8601String(),
        'aplicador': aplicador,
      };

  factory VacinaAplicada.fromJson(Map<String, dynamic> json) => VacinaAplicada(
        nome: json['nome'],
        dose: json['dose'],
        lote: json['lote'],
        dataAplicacao: DateTime.parse(json['dataAplicacao']),
        aplicador: json['aplicador'] ?? 'Agente FUNAI',
      );
}