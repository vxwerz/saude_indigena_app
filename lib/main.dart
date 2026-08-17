import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const SaudeIndigenaApp());
}

class SaudeIndigenaApp extends StatelessWidget {
  const SaudeIndigenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saúde Indígena - Campo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00695C), // Verde escuro institucional
          primary: const Color(0xFF00695C),
          secondary: const Color(0xFFD84315),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// MODELOS DE DADOS
// -----------------------------------------------------------------------------
class AgenteSaude {
  final String matricula;
  final String nome;
  final String cargo;
  final String dsei; // Distrito Sanitário Especial Indígena

  AgenteSaude({
    required this.matricula,
    required this.nome,
    required this.cargo,
    required this.dsei,
  });

  Map<String, dynamic> toMap() => {
        'matricula': matricula,
        'nome': nome,
        'cargo': cargo,
        'dsei': dsei,
      };

  factory AgenteSaude.fromMap(Map<String, dynamic> map) {
    return AgenteSaude(
      matricula: map['matricula'] ?? '',
      nome: map['nome'] ?? '',
      cargo: map['cargo'] ?? '',
      dsei: map['dsei'] ?? '',
    );
  }
}

class VacinaItem {
  final String id;
  final String nome;
  final String dose;
  final String periodoIdade;
  bool aplicada;
  DateTime? dataAplicacao;
  String? lote;
  String? agenteResponsavel; // Rastreabilidade de quem aplicou

  VacinaItem({
    required this.id,
    required this.nome,
    required this.dose,
    required this.periodoIdade,
    this.aplicada = false,
    this.dataAplicacao,
    this.lote,
    this.agenteResponsavel,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'dose': dose,
        'periodoIdade': periodoIdade,
        'aplicada': aplicada,
        'dataAplicacao': dataAplicacao?.toIso8601String(),
        'lote': lote,
        'agenteResponsavel': agenteResponsavel,
      };

  factory VacinaItem.fromMap(Map<String, dynamic> map) {
    return VacinaItem(
      id: map['id'],
      nome: map['nome'],
      dose: map['dose'],
      periodoIdade: map['periodoIdade'],
      aplicada: map['aplicada'] ?? false,
      dataAplicacao: map['dataAplicacao'] != null
          ? DateTime.parse(map['dataAplicacao'])
          : null,
      lote: map['lote'],
      agenteResponsavel: map['agenteResponsavel'],
    );
  }
}

// -----------------------------------------------------------------------------
// 1. TELA DE LOGIN (AUTENTICAÇÃO LOCAL DE CAMPO)
// -----------------------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _matriculaController = TextEditingController(text: "FUNAI-8842");
  final _senhaController = TextEditingController(text: "123456");
  bool _carregando = false;

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    // Simulação de autenticação com fallback offline
    await Future.delayed(const Duration(milliseconds: 800));

