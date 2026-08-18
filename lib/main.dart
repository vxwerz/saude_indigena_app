import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SaudeIndigenaApp());
}

class SaudeIndigenaApp extends StatelessWidget {
  const SaudeIndigenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saúde Indígena App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006A4E),
          primary: const Color(0xFF006A4E),
          secondary: const Color(0xFFC85A17),
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ==========================================
// MODELOS DE DADOS
// ==========================================
class AgenteFunai {
  final String matricula;
  final String nome;
  final String cargo;

  AgenteFunai({required this.matricula, required this.nome, required this.cargo});
}

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
        nome: json['nome'],
        dose: json['dose'],
        lote: json['lote'],
        dataAplicacao: DateTime.parse(json['dataAplicacao']),
        aplicador: json['aplicador'] ?? 'Agente FUNAI',
      );
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
  }) : vacinasTomadas = vacinasTomadas ?? [];

  int get idade {
    final hoje = DateTime.now();
    int idade = hoje.year - dataNascimento.year;
    if (hoje.month < dataNascimento.month ||
        (hoje.month == dataNascimento.month && hoje.day < dataNascimento.day)) {
      idade--;
    }
    return idade;
  }

  String get faixaEtaria {
    final i = idade;
    if (i <= 11) return 'Criança (0-11)';
    if (i <= 17) return 'Jovem (12-17)';
    if (i <= 59) return 'Adulto (18-59)';
    return 'Idoso (60+)';
  }

  // Lista base de vacinas pendentes calculada conforme as já aplicadas
  List<String> get vacinasPendentes {
    final todas = ['BCG', 'Hepatite B', 'Penta', 'Polio VIP', 'Febre Amarela', 'Tríplice Viral', 'COVID-19', 'Influenza'];
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
        id: json['id'],
        cns: json['cns'],
        nome: json['nome'],
        aldeiaAtual: json['aldeiaAtual'],
        dataNascimento: DateTime.parse(json['dataNascimento']),
        vacinasTomadas: json['vacinasTomadas'] != null
            ? (json['vacinasTomadas'] as List).map((v) => VacinaAplicada.fromJson(v)).toList()
            : [],
      );
}

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
        id: json['id'],
        indigenaId: json['indigenaId'],
        nomeIndigena: json['nomeIndigena'],
        cnsIndigena: json['cnsIndigena'],
        aldeia: json['aldeia'],
        tipoAtendimento: json['tipoAtendimento'],
        idade: json['idade'],
        faixaEtaria: json['faixaEtaria'],
        observacoes: json['observacoes'],
        dataHora: DateTime.parse(json['dataHora']),
      );
}

// ==========================================
// TELA DE LOGIN
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _matriculaController = TextEditingController(text: 'FUNAI-8842');
  final _senhaController = TextEditingController(text: '123456');

  void _fazerLogin() {
    if (_matriculaController.text.isNotEmpty && _senhaController.text.isNotEmpty) {
      final agente = AgenteFunai(
        matricula: _matriculaController.text,
        nome: 'Maria Silva',
        cargo: 'Agente Indigenista de Saúde',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(agente: agente)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe a matrícula e senha')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006A4E),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.health_and_safety, size: 64, color: Color(0xFF006A4E)),
                  const SizedBox(height: 12),
                  const Text('Saúde Indígena App', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text('Acesso do Agente FUNAI / DSEI', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _matriculaController,
                    decoration: const InputDecoration(
                      labelText: 'Matrícula FUNAI / CPF',
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006A4E),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _fazerLogin,
                      child: const Text('ENTRAR NO SISTEMA', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TELA PRINCIPAL (HOME)
// ==========================================
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

  List<Indigena> _obterIndigenasIniciais() {
    return [
      Indigena(
        id: '1', cns: '700123456789012', nome: 'Tupã Guarani', aldeiaAtual: 'Aldeinha', dataNascimento: DateTime(1985, 5, 12),
        vacinasTomadas: [
          VacinaAplicada(nome: 'BCG', dose: 'Única', lote: 'LT-2023-A9', dataAplicacao: DateTime(1985, 5, 20), aplicador: 'Agente FUNAI'),
          VacinaAplicada(nome: 'COVID-19', dose: '1ª Dose', lote: 'FL-8821', dataAplicacao: DateTime(2022, 3, 10), aplicador: 'Agente FUNAI'),
        ]
      ),
      Indigena(id: '2', cns: '700987654321098', nome: 'Jaciara Tupi', aldeiaAtual: 'Aldeinha', dataNascimento: DateTime(2018, 9, 20)),
      Indigena(id: '3', cns: '700222333444555', nome: 'Araci Guarani', aldeiaAtual: 'Itaoca Guarani', dataNascimento: DateTime(2012, 3, 8)),
    ];
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    final String? indigenasJson = prefs.getString('db_indigenas');
    final String? atendimentosJson = prefs.getString('db_atendimentos');

    setState(() {
      if (indigenasJson != null) {
        final List<dynamic> list = jsonDecode(indigenasJson);
        indigenas = list.map((e) => Indigena.fromJson(e)).toList();
      } else {
        indigenas = _obterIndigenasIniciais();
        _salvarIndigenas();
      }

      if (atendimentosJson != null) {
        final List<dynamic> list = jsonDecode(atendimentosJson);
        atendimentos = list.map((e) => Atendimento.fromJson(e)).toList();
      }
      carregando = false;
    });
  }

  Future<void> _salvarIndigenas() async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(indigenas.map((e) => e.toJson()).toList());
    await prefs.setString('db_indigenas', data);
  }

  Future<void> _salvarAtendimentos() async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(atendimentos.map((e) => e.toJson()).toList());
    await prefs.setString('db_atendimentos', data);
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
    _salvarAtendimentos();
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

  // ABA 1: ATENDIMENTOS E VACINAÇÃO
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

  // CARTÃO DE VACINAÇÃO COM REGISTRO DE LOTE
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
                    Text('Cartão de Vacinas: ${indigena.nome}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  // MODAL DE APLICAÇÃO DE VACINA EXIGINDO O LOTE
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
              _salvarIndigenas();
              _registrarAtendimento(indigena, 'Vacinação', 'Aplicada vacina $nomeVacina (${doseSelecionada}) - Lote: ${loteController.text}');

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

  // ABA 2: RELATÓRIOS
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