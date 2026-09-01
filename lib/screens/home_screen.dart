import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/agente_funai.dart';
import '../models/atendimento.dart';
import '../models/indigena.dart';
import 'vacinas_screens.dart';

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
  final TextEditingController _buscaController =
      TextEditingController();

  StreamSubscription<List<ConnectivityResult>>?
      _conexaoSubscription;

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
    _conexaoSubscription?.cancel();
    _buscaController.dispose();
    super.dispose();
  }

  // ============================================================
  // GETTERS - VACINAS PENDENTES
  // ============================================================

  int get _totalVacinasPendentes {
    int total = 0;

    for (final indigena in indigenas) {
      total += indigena.vacinasPendentes.length;
    }

    return total;
  }

  int get _totalIndigenasComPendencias {
    return indigenas
        .where(
          (indigena) =>
              indigena.vacinasPendentes.isNotEmpty,
        )
        .length;
  }

  // ============================================================
  // CARREGAMENTO DOS DADOS
  // ============================================================

  Future<void> _carregarDadosPersistidos() async {
    final prefs = await SharedPreferences.getInstance();

    // ------------------------------------------------------------
    // ATENDIMENTOS
    // ------------------------------------------------------------

    final String? atdJson =
        prefs.getString('atendimentos_locais');

    if (atdJson != null && atdJson.isNotEmpty) {
      try {
        final dynamic decoded = jsonDecode(atdJson);

        if (decoded is List) {
          final listaAtendimentos = decoded
              .whereType<Map>()
              .map(
                (item) => Atendimento.fromMap(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList();

          if (mounted) {
            setState(() {
              atendimentos = listaAtendimentos;
            });
          }
        }
      } catch (e) {
        debugPrint(
          'Erro ao carregar atendimentos locais: $e',
        );
      }
    }

    // ------------------------------------------------------------
    // INDÍGENAS
    // ------------------------------------------------------------

    final String? indJson =
        prefs.getString('indigenas_locais');

    if (indJson != null && indJson.isNotEmpty) {
      try {
        final dynamic decoded = jsonDecode(indJson);

        if (decoded is List) {
          final listaIndigenas = decoded
              .whereType<Map>()
              .map(
                (item) => Indigena.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList();

          if (mounted) {
            setState(() {
              indigenas = listaIndigenas;
            });
          }
        }
      } catch (e) {
        debugPrint(
          'Erro ao carregar indígenas locais: $e',
        );
      }
    } else {
      // Dados iniciais de demonstração
      indigenas = [
        Indigena(
          id: '1',
          cns: '700102030405060',
          nome: 'Kawy Tupinambá',
          aldeiaAtual: 'Tekoá-Miri',
          dataNascimento: DateTime.now().subtract(
            const Duration(days: 4 * 365),
          ),
          vacinasTomadas: [],
        ),
        Indigena(
          id: '2',
          cns: '800908070605040',
          nome: 'Moara Guarani',
          aldeiaAtual: 'Itaóca Tupi',
          dataNascimento: DateTime.now().subtract(
            const Duration(days: 28 * 365),
          ),
          vacinasTomadas: [],
        ),
      ];

      await _salvarIndigenasLocalmente();

      if (mounted) {
        setState(() {});
      }
    }
  }

  // ============================================================
  // PERSISTÊNCIA LOCAL
  // ============================================================

  Future<void> _salvarAtendimentosLocalmente() async {
    final prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> dadosLocais =
        atendimentos
            .map(
              (atendimento) =>
                  atendimento.toLocalMap(),
            )
            .toList();

    final String encoded = jsonEncode(dadosLocais);

    await prefs.setString(
      'atendimentos_locais',
      encoded,
    );
  }

  Future<void> _salvarIndigenasLocalmente() async {
    final prefs = await SharedPreferences.getInstance();

    final String encoded = jsonEncode(
      indigenas
          .map(
            (indigena) => indigena.toJson(),
          )
          .toList(),
    );

    await prefs.setString(
      'indigenas_locais',
      encoded,
    );
  }

  // ============================================================
  // CONEXÃO
  // ============================================================

  Future<void> _monitorarConexao() async {
    try {
      final List<ConnectivityResult> resultados =
          await Connectivity().checkConnectivity();

      _atualizarStatusConexao(resultados);

      _conexaoSubscription =
          Connectivity().onConnectivityChanged.listen(
        (List<ConnectivityResult> resultados) {
          _atualizarStatusConexao(resultados);
        },
      );
    } catch (e) {
      debugPrint(
        'Erro ao verificar conexão: $e',
      );

      if (mounted) {
        setState(() {
          estaOnline = false;
        });
      }
    }
  }

  void _atualizarStatusConexao(
    List<ConnectivityResult> resultados,
  ) {
    final bool online = resultados.any(
      (resultado) =>
          resultado == ConnectivityResult.mobile ||
          resultado == ConnectivityResult.wifi ||
          resultado == ConnectivityResult.ethernet,
    );

    if (!mounted) return;

    setState(() {
      estaOnline = online;
    });

    if (online) {
      _sincronizarComNuvem();
    }
  }

  // ============================================================
  // SINCRONIZAÇÃO COM FIREBASE
  // ============================================================

  Future<void> _sincronizarComNuvem() async {
    final firestore = FirebaseFirestore.instance;

    int sincronizados = 0;

    for (final atendimento in atendimentos) {
      if (atendimento.sincronizado) {
        continue;
      }

      try {
        await firestore
            .collection('atendimentos')
            .doc(atendimento.id)
            .set(
              atendimento.toMap(),
            );

        atendimento.sincronizado = true;
        sincronizados++;
      } catch (e) {
        debugPrint(
          'Erro ao sincronizar atendimento '
          '${atendimento.id}: $e',
        );
      }
    }

    if (sincronizados > 0) {
      await _salvarAtendimentosLocalmente();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$sincronizados atendimento(s) '
            'sincronizado(s) com a nuvem.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // ============================================================
  // REGISTRAR ATENDIMENTO
  // ============================================================

  Future<void> _registrarAtendimento(
    Indigena indigena,
    String tipo,
    String observacao,
  ) async {
    final novoAtendimento = Atendimento(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      indigenaId: indigena.id,
      nomeIndigena: indigena.nome,
      cnsIndigena: indigena.cns,
      aldeia: indigena.aldeiaAtual,
      tipoAtendimento: tipo,
      idade: indigena.idade,
      faixaEtaria: indigena.faixaEtaria,
      observacoes: observacao,
      dataHora: DateTime.now(),
      agenteMatricula: widget.agente.matricula,
      sincronizado: false,
    );

    // ------------------------------------------------------------
    // 1. SALVA PRIMEIRO NO CELULAR
    // ------------------------------------------------------------

    setState(() {
      atendimentos.add(novoAtendimento);
    });

    await _salvarAtendimentosLocalmente();

    // ------------------------------------------------------------
    // 2. TENTA ENVIAR PARA O FIREBASE
    // ------------------------------------------------------------

    try {
      await FirebaseFirestore.instance
          .collection('atendimentos')
          .doc(novoAtendimento.id)
          .set(
            novoAtendimento.toMap(),
          );

      novoAtendimento.sincronizado = true;

      await _salvarAtendimentosLocalmente();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Atendimento registrado e '
            'sincronizado com a nuvem!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint(
        'Atendimento salvo localmente. '
        'Erro Firebase: $e',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Atendimento salvo localmente. '
            'Será sincronizado quando houver conexão.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // ============================================================
  // RELATÓRIO - GERAR TEXTO
  // ============================================================

  String _gerarRelatorioTexto() {
    final atdMes = atendimentos.where((atendimento) {
      return atendimento.dataHora.year ==
              mesRelatorio.year &&
          atendimento.dataHora.month ==
              mesRelatorio.month;
    }).toList();

    final meusAtdMes = atdMes.where((atendimento) {
      return atendimento.agenteMatricula ==
          widget.agente.matricula;
    }).toList();

    final Map<String, int> faixas = {
      '0 a 4 anos': 0,
      '5 a 9 anos': 0,
      '10 a 19 anos': 0,
      '20 a 29 anos': 0,
      '30 a 59 anos': 0,
      '60+': 0,
    };

    for (final atendimento in atdMes) {
      if (faixas.containsKey(
        atendimento.faixaEtaria,
      )) {
        faixas[atendimento.faixaEtaria] =
            faixas[atendimento.faixaEtaria]! + 1;
      }
    }

    final String mesNome =
        _getMesNome(mesRelatorio.month);

    final buffer = StringBuffer();

    buffer.writeln(
      'RELATÓRIO MENSAL - SAÚDE INDÍGENA',
    );
    buffer.writeln(
      '=================================',
    );
    buffer.writeln(
      'Mês: $mesNome / ${mesRelatorio.year}',
    );
    buffer.writeln(
      'Agente: ${widget.agente.nome}',
    );
    buffer.writeln(
      'Cargo: ${widget.agente.cargo ?? 'Agente FUNAI'}',
    );

    buffer.writeln();

    buffer.writeln('ATENDIMENTOS');
    buffer.writeln('------------');
    buffer.writeln(
      'Meus atendimentos: ${meusAtdMes.length}',
    );
    buffer.writeln(
      'Total geral: ${atdMes.length}',
    );

    buffer.writeln();

    buffer.writeln(
      'ATENDIMENTOS POR FAIXA ETÁRIA',
    );
    buffer.writeln(
      '-----------------------------',
    );

    for (final entry in faixas.entries) {
      buffer.writeln(
        '${entry.key}: ${entry.value}',
      );
    }

    buffer.writeln();

    buffer.writeln('VACINAÇÃO');
    buffer.writeln('---------');

    buffer.writeln(
      'Indígenas com vacinas pendentes: '
      '$_totalIndigenasComPendencias',
    );

    buffer.writeln(
      'Total de vacinas pendentes: '
      '$_totalVacinasPendentes',
    );

    buffer.writeln();

    buffer.writeln(
      'Relatório gerado pelo aplicativo '
      'Saúde Indígena.',
    );

    return buffer.toString();
  }

  // ============================================================
  // COMPARTILHAR RELATÓRIO
  // ============================================================

  Future<void> _compartilharRelatorio() async {
    await Clipboard.setData(
      ClipboardData(
        text: _gerarRelatorioTexto(),
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Relatório copiado. Você pode colar e '
          'compartilhar onde quiser.',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              const Color(0xFF006A4E),
          foregroundColor: Colors.white,
          title: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Saúde Indígena',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    estaOnline
                        ? Icons.wifi
                        : Icons.wifi_off,
                    size: 16,
                    color: estaOnline
                        ? Colors.greenAccent
                        : Colors.orangeAccent,
                  ),
                ],
              ),
              Text(
                '${widget.agente.nome} '
                '(${widget.agente.cargo ?? 'Agente FUNAI'})',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor:
                Colors.white70,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.medical_services,
                ),
                text: 'Atendimentos',
              ),
              Tab(
                icon: Icon(Icons.bar_chart),
                text: 'Relatório Mensal',
              ),
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

  // ============================================================
  // ABA ATENDIMENTOS
  // ============================================================

  Widget _buildAbaAtendimentos() {
    final filtrados =
        indigenas.where((indigena) {
      final bool matchAldeia =
          aldeiaSelecionada ==
                  'Todas as Aldeias' ||
              indigena.aldeiaAtual ==
                  aldeiaSelecionada;

      final String queryLower =
          buscaQuery.toLowerCase().trim();

      final bool matchQuery =
          indigena.nome
                  .toLowerCase()
                  .contains(queryLower) ||
              indigena.cns.contains(
                buscaQuery.trim(),
              );

      return matchAldeia && matchQuery;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: aldeiaSelecionada,
            decoration: const InputDecoration(
              labelText: 'Selecione a Aldeia',
              border: OutlineInputBorder(),
              prefixIcon:
                  Icon(Icons.home),
            ),
            items: aldeias
                .map(
                  (aldeia) =>
                      DropdownMenuItem<String>(
                    value: aldeia,
                    child: Text(aldeia),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                aldeiaSelecionada = value;
              });
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _buscaController,
            decoration: const InputDecoration(
              labelText:
                  'Buscar por Nome ou CNS',
              prefixIcon:
                  Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                buscaQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filtrados.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum indígena encontrado '
                      'nesta aldeia.',
                    ),
                  )
                : ListView.builder(
                    itemCount: filtrados.length,
                    itemBuilder:
                        (context, index) {
                      final item =
                          filtrados[index];

                      return Card(
                        elevation: 2,
                        margin:
                            const EdgeInsets
                                .symmetric(
                          vertical: 6,
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.all(
                            12,
                          ),
                          title: Text(
                            item.nome,
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding:
                                const EdgeInsets.only(
                              top: 6,
                            ),
                            child: Text(
                              'Aldeia: ${item.aldeiaAtual}\n'
                              'CNS: ${item.cns}\n'
                              'Idade: ${item.idade} anos\n'
                              'Faixa etária: ${item.faixaEtaria}',
                            ),
                          ),
                          trailing: Wrap(
                            spacing: 8,
                            children: [
                              OutlinedButton.icon(
                                icon:
                                    const Icon(
                                  Icons.vaccines,
                                  color:
                                      Colors.teal,
                                  size: 18,
                                ),
                                label:
                                    const Text(
                                  'Vacinas',
                                ),
                                onPressed: () {
                                  _abrirCartaoVacina(
                                    item,
                                  );
                                },
                              ),
                              ElevatedButton.icon(
                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      const Color(
                                    0xFF006A4E,
                                  ),
                                  foregroundColor:
                                      Colors.white,
                                ),
                                icon:
                                    const Icon(
                                  Icons.add,
                                  size: 18,
                                ),
                                label:
                                    const Text(
                                  'Atender',
                                ),
                                onPressed: () {
                                  _abrirModalAtendimento(
                                    item,
                                  );
                                },
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

  // ============================================================
  // TELA DE VACINAS
  // ============================================================

  Future<void> _abrirCartaoVacina(
    Indigena indigena,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VacinasScreen(
          agente: widget.agente,
          indigena: indigena,
          onVacinaAplicada:
              (indigenaAtualizado) async {
            await _salvarIndigenasLocalmente();

            if (!mounted) return;

            setState(() {});
          },
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // RELATÓRIO MENSAL
  // ============================================================

  Widget _buildAbaRelatorios() {
    final atdMes = atendimentos.where(
      (atendimento) {
        return atendimento.dataHora.year ==
                mesRelatorio.year &&
            atendimento.dataHora.month ==
                mesRelatorio.month;
      },
    ).toList();

    final meusAtdMes = atdMes.where(
      (atendimento) {
        return atendimento.agenteMatricula ==
            widget.agente.matricula;
      },
    ).toList();

    final Map<String, int> faixas = {
      '0 a 4 anos': 0,
      '5 a 9 anos': 0,
      '10 a 19 anos': 0,
      '20 a 29 anos': 0,
      '30 a 59 anos': 0,
      '60+': 0,
    };

    for (final atendimento in atdMes) {
      if (faixas.containsKey(
        atendimento.faixaEtaria,
      )) {
        faixas[atendimento.faixaEtaria] =
            faixas[atendimento.faixaEtaria]! + 1;
      }
    }

    final String mesNome =
        _getMesNome(mesRelatorio.month);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Mês: $mesNome / '
                  '${mesRelatorio.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.calendar_month,
                ),
                label:
                    const Text('Alterar Mês'),
                onPressed: () async {
                  final picked =
                      await showDatePicker(
                    context: context,
                    initialDate:
                        mesRelatorio,
                    firstDate:
                        DateTime(2020),
                    lastDate:
                        DateTime.now(),
                    helpText:
                        'Selecione qualquer dia '
                        'do mês desejado',
                  );

                  if (picked != null) {
                    setState(() {
                      mesRelatorio = picked;
                    });
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
                  color:
                      Colors.teal.shade50,
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      12,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Meus Atendimentos',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                FontWeight.bold,
                          ),
                          textAlign:
                              TextAlign.center,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          '${meusAtdMes.length}',
                          style:
                              const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                            color: Color(
                              0xFF006A4E,
                            ),
                          ),
                        ),
                        Text(
                          'Agente: '
                          '${widget.agente.nome}',
                          style:
                              const TextStyle(
                            fontSize: 10,
                            color:
                                Colors.black54,
                          ),
                          overflow:
                              TextOverflow
                                  .ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Card(
                  color:
                      Colors.blue.shade50,
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      12,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Total Geral das Aldeias',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                FontWeight.bold,
                          ),
                          textAlign:
                              TextAlign.center,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          '${atdMes.length}',
                          style:
                              const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Colors.blueAccent,
                          ),
                        ),
                        const Text(
                          'Todos os Agentes',
                          style:
                              TextStyle(
                            fontSize: 10,
                            color:
                                Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ======================================================
          // VACINAS PENDENTES
          // ======================================================

          Row(
            children: [
              Expanded(
                child: Card(
                  color:
                      Colors.orange.shade50,
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      12,
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.vaccines,
                          color:
                              Colors.orange,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Text(
                          'Vacinas Pendentes',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                FontWeight.bold,
                          ),
                          textAlign:
                              TextAlign.center,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          '$_totalVacinasPendentes',
                          style:
                              const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Card(
                  color:
                      Colors.red.shade50,
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      12,
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.people,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Text(
                          'Indígenas com Pendências',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                FontWeight.bold,
                          ),
                          textAlign:
                              TextAlign.center,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          '$_totalIndigenasComPendencias',
                          style:
                              const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                            color: Colors.red,
                          ),
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
            style: TextStyle(
              fontSize: 15,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: faixas.entries
                .map(
                  (entry) => Chip(
                    label: Text(
                      '${entry.key}: '
                      '${entry.value}',
                    ),
                    backgroundColor:
                        Colors.teal.shade100,
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 24),

          // ======================================================
          // BOTÃO COPIAR RELATÓRIO
          // ======================================================

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFF006A4E,
                ),
                foregroundColor:
                    Colors.white,
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),
              icon: const Icon(
                Icons.content_copy,
              ),
              label: const Text(
                'Copiar Relatório',
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              onPressed:
                  _compartilharRelatorio,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ============================================================
  // MESES
  // ============================================================

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
      'Dezembro',
    ];

    if (mes < 1 || mes > 12) {
      return '';
    }

    return meses[mes - 1];
  }

  // ============================================================
  // MODAL DE ATENDIMENTO
  // ============================================================

  void _abrirModalAtendimento(
    Indigena indigena,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return _ModalAtendimentoDialog(
          indigena: indigena,
          onSalvar: (
            tipo,
            observacao,
          ) async {
            await _registrarAtendimento(
              indigena,
              tipo,
              observacao,
            );
          },
        );
      },
    );
  }
}

// ==================================================================
// MODAL DE ATENDIMENTO
// ==================================================================

class _ModalAtendimentoDialog
    extends StatefulWidget {
  final Indigena indigena;

  final Future<void> Function(
    String tipo,
    String observacao,
  ) onSalvar;

  const _ModalAtendimentoDialog({
    required this.indigena,
    required this.onSalvar,
  });

  @override
  State<_ModalAtendimentoDialog> createState() =>
      _ModalAtendimentoDialogState();
}

class _ModalAtendimentoDialogState
    extends State<_ModalAtendimentoDialog> {
  final TextEditingController
      _obsController =
      TextEditingController();

  String _tipoSelecionado =
      'Consulta Médica';

  bool _carregando = false;

  final List<String> _tiposAtendimento =
      const [
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
    if (_carregando) return;

    setState(() {
      _carregando = true;
    });

    try {
      await widget.onSalvar(
        _tipoSelecionado,
        _obsController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao registrar atendimento: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Atender: '
        '${widget.indigena.nome}',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue:
                  _tipoSelecionado,
              decoration:
                  const InputDecoration(
                labelText:
                    'Tipo de Atendimento',
                border:
                    OutlineInputBorder(),
              ),
              items:
                  _tiposAtendimento
                      .map(
                        (tipo) =>
                            DropdownMenuItem<
                                String>(
                          value: tipo,
                          child: Text(tipo),
                        ),
                      )
                      .toList(),
              onChanged: _carregando
                  ? null
                  : (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        _tipoSelecionado =
                            value;
                      });
                    },
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  _obsController,
              enabled: !_carregando,
              decoration:
                  const InputDecoration(
                labelText:
                    'Observações / Diagnóstico',
                border:
                    OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _carregando
              ? null
              : () {
                  Navigator.pop(context);
                },
          child:
              const Text('Cancelar'),
        ),

        ElevatedButton(
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF006A4E),
            foregroundColor:
                Colors.white,
          ),
          onPressed: _carregando
              ? null
              : _submeterFormulario,
          child: _carregando
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Salvar Atendimento',
                ),
        ),
      ],
    );
  }
}