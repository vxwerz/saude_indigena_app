import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool sincronizado;

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
    this.sincronizado = false,
  });

  // Dados enviados para o Firebase
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
      'dataHora': Timestamp.fromDate(dataHora),
      'agenteMatricula': agenteMatricula,
      'sincronizado': sincronizado,
    };
  }

  // Dados salvos no armazenamento local
  Map<String, dynamic> toLocalMap() {
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
      'sincronizado': sincronizado,
    };
  }

  factory Atendimento.fromMap(Map<String, dynamic> map) {
    DateTime dataHora;

    try {
      final valorData = map['dataHora'];

      if (valorData is Timestamp) {
        dataHora = valorData.toDate();
      } else if (valorData is DateTime) {
        dataHora = valorData;
      } else if (valorData is String && valorData.isNotEmpty) {
        dataHora = DateTime.parse(valorData);
      } else {
        dataHora = DateTime.now();
      }
    } catch (_) {
      dataHora = DateTime.now();
    }

    return Atendimento(
      id: map['id']?.toString() ?? '',
      indigenaId: map['indigenaId']?.toString() ?? '',
      nomeIndigena: map['nomeIndigena']?.toString() ?? '',
      cnsIndigena: map['cnsIndigena']?.toString() ?? '',
      aldeia: map['aldeia']?.toString() ?? '',
      tipoAtendimento: map['tipoAtendimento']?.toString() ?? '',
      idade: _parseInt(map['idade']),
      faixaEtaria: map['faixaEtaria']?.toString() ?? '',
      observacoes: map['observacoes']?.toString() ?? '',
      dataHora: dataHora,
      agenteMatricula: map['agenteMatricula']?.toString(),
      sincronizado: map['sincronizado'] == true,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
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
    bool? sincronizado,
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
      sincronizado: sincronizado ?? this.sincronizado,
    );
  }
}