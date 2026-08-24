import 'package:flutter/material.dart'
    show
        AlertDialog,
        AppBar,
        BorderRadius,
        BuildContext,
        Card,
        Center,
        Chip,
        CircularProgressIndicator,
        Color,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        DefaultTabController,
        Divider,
        DropdownButtonFormField,
        DropdownMenuItem,
        EdgeInsets,
        ElevatedButton,
        Expanded,
        FontWeight,
        Icon,
        IconButton,
        Icons,
        InputDecoration,
        ListTile,
        ListView,
        MainAxisAlignment,
        MainAxisSize,
        MediaQuery,
        Navigator,
        OutlineInputBorder,
        OutlinedButton,
        Padding,
        Radius,
        RoundedRectangleBorder,
        Row,
        Scaffold,
        ScaffoldMessenger,
        SingleChildScrollView,
        SizedBox,
        SnackBar,
        State,
        StatefulWidget,
        Tab,
        TabBar,
        TabBarView,
        Text,
        TextButton,
        TextEditingController,
        TextField,
        TextOverflow,
        TextStyle,
        Widget,
        Wrap,
        showDatePicker,
        showDialog,
        showModalBottomSheet;
import '../models/agente_funai.dart';

// --- CLASSES DE MODELO ---

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
}

class Atendimento {
  final DateTime dataHora;
  final String faixaEtaria;
  final String tipo;

  Atendimento({
    required this.dataHora,
    required this.faixaEtaria,
    required this.tipo,
  });
}

// --- TELA PRINCIPAL (HomeScreen) ---

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

  // Lista oficial de aldeias do DSEI Litoral Sul / SESAI
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
  DateTime dataRelatorio = DateTime.now();

  List<Indigena> indigenas = [];
  List<Atendimento> atendimentos = [];

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  void _carregarDadosIniciais() {
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

    atendimentos = [
      Atendimento(
        dataHora: DateTime.now(),
        faixaEtaria: '0-4',
        tipo: 'Consulta Médica',
      ),
    ];
  }

  Future<void> _registrarAtendimento(
      Indigena indigena, String tipo, String observacao) async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      atendimentos.add(
        Atendimento(
          dataHora: DateTime.now(),
          faixaEtaria: indigena.faixaEtaria,
          tipo: tipo,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF006A4E),
          foregroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Saúde Indígena',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                '${widget.agente.nome} (${widget.agente.cargo})',
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
              Tab(icon: Icon(Icons.bar_chart), text: 'Relatórios'),
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
            initialValue: aldeiaSelecionada,
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
    final atdData = atendimentos
        .where((a) =>
            a.dataHora.year == dataRelatorio.year &&
            a.dataHora.month == dataRelatorio.month &&
            a.dataHora.day == dataRelatorio.day)
        .toList();

    // Faixas etárias exatamente iguais ao formulário da SESAI
    final Map<String, int> faixas = {
      '0-4': 0,
      '5-9': 0,
      '10-19': 0,
      '20-29': 0,
      '30-59': 0,
      '60+': 0,
    };

    for (var a in atdData) {
      final faixa = a.faixaEtaria;
      if (faixas.containsKey(faixa)) {
        faixas[faixa] = faixas[faixa]! + 1;
      }
    }

    final dia = dataRelatorio.day.toString().padLeft(2, '0');
    final mes = dataRelatorio.month.toString().padLeft(2, '0');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Data: $dia/$mes/${dataRelatorio.year}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text('Alterar Data'),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: dataRelatorio,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => dataRelatorio = picked);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Total de Atendimentos:',
                      style: TextStyle(fontSize: 16)),
                  Text(
                    '${atdData.length}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Distribuição por Faixa Etária (DSEI):',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
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

// --- DIÁLOGO DE ATENDIMENTO ---

class _ModalAtendimentoDialog extends StatefulWidget {
  final Indigena indigena;
  final Future<void> Function(String tipo, String obs) onSalvar;

  const _ModalAtendimentoDialog({
    required this.indigena,
    required this.onSalvar,
  });

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Atender: ${widget.indigena.nome}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _tipoSelecionado,
              decoration:
                  const InputDecoration(labelText: 'Tipo de Atendimento'),
              items: _tiposAtendimento
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _tipoSelecionado = v);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _obsController,
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
          onPressed: _carregando
              ? null
              : () async {
                  setState(() => _carregando = true);

                  await widget.onSalvar(_tipoSelecionado, _obsController.text);

                  if (!context.mounted) return;

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Atendimento registrado com sucesso!'),
                    ),
                  );
                },
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