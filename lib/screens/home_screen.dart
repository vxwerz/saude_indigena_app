import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/agente_funai.dart';

class Vacina {
  final String nome;
  final String dose;
  final String lote;
  final DateTime dataAplicacao;
  final String aplicador;

  Vacina({
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

  factory Vacina.fromJson(Map<String, dynamic> json) => Vacina(
        nome: json['nome'],
        dose: json['dose'],
        lote: json['lote'],
        dataAplicacao: DateTime.parse(json['dataAplicacao']),
        aplicador: json['aplicador'],
      );
}

class Indigena {
  final String nome;
  final String cns;
  final int idade;
  final String faixaEtaria;
  final String aldeiaAtual;
  final List<Vacina> vacinasTomadas;

  Indigena({
    required this.nome,
    required this.cns,
    required this.idade,
    required this.faixaEtaria,
    required this.aldeiaAtual,
    required this.vacinasTomadas,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'cns': cns,
        'idade': idade,
        'faixaEtaria': faixaEtaria,
        'aldeiaAtual': aldeiaAtual,
        'vacinasTomadas': vacinasTomadas.map((v) => v.toJson()).toList(),
      };

  factory Indigena.fromJson(Map<String, dynamic> json) => Indigena(
        nome: json['nome'],
        cns: json['cns'],
        idade: json['idade'],
        faixaEtaria: json['faixaEtaria'],
        aldeiaAtual: json['aldeiaAtual'],
        vacinasTomadas: (json['vacinasTomadas'] as List)
            .map((v) => Vacina.fromJson(v))
            .toList(),
      );
}

class Atendimento {
  final String id;
  final DateTime dataHora;
  final String faixaEtaria;
  final String tipo;
  final String observacao;
  final String indigenaCns;
  final String agenteNome;
  bool sincronizado;

  Atendimento({
    required this.id,
    required this.dataHora,
    required this.faixaEtaria,
    required this.tipo,
    required this.observacao,
    required this.indigenaCns,
    required this.agenteNome,
    this.sincronizado = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'dataHora': dataHora.toIso8601String(),
        'faixaEtaria': faixaEtaria,
        'tipo': tipo,
        'observacao': observacao,
        'indigenaCns': indigenaCns,
        'agenteNome': agenteNome,
        'sincronizado': sincronizado,
      };

  factory Atendimento.fromJson(Map<String, dynamic> json) => Atendimento(
        id: json['id'],
        dataHora: DateTime.parse(json['dataHora']),
        faixaEtaria: json['faixaEtaria'],
        tipo: json['tipo'] ?? 'Consulta Médica', // CORRIGIDO AQUI
        observacao: json['observacao'] ?? '',
        indigenaCns: json['indigenaCns'] ?? '',
        agenteNome: json['agenteNome'] ?? 'Agente',
        sincronizado: json['sincronizado'] ?? false,
      );
}

class HomeScreen extends StatefulWidget {
  final AgenteFunai agente;

  const HomeScreen({
    super.key,
    required this.agente,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _buscaController = TextEditingController();

  final List<String> aldeias = const [
    'Todas as Aldeias',
    'Aguapeú',
    'Aldeinha',
    'Cerro Corá',
    'Itaóca Guarani',
    'Itaóca Tupi',
    'Paranapuã',
    'Rio Branco',
    'Tangará',
    'Tekoá-Miri',
  ];

  String aldeiaSelecionada = 'Todas as Aldeias';
  String buscaQuery = '';
  DateTime mesRelatorio = DateTime.now();

  List<Indigena> indigenas = [];
  List<Atendimento> atendimentos = [];
  bool estaOnline = false;

  @override
  void initState() {
    super.initState();
    _carregarDadosPersistidos();
    _monitorarConexao();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarDadosPersistidos() async {
    final prefs = await SharedPreferences.getInstance();

    final String? atdJson = prefs.getString('atendimentos_locais');
    if (atdJson != null && atdJson.isNotEmpty) {
      final List decoded = jsonDecode(atdJson);
      setState(() {
        atendimentos = decoded.map((e) => Atendimento.fromJson(e)).toList();
      });
    }

    final String? indJson = prefs.getString('indigenas_locais');
    if (indJson != null && indJson.isNotEmpty) {
      final List decoded = jsonDecode(indJson);
      setState(() {
        indigenas = decoded.map((e) => Indigena.fromJson(e)).toList();
      });
    } else {
      indigenas = [
        Indigena(
          nome: 'Kawy Tupinambá',
          cns: '700102030405060',
          idade: 4,
          faixaEtaria: '0-4',
          aldeiaAtual: 'Tekoá-Miri',
          vacinasTomadas: [
            Vacina(
              nome: 'BCG',
              dose: 'Dose Única',
              lote: 'BCG2023',
              dataAplicacao: DateTime.now().subtract(const Duration(days: 300)),
              aplicador: 'Enf. Juliana',
            ),
          ],
        ),
        Indigena(
          nome: 'Moara Guarani',
          cns: '800908070605040',
          idade: 28,
          faixaEtaria: '20-29',
          aldeiaAtual: 'Itaóca Tupi',
          vacinasTomadas: [],
        ),
      ];
      await _salvarIndigenasLocalmente();
    }
  }

  Future<void> _salvarAtendimentosLocalmente() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(atendimentos.map((a) => a.toJson()).toList());
    await prefs.setString('atendimentos_locais', encoded);
  }

  Future<void> _salvarIndigenasLocalmente() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(indigenas.map((i) => i.toJson()).toList());
    await prefs.setString('indigenas_locais', encoded);
  }

  void _monitorarConexao() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      bool online = (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet);

      setState(() => estaOnline = online);

      if (online) {
        _sincronizarComNuvem();
      }
    });
  }

  Future<void> _sincronizarComNuvem() async {
    final pendentes = atendimentos.where((a) => !a.sincronizado).toList();
    if (pendentes.isEmpty) return;

    final firestore = FirebaseFirestore.instance;

    for (var a in pendentes) {
      try {
        await firestore.collection('atendimentos').doc(a.id).set(a.toJson());
        setState(() {
          a.sincronizado = true;
        });
      } catch (e) {
        // Mantém pendente para próxima tentativa
      }
    }

    await _salvarAtendimentosLocalmente();

    if (mounted && pendentes.any((a) => a.sincronizado)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${pendentes.where((a) => a.sincronizado).length} atendimento(s) sincronizado(s) com a nuvem!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _registrarAtendimento(
      Indigena indigena, String tipo, String observacao) async {
    final novoAtendimento = Atendimento(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dataHora: DateTime.now(),
      faixaEtaria: indigena.faixaEtaria,
      tipo: tipo,
      observacao: observacao,
      indigenaCns: indigena.cns,
      agenteNome: widget.agente.nome,
      sincronizado: false,
    );

    setState(() {
      atendimentos.add(novoAtendimento);
    });

    await _salvarAtendimentosLocalmente();

    try {
      await FirebaseFirestore.instance
          .collection('atendimentos')
          .doc(novoAtendimento.id)
          .set(novoAtendimento.toJson());

      setState(() {
        novoAtendimento.sincronizado = true;
      });

      await _salvarAtendimentosLocalmente();
    } catch (e) {
      // Falha ao enviar fica gravada localmente e tentará novamente via listener de conectividade
    }
  }

  @override
  Widget build(BuildContext context) {
    int naoSincronizados = atendimentos.where((a) => !a.sincronizado).length;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF006A4E),
          foregroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Saúde Indígena',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Icon(
                    estaOnline ? Icons.wifi : Icons.wifi_off,
                    size: 16,
                    color: estaOnline ? Colors.greenAccent : Colors.orangeAccent,
                  ),
                ],
              ),
              Text(
                '${widget.agente.nome} (${widget.agente.cargo}) ${naoSincronizados > 0 ? "• $naoSincronizados pendentes" : ""}',
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.medical_services), text: 'Atendimentos'),
              Tab(icon: Icon(Icons.bar_chart), text: 'Relatório Mensal'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAbaAtendimentos(),
            _buildAbaRelatorios(),
          ],
        ),
      ),
    );
  }

  Widget _buildAbaAtendimentos() {
    final filtrados = indigenas.where((i) {
      final matchAldeia = aldeiaSelecionada == 'Todas as Aldeias' ||
          i.aldeiaAtual == aldeiaSelecionada;
      final queryLower = buscaQuery.toLowerCase();
      final matchQuery = i.nome.toLowerCase().contains(queryLower) ||
          i.cns.contains(buscaQuery);
      return matchAldeia && matchQuery;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: aldeiaSelecionada, // CORRIGIDO AQUI (substituído 'value' por 'initialValue')
            decoration: const InputDecoration(
              labelText: 'Selecione a Aldeia',
              border: OutlineInputBorder(),
            ),
            items: aldeias
                .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => aldeiaSelecionada = val);
              }
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _buscaController,
            decoration: const InputDecoration(
              labelText: 'Buscar por Nome ou CNS',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => setState(() => buscaQuery = val),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filtrados.isEmpty
                ? const Center(
                    child: Text('Nenhum indígena encontrado nesta aldeia.'),
                  )
                : ListView.builder(
                    itemCount: filtrados.length,
                    itemBuilder: (context, index) {
                      final item = filtrados[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            item.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Aldeia: ${item.aldeiaAtual}\nCNS: ${item.cns}\nIdade: ${item.idade} anos (Faixa: ${item.faixaEtaria})',
                          ),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              OutlinedButton.icon(
                                icon: const Icon(Icons.vaccines,
                                    color: Colors.teal, size: 18),
                                label: const Text('Vacinas'),
                                onPressed: () => _abrirCartaoVacina(item),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF006A4E),
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Atender'),
                                onPressed: () => _abrirModalAtendimento(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _abrirCartaoVacina(Indigena indigena) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.85,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Cartão de Vacinas: ${indigena.nome}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(),
              const Text(
                'Vacinas Aplicadas:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: indigena.vacinasTomadas.isEmpty
                    ? const Center(
                        child: Text('Nenhuma vacina registrada ainda.'),
                      )
                    : ListView.builder(
                        itemCount: indigena.vacinasTomadas.length,
                        itemBuilder: (context, i) {
                          final v = indigena.vacinasTomadas[i];
                          final dia =
                              v.dataAplicacao.day.toString().padLeft(2, '0');
                          final mes =
                              v.dataAplicacao.month.toString().padLeft(2, '0');
                          final ano = v.dataAplicacao.year;

                          return Card(
                            color: Colors.green.shade50,
                            child: ListTile(
                              leading: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              title: Text('${v.nome} - ${v.dose}'),
                              subtitle: Text(
                                'Lote: ${v.lote} | Data: $dia/$mes/$ano\nAplicador: ${v.aplicador}',
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAbaRelatorios() {
    final atdMes = atendimentos.where((a) =>
        a.dataHora.year == mesRelatorio.year &&
        a.dataHora.month == mesRelatorio.month).toList();

    final meusAtdMes = atdMes.where((a) => a.agenteNome == widget.agente.nome).toList();

    final Map<String, int> faixas = {
      '0-4': 0,
      '5-9': 0,
      '10-19': 0,
      '20-29': 0,
      '30-59': 0,
      '60+': 0,
    };

    for (var a in atdMes) {
      if (faixas.containsKey(a.faixaEtaria)) {
        faixas[a.faixaEtaria] = faixas[a.faixaEtaria]! + 1;
      }
    }

    final mesNome = _getMesNome(mesRelatorio.month);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mês: $mesNome / ${mesRelatorio.year}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: const Text('Alterar Mês'),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: mesRelatorio,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    helpText: 'Selecione qualquer dia do mês desejado',
                  );
                  if (picked != null) {
                    setState(() => mesRelatorio = picked);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.teal.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const Text(
                          'Meus Atendimentos',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${meusAtdMes.length}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF006A4E),
                          ),
                        ),
                        Text(
                          'Agente: ${widget.agente.nome}',
                          style: const TextStyle(fontSize: 10, color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const Text(
                          'Total Geral das Aldeias',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${atdMes.length}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const Text(
                          'Todos os Agentes',
                          style: TextStyle(fontSize: 10, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Atendimentos por Faixa Etária (Mês):',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: faixas.entries
                .map((e) => Chip(
                      label: Text('${e.key}: ${e.value}'),
                      backgroundColor: Colors.teal.shade100,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  String _getMesNome(int mes) {
    const meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    return meses[mes - 1];
  }

  void _abrirModalAtendimento(Indigena indigena) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return _ModalAtendimentoDialog(
          indigena: indigena,
          onSalvar: (tipo, obs) async {
            await _registrarAtendimento(indigena, tipo, obs);
          },
        );
      },
    );
  }
}

class _ModalAtendimentoDialog extends StatefulWidget {
  final Indigena indigena;
  final Future<void> Function(String tipo, String obs) onSalvar;

  const _ModalAtendimentoDialog({
    required this.indigena,
    required this.onSalvar,
  }); // CORRIGIDO AQUI (removido super.key não utilizado)

  @override
  State<_ModalAtendimentoDialog> createState() =>
      _ModalAtendimentoDialogState();
}

class _ModalAtendimentoDialogState extends State<_ModalAtendimentoDialog> {
  final _obsController = TextEditingController();
  String _tipoSelecionado = 'Consulta Médica';
  bool _carregando = false;

  final List<String> _tiposAtendimento = const [
    'Consulta Médica',
    'Odontologia',
    'Enfermagem',
    'Acompanhamento',
  ];

  @override
  void dispose() {
    _obsController.dispose();
    super.dispose();
  }

  Future<void> _submeterFormulario() async {
    setState(() => _carregando = true);

    try {
      await widget.onSalvar(_tipoSelecionado, _obsController.text.trim());

      if (!mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Atendimento registrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao registrar atendimento: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Atender: ${widget.indigena.nome}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _tipoSelecionado, // CORRIGIDO AQUI (substituído 'value' por 'initialValue')
              decoration:
                  const InputDecoration(labelText: 'Tipo de Atendimento'),
              items: _tiposAtendimento
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: _carregando
                  ? null
                  : (v) {
                      if (v != null) setState(() => _tipoSelecionado = v);
                    },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _obsController,
              enabled: !_carregando,
              decoration: const InputDecoration(
                labelText: 'Observações / Diagnóstico',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _carregando ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006A4E),
            foregroundColor: Colors.white,
          ),
          onPressed: _carregando ? null : _submeterFormulario,
          child: _carregando
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Salvar Atendimento'),
        ),
      ],
    );
  }
}