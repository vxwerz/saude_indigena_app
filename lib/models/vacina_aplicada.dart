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

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'dose': dose,
      'lote': lote,
      'dataAplicacao': dataAplicacao.toIso8601String(),
      'aplicador': aplicador,
    };
  }

  factory VacinaAplicada.fromJson(
    Map<String, dynamic> json,
  ) {
    DateTime data;

    try {
      data = DateTime.parse(
        json['dataAplicacao']?.toString() ?? '',
      );
    } catch (_) {
      data = DateTime.now();
    }

    return VacinaAplicada(
      nome: json['nome']?.toString() ?? '',
      dose: json['dose']?.toString() ?? '',
      lote: json['lote']?.toString() ?? '',
      dataAplicacao: data,
      aplicador:
          json['aplicador']?.toString() ?? 'Agente FUNAI',
    );
  }
}