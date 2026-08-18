class Atendimento {
  final String id;
  final String indigenaId;
  final String nomeIndigena;
  final String cnsIndigena;
  final String aldeia;
  final String tipoAtendimento;
  final int idade;
  final String faixaEtaria;
  final String observacoes;
  final DateTime dataHora;

  Atendimento({
    required this.id,
    required this.indigenaId,
    required this.nomeIndigena,
    required this.cnsIndigena,
    required this.aldeia,
    required this.tipoAtendimento,
    required this.idade,
    required this.faixaEtaria,
    required this.observacoes,
    required this.dataHora,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'indigenaId': indigenaId,
        'nomeIndigena': nomeIndigena,
        'cnsIndigena': cnsIndigena,
        'aldeia': aldeia,
        'tipoAtendimento': tipoAtendimento,
        'idade': idade,
        'faixaEtaria': faixaEtaria,
        'observacoes': observacoes,
        'dataHora': dataHora.toIso8601String(),
      };

  factory Atendimento.fromJson(Map<String, dynamic> json) => Atendimento(
        id: json['id'] as String,
        indigenaId: json['indigenaId'] as String,
        nomeIndigena: json['nomeIndigena'] as String,
        cnsIndigena: json['cnsIndigena'] as String,
        aldeia: json['aldeia'] as String,
        tipoAtendimento: json['tipoAtendimento'] as String,
        idade: json['idade'] as int,
        faixaEtaria: json['faixaEtaria'] as String,
        observacoes: json['observacoes'] as String,
        dataHora: DateTime.parse(json['dataHora'] as String),
      );
}