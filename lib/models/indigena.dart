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
      'dataAplicacao':
          dataAplicacao.toIso8601String(),
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
          json['aplicador']?.toString() ??
              'Agente FUNAI',
    );
  }
}

class Indigena {
  final String id;
  final String cns;
  final String nome;
  final String aldeiaAtual;
  final DateTime dataNascimento;

  List<VacinaAplicada> vacinasTomadas;

  Indigena({
    required this.id,
    required this.cns,
    required this.nome,
    required this.aldeiaAtual,
    required this.dataNascimento,
    List<VacinaAplicada>? vacinasTomadas,
  }) : vacinasTomadas =
            vacinasTomadas ?? [];

  // ============================================================
  // IDADE
  // ============================================================

  int get idade {
    final hoje = DateTime.now();

    int idadeCalculada =
        hoje.year - dataNascimento.year;

    if (hoje.month <
            dataNascimento.month ||
        (hoje.month ==
                dataNascimento.month &&
            hoje.day <
                dataNascimento.day)) {
      idadeCalculada--;
    }

    return idadeCalculada < 0
        ? 0
        : idadeCalculada;
  }

  // ============================================================
  // FAIXA ETÁRIA
  // ============================================================

  String get faixaEtaria {
    final idadeAtual = idade;

    if (idadeAtual <= 4) {
      return '0 a 4 anos';
    }

    if (idadeAtual <= 9) {
      return '5 a 9 anos';
    }

    if (idadeAtual <= 19) {
      return '10 a 19 anos';
    }

    if (idadeAtual <= 29) {
      return '20 a 29 anos';
    }

    if (idadeAtual <= 59) {
      return '30 a 59 anos';
    }

    return '60+';
  }

  // ============================================================
  // VACINAS PENDENTES
  // ============================================================

  List<String> get vacinasPendentes {
    const todas = [
      'BCG',
      'Hepatite B',
      'Penta',
      'Polio VIP',
      'Febre Amarela',
      'Tríplice Viral',
      'COVID-19',
      'Influenza',
    ];

    final tomadasNomes =
        vacinasTomadas
            .map(
              (vacina) => vacina.nome,
            )
            .toSet();

    return todas
        .where(
          (vacina) =>
              !tomadasNomes.contains(
            vacina,
          ),
        )
        .toList();
  }

  // ============================================================
  // SERIALIZAÇÃO
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cns': cns,
      'nome': nome,
      'aldeiaAtual': aldeiaAtual,
      'dataNascimento':
          dataNascimento.toIso8601String(),
      'vacinasTomadas':
          vacinasTomadas
              .map(
                (vacina) =>
                    vacina.toJson(),
              )
              .toList(),
    };
  }

  // ============================================================
  // DESSERIALIZAÇÃO
  // ============================================================

  factory Indigena.fromJson(
    Map<String, dynamic> json,
  ) {
    DateTime nascimento;

    try {
      nascimento = DateTime.parse(
        json['dataNascimento']
                ?.toString() ??
            '',
      );
    } catch (_) {
      nascimento =
          DateTime(2000, 1, 1);
    }

    final List<VacinaAplicada>
        vacinas = [];

    final vacinasJson =
        json['vacinasTomadas'];

    if (vacinasJson is List) {
      for (final item in vacinasJson) {
        if (item is Map) {
          vacinas.add(
            VacinaAplicada.fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            ),
          );
        }
      }
    }

    return Indigena(
      id: json['id']?.toString() ?? '',
      cns: json['cns']?.toString() ?? '',
      nome:
          json['nome']?.toString() ?? '',
      aldeiaAtual:
          json['aldeiaAtual']
                  ?.toString() ??
              '',
      dataNascimento: nascimento,
      vacinasTomadas: vacinas,
    );
  }
}