// --- CLASSE VACINA APLICADA ---
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
        nome: json['nome'].toString(),
        dose: json['dose'].toString(),
        lote: json['lote'].toString(),
        dataAplicacao: DateTime.parse(json['dataAplicacao'].toString()),
        aplicador: json['aplicador'] != null
            ? json['aplicador'].toString()
            : 'Agente FUNAI',
      );
}

// --- CLASSE INDÍGENA ---
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
  }) : vacinasTomadas = vacinasTomadas ?? [];

  int get idade {
    final hoje = DateTime.now();
    int idadeCalculada = hoje.year - dataNascimento.year;
    if (hoje.month < dataNascimento.month ||
        (hoje.month == dataNascimento.month && hoje.day < dataNascimento.day)) {
      idadeCalculada--;
    }
    return idadeCalculada;
  }

  String get faixaEtaria {
    final i = idade;
    if (i <= 11) return 'Criança (0-11)';
    if (i <= 17) return 'Jovem (12-17)';
    if (i <= 59) return 'Adulto (18-59)';
    return 'Idoso (60+)';
  }

  List<String> get vacinasPendentes {
    final todas = [
      'BCG',
      'Hepatite B',
      'Penta',
      'Polio VIP',
      'Febre Amarela',
      'Tríplice Viral',
      'COVID-19',
      'Influenza'
    ];
    final tomadasNomes = vacinasTomadas.map((v) => v.nome).toSet();
    return todas.where((v) => !tomadasNomes.contains(v)).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cns': cns,
        'nome': nome,
        'aldeiaAtual': aldeiaAtual,
        'dataNascimento': dataNascimento.toIso8601String(),
        'vacinasTomadas': vacinasTomadas.map((v) => v.toJson()).toList(),
      };

  factory Indigena.fromJson(Map<String, dynamic> json) => Indigena(
        id: json['id'].toString(),
        cns: json['cns'].toString(),
        nome: json['nome'].toString(),
        aldeiaAtual: json['aldeiaAtual'].toString(),
        dataNascimento: DateTime.parse(json['dataNascimento'].toString()),
        vacinasTomadas: json['vacinasTomadas'] != null
            ? (json['vacinasTomadas'] as List)
                .map((v) => VacinaAplicada.fromJson(v as Map<String, dynamic>))
                .toList()
            : [],
      );
}