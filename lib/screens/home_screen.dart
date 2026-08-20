import 'package:flutter/material.dart';
import '../main.dart';

// Oculta Indigena e Atendimento do Drift para evitar conflitos de nome com os modelos de dominio
import '../database/app_database.dart' hide Indigena, Atendimento; 

import '../models/agente_funai.dart';
import '../models/atendimento.dart';
import '../models/indigena.dart';

class HomeScreen extends StatefulWidget {
  final AgenteFunai agente;
  const HomeScreen({super.key, required this.agente});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> aldeias = const [
    'Aldeinha', 'Itaoca Guarani', 'Itaoca Tupi', 'Tekoa',
    'Yakã', 'Arapyau', 'Nhanderú-Pó', 'Ka\'aguy Mirim', 'Barigui'
  ];

  String aldeiaSelecionada = 'Aldeinha';
  String buscaQuery = '';
  DateTime dataRelatorio = DateTime.now();

  List<Indigena> indigenas = [];
  List<Atendimento> atendimentos = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => carregando = true);
    final aldeiaId = aldeias.indexOf(aldeiaSelecionada) + 1;

    final indigenasDoBanco = await database.listarIndigenasPorAldeia(aldeiaId);

    final listaConvertida = indigenasDoBanco.map((i) {
      return Indigena(
        id: i.id.toString(),
        nome: i.nome,
        cns: i.cns,
        dataNascimento: i.dataNascimento,
        aldeiaAtual: aldeiaSelecionada,
        vacinasTomadas: [],
      );
    }).toList();

    setState(() {
      indigenas = listaConvertida;
      carregando = false;
    });
  }

  Future<void> _registrarAtendimento(Indigena indigena, String tipo, String obs) async {
    final aldeiaId = aldeias.indexOf(indigena.aldeiaAtual) + 1;
    final agora = DateTime.now();
    final String idGeradoStr = agora.millisecondsSinceEpoch.toString();

    // Passa 'id' e 'indigenaId' estritamente como String para alinhar com o Drift
    await database.into(database.atendimentos).insert(
      AtendimentosCompanion.insert(
        id: idGeradoStr,
        indigenaId: indigena.id,
        aldeiaId: aldeiaId,
        tipoAtendimento: tipo,
        dataHora: agora,
        observacoes: obs,
      ),
    );

    final novoAtendimento = Atendimento(
      id: idGeradoStr,
      indigenaId: indigena.id,
      nomeIndigena: indigena.nome,
      cnsIndigena: indigena.cns,
      aldeia: indigena.aldeiaAtual,
      tipoAtendimento: tipo,
      idade: indigena.idade,
      faixaEtaria: indigena.faixaEtaria,
      observacoes: obs,
      dataHora: agora,
    );

    setState(() {
      atendimentos.add(novoAtendimento);
    });
  }

  int get atendimentosHoje {
    final hoje = DateTime.now();
    return atendimentos.where((a) =>
      a.dataHora.year == hoje.year &&
      a.dataHora.month == hoje.month &&
      a.dataHora.day == hoje.day
    ).length;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Saúde Indígena App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${widget.agente.nome} (${widget.agente.matricula})', style: const TextStyle(fontSize: 12, color: Colors.white70)),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Center(
                child: Chip(
                  avatar: const Icon(Icons.check_circle, size: 16),
                  label: Text('Hoje: $atendimentosHoje'),
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(icon: Icon(Icons.medical_services), text: 'Atendimentos'),
              Tab(icon: Icon(Icons.analytics), text: 'Relatórios'),
            ],
          ),
        ),
        body: carregando
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
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
      final matchAldeia = i.aldeiaAtual == aldeiaSelecionada;
      final matchQuery = i.nome.toLowerCase().contains(buscaQuery.toLowerCase()) ||
          i.cns.contains(buscaQuery);
      return matchAldeia && matchQuery;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: aldeiaSelecionada,
            decoration: const InputDecoration(labelText: 'Selecione a Aldeia', border: OutlineInputBorder()),
            items: aldeias.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => aldeiaSelecionada = val);
                _carregarDados();
              }
            },
          ),
          const SizedBox(height: 12),
          TextField(
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
                ? const Center(child: Text('Nenhum indígena encontrado nesta aldeia.'))
                : ListView.builder(
                    itemCount: filtrados.length,
                    itemBuilder: (context, index) {
                      final item = filtrados[index];
                      return Card(
                        child: ListTile(
                          title: Text(item.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('CNS: ${item.cns}\nIdade: ${item.idade} anos (${item.faixaEtaria})'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OutlinedButton.icon(
                                icon: const Icon(Icons.vaccines, color: Colors.teal),
                                label: const Text('Vacinas'),
                                onPressed: () => _abrirCartaoVacina(item),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
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
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const Divider(),
                const Text('Vacinas Aplicadas:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 8),
                Expanded(
                  flex: 1,
                  child: indigena.vacinasTomadas.isEmpty
                      ? const Center(child: Text('Nenhuma vacina registrada ainda.'))
                      : ListView.builder(
                          itemCount: indigena.vacinasTomadas.length,
                          itemBuilder: (context, i) {
                            final v = indigena.vacinasTomadas[i];
                            return Card(
                              color: Colors.green.shade50,
                              child: ListTile(
                                leading: const Icon(Icons.check_circle, color: Colors.green),
                                title: Text('${v.nome} - ${v.dose}'),
                                subtitle: Text('Lote: ${v.lote} | Data: ${v.dataAplicacao.day}/${v.dataAplicacao.month}/${v.dataAplicacao.year}\nAplicador: ${v.aplicador}'),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAbaRelatorios() {
    final atdData = atendimentos.where((a) =>
      a.dataHora.year == dataRelatorio.year &&
      a.dataHora.month == dataRelatorio.month &&
      a.dataHora.day == dataRelatorio.day
    ).toList();

    // Dicionário atualizado com as novas faixas etárias da FUNAI
    final Map<String, int> faixas = {
      '0 a 4 anos': 0,
      '5 a 9 anos': 0,
      '10 a 19 anos': 0,
      '20 a 29 anos': 0,
      '30 a 59 anos': 0,
      '60+': 0,
    };

    for (var a in atdData) {
      if (faixas.containsKey(a.faixaEtaria)) {
        faixas[a.faixaEtaria] = faixas[a.faixaEtaria]! + 1;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Data: ${dataRelatorio.day.toString().padLeft(2, '0')}/${dataRelatorio.month.toString().padLeft(2, '0')}/${dataRelatorio.year}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  const Text('Total de Atendimentos:', style: TextStyle(fontSize: 16)),
                  Text('${atdData.length}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Distribuição por Faixa Etária:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: faixas.entries.map((e) => Chip(
              label: Text('${e.key}: ${e.value}'),
              backgroundColor: Colors.teal.shade100,
            )).toList(),
          ),
        ],
      ),
    );
  }

  void _abrirModalAtendimento(Indigena indigena) {
    String tipo = 'Consulta Médica';
    final obsController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Atender: ${indigena.nome}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: tipo,
              decoration: const InputDecoration(labelText: 'Tipo de Atendimento'),
              items: ['Consulta Médica', 'Odontologia', 'Enfermagem', 'Acompanhamento']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) { if (v != null) tipo = v; },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: obsController,
              decoration: const InputDecoration(labelText: 'Observações / Diagnóstico'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), 
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(dialogContext);

              await _registrarAtendimento(indigena, tipo, obsController.text);

              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Atendimento registrado com sucesso!')),
              );
            },
            child: const Text('Salvar Atendimento'),
          ),
        ],
      ),
    );
  }
}