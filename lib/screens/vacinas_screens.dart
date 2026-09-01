import 'package:flutter/material.dart';

import '../models/agente_funai.dart';
import '../models/indigena.dart';

class VacinasScreen extends StatefulWidget {
  final AgenteFunai agente;
  final Indigena indigena;

  final Function(Indigena indigenaAtualizado)?
      onVacinaAplicada;

  const VacinasScreen({
    super.key,
    required this.agente,
    required this.indigena,
    this.onVacinaAplicada,
  });

  @override
  State<VacinasScreen> createState() =>
      _VacinasScreenState();
}

class _VacinasScreenState
    extends State<VacinasScreen> {
  final TextEditingController
      _vacinaController =
      TextEditingController();

  final TextEditingController
      _loteController =
      TextEditingController();

  String _doseSelecionada = '1ª Dose';

  @override
  void dispose() {
    _vacinaController.dispose();
    _loteController.dispose();
    super.dispose();
  }

  // ============================================================
  // APLICAR VACINA
  // ============================================================

  Future<void> _aplicarVacina() async {
    final nomeVacina =
        _vacinaController.text.trim();

    final lote =
        _loteController.text.trim();

    if (nomeVacina.isEmpty ||
        lote.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Preencha o nome da vacina '
            'e o lote!',
          ),
        ),
      );

      return;
    }

    final novaVacina = VacinaAplicada(
      nome: nomeVacina,
      dose: _doseSelecionada,
      lote: lote,
      dataAplicacao:
          DateTime.now(),
      aplicador:
          '${widget.agente.nome}'
          '${widget.agente.cargo != null ? ' (${widget.agente.cargo})' : ''}',
    );

    setState(() {
      widget.indigena.vacinasTomadas
          .add(novaVacina);
    });

    // Atualiza a Home e permite que ela
    // salve os dados no SharedPreferences.
    widget.onVacinaAplicada?.call(
      widget.indigena,
    );

    _vacinaController.clear();
    _loteController.clear();

    if (!mounted) return;

    Navigator.pop(context);
  }

  // ============================================================
  // MODAL DE APLICAÇÃO
  // ============================================================

  void _abrirModalAplicacao({
    String? vacinaSugerida,
  }) {
    _vacinaController.text =
        vacinaSugerida ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder:
              (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom:
                    MediaQuery.of(context)
                            .viewInsets
                            .bottom +
                        24,
              ),
              child:
                  SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Text(
                      'Registrar Vacinação',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                        color: Color(
                          0xFF006A4E,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    TextField(
                      controller:
                          _vacinaController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Nome da Vacina',
                        prefixIcon:
                            Icon(
                          Icons.vaccines,
                        ),
                        border:
                            OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    DropdownButtonFormField<
                        String>(
                      initialValue:
                          _doseSelecionada,
                      decoration:
                          const InputDecoration(
                        labelText: 'Dose',
                        prefixIcon:
                            Icon(
                          Icons
                              .format_list_numbered,
                        ),
                        border:
                            OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: '1ª Dose',
                          child:
                              Text('1ª Dose'),
                        ),
                        DropdownMenuItem(
                          value: '2ª Dose',
                          child:
                              Text('2ª Dose'),
                        ),
                        DropdownMenuItem(
                          value: '3ª Dose',
                          child:
                              Text('3ª Dose'),
                        ),
                        DropdownMenuItem(
                          value: 'Reforço',
                          child:
                              Text('Reforço'),
                        ),
                        DropdownMenuItem(
                          value:
                              'Dose Única',
                          child:
                              Text(
                            'Dose Única',
                          ),
                        ),
                      ],
                      onChanged:
                          (valor) {
                        if (valor != null) {
                          setModalState(() {
                            _doseSelecionada =
                                valor;
                          });
                        }
                      },
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    TextField(
                      controller:
                          _loteController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Número do Lote',
                        prefixIcon:
                            Icon(
                          Icons.qr_code,
                        ),
                        border:
                            OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    Text(
                      'Aplicador: '
                      '${widget.agente.nome}'
                      '${widget.agente.cargo != null ? ' (${widget.agente.cargo})' : ''}',
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    SizedBox(
                      width:
                          double.infinity,
                      height: 48,
                      child:
                          ElevatedButton(
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
                        onPressed:
                            _aplicarVacina,
                        child:
                            const Text(
                          'CONFIRMAR APLICAÇÃO',
                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // FORMATAR DATA
  // ============================================================

  String _formatarData(
    DateTime data,
  ) {
    final dia = data.day
        .toString()
        .padLeft(2, '0');

    final mes = data.month
        .toString()
        .padLeft(2, '0');

    final ano =
        data.year.toString();

    return '$dia/$mes/$ano';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final vacinasPendentes =
        widget.indigena.vacinasPendentes;

    final vacinasTomadas =
        widget.indigena.vacinasTomadas;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vacinas - '
          '${widget.indigena.nome}',
        ),
        backgroundColor:
            const Color(0xFF006A4E),
        foregroundColor:
            Colors.white,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==================================================
            // DADOS DO INDÍGENA
            // ==================================================

            Card(
              elevation: 2,
              child: ListTile(
                leading:
                    const CircleAvatar(
                  backgroundColor:
                      Color(0xFF006A4E),
                  child: Icon(
                    Icons.person,
                    color:
                        Colors.white,
                  ),
                ),
                title: Text(
                  widget.indigena.nome,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'CNS: '
                  '${widget.indigena.cns}\n'
                  'Aldeia: '
                  '${widget.indigena.aldeiaAtual}\n'
                  'Faixa Etária: '
                  '${widget.indigena.faixaEtaria}',
                ),
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            // ==================================================
            // VACINAS PENDENTES
            // ==================================================

            const Text(
              'Vacinas Pendentes',
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            if (vacinasPendentes
                .isEmpty)
              const Card(
                child: Padding(
                  padding:
                      EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .check_circle,
                        color:
                            Colors.green,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          'Nenhuma vacina '
                          'pendente no momento.',
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    vacinasPendentes
                        .map(
                  (vacina) {
                    return ActionChip(
                      avatar:
                          const Icon(
                        Icons.add,
                        size: 16,
                        color:
                            Colors.orange,
                      ),
                      label:
                          Text(vacina),
                      backgroundColor:
                          Colors.orange
                              .shade50,
                      onPressed: () {
                        _abrirModalAplicacao(
                          vacinaSugerida:
                              vacina,
                        );
                      },
                    );
                  },
                ).toList(),
              ),

            const SizedBox(
              height: 24,
            ),

            // ==================================================
            // VACINAS APLICADAS
            // ==================================================

            const Text(
              'Vacinas Aplicadas',
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
                color:
                    Color(0xFF006A4E),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            if (vacinasTomadas
                .isEmpty)
              const Card(
                child: Padding(
                  padding:
                      EdgeInsets.all(16),
                  child: Text(
                    'Nenhuma vacina '
                    'registrada para '
                    'este indígena.',
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount:
                    vacinasTomadas.length,
                itemBuilder:
                    (context, index) {
                  final vacina =
                      vacinasTomadas[
                          index];

                  return Card(
                    margin:
                        const EdgeInsets
                            .only(
                      bottom: 8,
                    ),
                    child: ListTile(
                      leading:
                          const CircleAvatar(
                        backgroundColor:
                            Color(
                          0xFF006A4E,
                        ),
                        child: Icon(
                          Icons.check,
                          color:
                              Colors.white,
                        ),
                      ),
                      title: Text(
                        '${vacina.nome} - '
                        '${vacina.dose}',
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                      subtitle: Text(
                        'Lote: '
                        '${vacina.lote}\n'
                        'Data: '
                        '${_formatarData(vacina.dataAplicacao)}\n'
                        'Aplicado por: '
                        '${vacina.aplicador}',
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor:
            const Color(0xFF006A4E),
        foregroundColor:
            Colors.white,
        onPressed: () {
          _abrirModalAplicacao();
        },
        icon: const Icon(
          Icons.vaccines,
        ),
        label: const Text(
          'Aplicar Vacina',
        ),
      ),
    );
  }
}