    // Salva a sessão do agente ativo no dispositivo
    final agente = AgenteSaude(
      matricula: _matriculaController.text,
      nome: "Txai Gabriel Sampaio",
      cargo: "Agente Indígena de Saúde / FUNAI",
      dsei: "DSEI Yanomami / Polo Base Surucucu",
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('agente_ativo', jsonEncode(agente.toMap()));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainHomeScreen(agente: agente)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.health_and_safety, size: 80, color: Color(0xFF00695C)),
              const SizedBox(height: 12),
              const Text(
                'SISTEMA DE SAÚDE INDÍGENA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00695C),
                  letterSpacing: 1.1,
                ),
              ),
              const Text(
                'Módulo de Atendimento Offline de Campo',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Identificação do Agente',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _matriculaController,
                          decoration: const InputDecoration(
                            labelText: 'Matrícula FUNAI / SISAIGOV',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.badge),
                          ),
                          validator: (v) => v!.isEmpty ? 'Informe a matrícula' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _senhaController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Senha de Acesso',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (v) => v!.isEmpty ? 'Informe a senha' : null,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _carregando ? null : _fazerLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00695C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _carregando
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('ENTRAR NO SISTEMA', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.wifi_off, size: 16, color: Colors.orange),
                            SizedBox(width: 6),
                            Text(
                              'Modo Offline Habilitado',
                              style: TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TELA PRINCIPAL DE NAVEGAÇÃO E SESSÃO
// -----------------------------------------------------------------------------
class MainHomeScreen extends StatefulWidget {
  final AgenteSaude agente;

  const MainHomeScreen({super.key, required this.agente});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _abaSelecionada = 0;
  bool _carregando = true;

  // Paciente Ativo
  String _cnsPaciente = "700102938490123";
  String _nomePaciente = "Tupã Guajajara";
  String _aldeiaPaciente = "Aldeia Central";
  DateTime? _dataNascimentoPaciente = DateTime(2023, 1, 15);

  List<VacinaItem> _vacinas = [
    VacinaItem(id: '1', nome: 'BCG', dose: 'Dose Única', periodoIdade: 'Ao nascer'),
    VacinaItem(id: '2', nome: 'Hepatite B', dose: 'Dose Única', periodoIdade: 'Ao nascer'),
    VacinaItem(id: '3', nome: 'Pentavalente', dose: '1ª Dose', periodoIdade: '2 meses'),
    VacinaItem(id: '4', nome: 'Pólio (VIP)', dose: '1ª Dose', periodoIdade: '2 meses'),
    VacinaItem(id: '5', nome: 'Rotavírus', dose: '1ª Dose', periodoIdade: '2 meses'),
    VacinaItem(id: '6', nome: 'Pneumocócica 10V', dose: '1ª Dose', periodoIdade: '2 meses'),
    VacinaItem(id: '7', nome: 'Pentavalente', dose: '2ª Dose', periodoIdade: '4 meses'),
    VacinaItem(id: '8', nome: 'Febre Amarela', dose: 'Dose Inicial', periodoIdade: '9 meses'),
  ];

  @override
  void initState() {
    super.initState();
    _carregarDadosOffline();
  }

  Future<void> _carregarDadosOffline() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _cnsPaciente = prefs.getString('paciente_cns') ?? _cnsPaciente;
      _nomePaciente = prefs.getString('paciente_nome') ?? _nomePaciente;
      _aldeiaPaciente = prefs.getString('paciente_aldeia') ?? _aldeiaPaciente;

      final dataStr = prefs.getString('paciente_data_nasc');
      if (dataStr != null) {
        _dataNascimentoPaciente = DateTime.parse(dataStr);
      }

      final vacinasJson = prefs.getString('paciente_vacinas');
      if (vacinasJson != null) {
        final List<dynamic> decoded = jsonDecode(vacinasJson);
        _vacinas = decoded.map((item) => VacinaItem.fromMap(item)).toList();
      }

      _carregando = false;
    });
  }

  Future<void> _salvarDadosOffline() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('paciente_cns', _cnsPaciente);
    await prefs.setString('paciente_nome', _nomePaciente);
    await prefs.setString('paciente_aldeia', _aldeiaPaciente);

    if (_dataNascimentoPaciente != null) {
      await prefs.setString('paciente_data_nasc', _dataNascimentoPaciente!.toIso8601String());
    }

    final vacinasMap = _vacinas.map((v) => v.toMap()).toList();
    await prefs.setString('paciente_vacinas', jsonEncode(vacinasMap));
  }

  void _atualizarPaciente(String cns, String nome, String aldeia, DateTime dataNasc) {
    setState(() {
      _cnsPaciente = cns;
      _nomePaciente = nome;
      _aldeiaPaciente = aldeia;
      _dataNascimentoPaciente = dataNasc;
      _abaSelecionada = 1;
    });
    _salvarDadosOffline();
  }

  void _aoAlterarVacina() {
    setState(() {});
    _salvarDadosOffline();
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF00695C))),
      );
    }

    final List<Widget> telas = [
      CadastroPacienteScreen(
        cnsAtual: _cnsPaciente,
        nomeAtual: _nomePaciente,
        aldeiaAtual: _aldeiaPaciente,
        dataNascAtual: _dataNascimentoPaciente,
        onSalvar: _atualizarPaciente,
      ),
      HistoricoVacinasScreen(
        agenteAtivo: widget.agente,
        cnsPaciente: _cnsPaciente,
        nomePaciente: _nomePaciente,
        aldeiaPaciente: _aldeiaPaciente,
        dataNascimento: _dataNascimentoPaciente,
        vacinas: _vacinas,
        onAtualizarVacina: _aoAlterarVacina,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agente: ${widget.agente.nome}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text('${widget.agente.dsei} • ${widget.agente.matricula}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair do Sistema',
            onPressed: _logout,
          )
        ],
      ),
      body: telas[_abaSelecionada],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _abaSelecionada,
        selectedItemColor: const Color(0xFF00695C),
        onTap: (i) => setState(() => _abaSelecionada = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Cadastro / Busca'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Carteira Vacinal'),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. CADASTRO DE PACIENTE
// -----------------------------------------------------------------------------
class CadastroPacienteScreen extends StatefulWidget {
  final String cnsAtual;
  final String nomeAtual;
  final String aldeiaAtual;
  final DateTime? dataNascAtual;
  final Function(String, String, String, DateTime) onSalvar;

  const CadastroPacienteScreen({
    super.key,
    required this.cnsAtual,
    required this.nomeAtual,
    required this.aldeiaAtual,
    required this.dataNascAtual,
    required this.onSalvar,
  });

  @override
  State<CadastroPacienteScreen> createState() => _CadastroPacienteScreenState();
}

