import 'package:flutter/material.dart';
import '../models/agente_funai.dart';
import '../models/indigena.dart';

class VacinasScreen extends StatefulWidget {
  final AgenteFunai agente;
  final Indigena indigena;
  final Function(Indigena indigenaAtualizado)? onVacinaAplicada;

  const VacinasScreen({
    super.key,
    required this.agente,
    required this.indigena,
    this.onVacinaAplicada,
  });

  @override
  State<VacinasScreen> createState() => _VacinasScreenState();
}

class _VacinasScreenState extends State<VacinasScreen> {
  final _vacinaController = TextEditingController();
  final _loteController = TextEditingController();
  String _doseSelecionada = '1ª Dose';

  @override
  void dispose() {
    _vacinaController.dispose();
    _loteController.dispose();
    super.dispose();
  }

  void _aplicarVacina() {
    final nomeVacina = _vacinaController.text.trim();
    final lote = _loteController.text.trim();

    if (nomeVacina.isEmpty || lote.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o nome da vacina e o lote!')),
      );
      return;
    }

    final novaVacina = VacinaAplicada(
      nome: nomeVacina,
      dose: _doseSelecionada,
      lote: lote,
      dataAplicacao: DateTime.now(),
      aplicador: '${widget.agente.nome} (${widget.agente.cargo})',
    );

    setState(() {
      widget.indigena.vacinasTomadas.add(novaVacina);
    });

    if (widget.onVacinaAplicada != null) {
      widget.onVacinaAplicada!(widget.indigena);
    }

    _vacinaController.clear();
    _loteController.clear();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vacina registrada com sucesso!'),
        backgroundColor: Color(0xFF006A4E),
      ),
    );
  }

  void _abrirModalAplicacao({String? vacinaSugerida}) {
    if (vacinaSugerida != null) {
      _vacinaController.text = vacinaSugerida;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Registrar Vacinação',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006A4E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _vacinaController,
                    decoration: const InputDecoration(
                      labelText: 'Nome da Vacina',
                      prefixIcon: Icon(Icons.vaccines),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _doseSelecionada,
                    decoration: const InputDecoration(
                      labelText: 'Dose',
                      prefixIcon: Icon(Icons.format_list_numbered),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '1ª Dose', child: Text('1ª Dose')),
                      DropdownMenuItem(value: '2ª Dose', child: Text('2ª Dose')),
                      DropdownMenuItem(value: '3ª Dose', child: Text('3ª Dose')),
                      DropdownMenuItem(value: 'Reforço', child: Text('Reforço')),
                      DropdownMenuItem(value: 'Dose Única', child: Text('Dose Única')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() {
                          _doseSelecionada = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _loteController,
                    decoration: const InputDecoration(
                      labelText: 'Número do Lote',
                      prefixIcon: Icon(Icons.qr_code),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aplicador: ${widget.agente.nome} (${widget.agente.cargo})',
                    style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006A4E),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _aplicarVacina,
                      child: const Text('CONFIRMAR APLICAÇÃO'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacinas - ${widget.indigena.nome}'),
        backgroundColor: const Color(0xFF006A4E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: Text(
                  widget.indigena.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'CNS: ${widget.indigena.cns} | Aldeia: ${widget.indigena.aldeiaAtual}\nFaixa Etária: ${widget.indigena.faixaEtaria}',
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Vacinas Pendentes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            widget.indigena.vacinasPendentes.isEmpty
                ? const Text('Nenhuma vacina pendente no momento.',
                    style: TextStyle(color: Colors.grey))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.indigena.vacinasPendentes
                        .map((v) => ActionChip(
                              avatar: const Icon(Icons.add, size: 16, color: Colors.orange),
                              label: Text(v),
                              backgroundColor: Colors.orange.shade50,
                              onPressed: () => _abrirModalAplicacao(vacinaSugerida: v),
                            ))
                        .toList(),
                  ),
            const SizedBox(height: 24),
            const Text(
              'Vacinas Aplicadas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF006A4E)),
            ),
            const SizedBox(height: 8),
            widget.indigena.vacinasTomadas.isEmpty
                ? const Text('Nenhuma vacina registrada para este indígena.')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.indigena.vacinasTomadas.length,
                    itemBuilder: (context, index) {
                      final vacina = widget.indigena.vacinasTomadas[index];
                      final dataStr =
                          '${vacina.dataAplicacao.day.toString().padLeft(2, '0')}/${vacina.dataAplicacao.month.toString().padLeft(2, '0')}/${vacina.dataAplicacao.year}';
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF006A4E),
                            child: Icon(Icons.check, color: Colors.white),
                          ),
                          title: Text('${vacina.nome} - ${vacina.dose}'),
                          subtitle: Text(
                            'Lote: ${vacina.lote} | Data: $dataStr\nAplicado por: ${vacina.aplicador}',
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF006A4E),
        foregroundColor: Colors.white,
        onPressed: () => _abrirModalAplicacao(),
        icon: const Icon(Icons.vaccines),
        label: const Text('Aplicar Vacina'),
      ),
    );
  }
}