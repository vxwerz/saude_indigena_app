import 'package:flutter/material.dart';
import '../models/agente_funai.dart';
import '../models/atendimento.dart';
import '../models/indigena.dart';
import '../services/storage_service.dart';

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
    final indigenasCarregados = await StorageService.carregarIndigenas();
    final atendimentosCarregados = await StorageService.carregarAtendimentos();

    setState(() {
      indigenas = indigenasCarregados;
      atendimentos = atendimentosCarregados;
      carregando = false;
    });
  }

  void _registrarAtendimento(Indigena indigena, String tipo, String obs) {
    final novo = Atendimento(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      indigenaId: indigena.id,
      nomeIndigena: indigena.nome,
      cnsIndigena: indigena.cns,
      aldeia: indigena.aldeiaAtual,
      tipoAtendimento: tipo,
      idade: indigena.idade,
      faixaEtaria: indigena.faixaEtaria,
      observacoes: obs,
      dataHora: DateTime.now(),
    );

    setState(() {
      atendimentos.add(novo);
    });
    StorageService.salvarAtendimentos(atendimentos);
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
            value: aldeiaSelecionada,
            decoration: const InputDecoration(labelText: 'Selecione a Aldeia', border: OutlineInputBorder()),
            items: aldeias.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
            onChanged: (val) {
              if (val != null) setState(() => aldeiaSelecionada = val);
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
                      child: Text('Cartão de Vacinas: ${indigena.nome}', 
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
                const Divider(),
                const Text('Vacinas Pendentes:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                const SizedBox(height: 8),
                Expanded(
                  flex: 1,
                  child: indigena.vacinasPendentes.isEmpty
                      ? const Center(child: Text('Esquema vacinal completo!'))
                      : ListView.builder(
                          itemCount: indigena.vacinasPendentes.length,
                          itemBuilder: (context, i) {
                            final vNome = indigena.vacinasPendentes[i];
                            return Card(
                              color: Colors.orange.shade50,
                              child: ListTile(
                                leading: const Icon(Icons.pending, color: Colors.orange),
                                title: Text(vNome),
                                trailing: ElevatedButton.icon(
                                  icon: const Icon(Icons.vaccines),
                                  label: const Text('Aplicar'),
                                  onPressed: () {
                                    _aplicarVacinaComLote(indigena, vNome, () {
                                      setModalState(() {});
                                      setState(() {});
                                    });
                                  },
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
      ),
    );
  }

  void _aplicarVacinaComLote(Indigena indigena, String nomeVacina, VoidCallback onAtualizar) {
    final loteController = TextEditingController();
    String doseSelecionada = '1ª Dose';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Aplicar $nomeVacina'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: doseSelecionada,
              decoration: const InputDecoration(labelText: 'Dose'),
              items: ['Dose Única', '1ª Dose', '2ª Dose', '3ª Dose', 'Reforço']
                  .map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (v) { if (v != null) doseSelecionada = v; },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: loteController,
              decoration: const InputDecoration(
                labelText: 'Número do Lote da Vacina *',
                hintText: 'Ex: LT-2026-X99',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (loteController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor, informe o número do Lote!')),
                );
                return;
              }

              final novaVacina = VacinaAplicada(
                nome: nomeVacina,
                dose: doseSelecionada,
                lote: loteController.text.trim(),
                dataAplicacao: DateTime.now(),
                aplicador: widget.agente.nome,
              );

              indigena.vacinasTomadas.add(novaVacina);
              StorageService.salvarIndigenas(indigenas);
              _registrarAtendimento(indigena, 'Vacinação', 'Aplicada vacina $nomeVacina ($doseSelecionada) - Lote: ${loteController.text}');

              Navigator.pop(ctx);
              onAtualizar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$nomeVacina aplicada com sucesso!')),
              );
            },
            child: const Text('Confirmar Aplicação'),
          ),
        ],
      ),
    );
  }

  Widget _buildAbaRelatorios() {
    final atdData = atendimentos.where((a) =>
      a.dataHora.year == dataRelatorio.year &&
      a.dataHora.month == dataRelatorio.month &&
      a.dataHora.day == dataRelatorio.day
    ).toList();

    final Map<String, int> faixas = {
      'Criança (0-11)': 0,
      'Jovem (12-17)': 0,
      'Adulto (18-59)': 0,
      'Idoso (60+)': 0,
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
      builder: (ctx) => AlertDialog(
        title: Text('Atender: ${indigena.nome}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: tipo,
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
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              _registrarAtendimento(indigena, tipo, obsController.text);
              Navigator.pop(ctx);
            },
            child: const Text('Salvar Atendimento'),
          ),
        ],
      ),
    );
  }
}