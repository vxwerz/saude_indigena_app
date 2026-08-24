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
  final String? agenteMatricula;

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
    this.agenteMatricula,
  });

  Map<String, dynamic> toMap() {
    return {
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
      'agenteMatricula': agenteMatricula,
    };
  }

  factory Atendimento.fromMap(Map<String, dynamic> map) {
    return Atendimento(
      id: map['id'] ?? '',
      indigenaId: map['indigenaId'] ?? '',
      nomeIndigena: map['nomeIndigena'] ?? '',
      cnsIndigena: map['cnsIndigena'] ?? '',
      aldeia: map['aldeia'] ?? '',
      tipoAtendimento: map['tipoAtendimento'] ?? '',
      idade: map['idade']?.toInt() ?? 0,
      faixaEtaria: map['faixaEtaria'] ?? '',
      observacoes: map['observacoes'] ?? '',
      dataHora: DateTime.parse(map['dataHora']),
      agenteMatricula: map['agenteMatricula'],
    );
  }

  Atendimento copyWith({
    String? id,
    String? indigenaId,
    String? nomeIndigena,
    String? cnsIndigena,
    String? aldeia,
    String? tipoAtendimento,
    int? idade,
    String? faixaEtaria,
    String? observacoes,
    DateTime? dataHora,
    String? agenteMatricula,
  }) {
    return Atendimento(
      id: id ?? this.id,
      indigenaId: indigenaId ?? this.indigenaId,
      nomeIndigena: nomeIndigena ?? this.nomeIndigena,
      cnsIndigena: cnsIndigena ?? this.cnsIndigena,
      aldeia: aldeia ?? this.aldeia,
      tipoAtendimento: tipoAtendimento ?? this.tipoAtendimento,
      idade: idade ?? this.idade,
      faixaEtaria: faixaEtaria ?? this.faixaEtaria,
      observacoes: observacoes ?? this.observacoes,
      dataHora: dataHora ?? this.dataHora,
      agenteMatricula: agenteMatricula ?? this.agenteMatricula,
    );
  }
}