class _CadastroPacienteScreenState extends State<CadastroPacienteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cnsController;
  late TextEditingController _nomeController;
  late TextEditingController _aldeiaController;
  DateTime? _dataNascimento;

  @override
  void initState() {
    super.initState();
    _cnsController = TextEditingController(text: widget.cnsAtual);
    _nomeController = TextEditingController(text: widget.nomeAtual);
    _aldeiaController = TextEditingController(text: widget.aldeiaAtual);
    _dataNascimento = widget.dataNascAtual;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Prontuário Indígena (SUS / FUNAI)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00695C)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cnsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cartão Nacional de Saúde (CNS)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              validator: (v) => v!.isEmpty ? 'Informe o CNS' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome Completo / Nome Indígena',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) => v!.isEmpty ? 'Informe o nome' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _aldeiaController,
              decoration: const InputDecoration(
                labelText: 'Comunidade / Aldeia / Etnia',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (v) => v!.isEmpty ? 'Informe a aldeia' : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final p = await showDatePicker(
                  context: context,
                  initialDate: _dataNascimento ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (p != null) setState(() => _dataNascimento = p);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _dataNascimento == null
                      ? 'Selecione a data'
                      : '${_dataNascimento!.day.toString().padLeft(2, '0')}/${_dataNascimento!.month.toString().padLeft(2, '0')}/${_dataNascimento!.year}',
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate() && _dataNascimento != null) {
                  widget.onSalvar(
                    _cnsController.text,
                    _nomeController.text,
                    _aldeiaController.text,
                    _dataNascimento!,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Registro salvo localmente com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00695C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.save),
              label: const Text('SALVAR / CARREGAR CARTEIRA'),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. CARTEIRA VACINAL COM AUDITORIA DO AGENTE
// -----------------------------------------------------------------------------
class HistoricoVacinasScreen extends StatefulWidget {
  final AgenteSaude agenteAtivo;
  final String cnsPaciente;
  final String nomePaciente;
  final String aldeiaPaciente;
  final DateTime? dataNascimento;
  final List<VacinaItem> vacinas;
  final VoidCallback onAtualizarVacina;

  const HistoricoVacinasScreen({
    super.key,
    required this.agenteAtivo,
    required this.cnsPaciente,
    required this.nomePaciente,
    required this.aldeiaPaciente,
    required this.dataNascimento,
    required this.vacinas,
    required this.onAtualizarVacina,
  });

  @override
  State<HistoricoVacinasScreen> createState() => _HistoricoVacinasScreenState();
}

class _HistoricoVacinasScreenState extends State<HistoricoVacinasScreen> {
  void _abrirModalRegistro(VacinaItem vacina) {
    final loteController = TextEditingController();
    DateTime dataSelecionada = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Registrar Aplicação: ${vacina.nome}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00695C))),
                  Text('Dose: ${vacina.dose} • Etapa: ${vacina.periodoIdade}', style: const TextStyle(color: Colors.grey)),
                  const Divider(height: 24),
                  TextField(
                    controller: loteController,
                    decoration: const InputDecoration(labelText: 'Lote do Imunobiológico', border: OutlineInputBorder(), prefixIcon: Icon(Icons.qr_code)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Color(0xFF00695C)),
                      const SizedBox(width: 8),
                      Text('Data da Aplicação: ${dataSelecionada.day.toString().padLeft(2, '0')}/${dataSelecionada.month.toString().padLeft(2, '0')}/${dataSelecionada.year}'),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: dataSelecionada,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) setModalState(() => dataSelecionada = picked);
                        },
                        child: const Text('Alterar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(Icons.verified_user, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Aplicador Responsável: ${widget.agenteAtivo.nome} (${widget.agenteAtivo.matricula})',
                            style: const TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        vacina.aplicada = true;
                        vacina.dataAplicacao = dataSelecionada;
                        vacina.lote = loteController.text.isNotEmpty ? loteController.text : 'LOTE-DEFAULT-OFF';
                        vacina.agenteResponsavel = '${widget.agenteAtivo.nome} (${widget.agenteAtivo.matricula})';

                        widget.onAtualizarVacina();
                        Navigator.of(ctx).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Aplicação gravada no histórico local!'), backgroundColor: Colors.green),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00695C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('CONFIRMAR APLICAÇÃO'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendentes = widget.vacinas.where((v) => !v.aplicada).toList();
    final aplicadas = widget.vacinas.where((v) => v.aplicada).toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFE0F2F1),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF00695C),
                  radius: 22,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.nomePaciente, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('CNS: ${widget.cnsPaciente} • ${widget.aldeiaPaciente}', style: const TextStyle(color: Colors.black87, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const TabBar(
            labelColor: Color(0xFF00695C),
            indicatorColor: Color(0xFF00695C),
            tabs: [
              Tab(text: 'PENDENTES'),
              Tab(text: 'APLICADAS'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: pendentes.length,
                  itemBuilder: (ctx, i) {
                    final v = pendentes[i];
                    return Card(
                      child: ListTile(
                        title: Text(v.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${v.dose} • ${v.periodoIdade}'),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00695C), foregroundColor: Colors.white),
                          onPressed: () => _abrirModalRegistro(v),
                          child: const Text('Aplicar'),
                        ),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: aplicadas.length,
                  itemBuilder: (ctx, i) {
                    final v = aplicadas[i];
                    final dataFmt = v.dataAplicacao != null ? '${v.dataAplicacao!.day}/${v.dataAplicacao!.month}/${v.dataAplicacao!.year}' : '-';
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.green),
                        title: Text(v.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Lote: ${v.lote}\nAplicador: ${v.agenteResponsavel ?? "Não registrado"}'),
                        trailing: Text(dataFmt, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}