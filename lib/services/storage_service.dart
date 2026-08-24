import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/indigena.dart';
import '../models/atendimento.dart';

class StorageService {
  static const String _keyIndigenas = 'db_indigenas';
  static const String _keyAtendimentos = 'db_atendimentos';

  static Future<List<Indigena>> carregarIndigenas() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_keyIndigenas);

    if (jsonString != null) {
      final List<dynamic> list = jsonDecode(jsonString);
      return list.map((e) => Indigena.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      final iniciais = _obterIndigenasIniciais();
      await salvarIndigenas(iniciais);
      return iniciais;
    }
  }

  static Future<void> salvarIndigenas(List<Indigena> list) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_keyIndigenas, data);
  }

  static Future<List<Atendimento>> carregarAtendimentos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_keyAtendimentos);

    if (jsonString != null) {
      final List<dynamic> list = jsonDecode(jsonString);
      return list.map((e) => Atendimento.fromMap(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  static Future<void> salvarAtendimentos(List<Atendimento> list) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(list.map((e) => e.toMap()).toList());
    await prefs.setString(_keyAtendimentos, data);
  }

  static List<Indigena> _obterIndigenasIniciais() {
    return [
      Indigena(
        id: '1',
        cns: '700123456789012',
        nome: 'Tupã Guarani',
        aldeiaAtual: 'Aldeinha',
        dataNascimento: DateTime(1985, 5, 12),
        vacinasTomadas: [
          VacinaAplicada(
            nome: 'BCG',
            dose: 'Única',
            lote: 'LT-2023-A9',
            dataAplicacao: DateTime(1985, 5, 20),
            aplicador: 'Agente FUNAI',
          ),
          VacinaAplicada(
            nome: 'COVID-19',
            dose: '1ª Dose',
            lote: 'FL-8821',
            dataAplicacao: DateTime(2022, 3, 10),
            aplicador: 'Agente FUNAI',
          ),
        ],
      ),
      Indigena(
        id: '2',
        cns: '700987654321098',
        nome: 'Jaciara Tupi',
        aldeiaAtual: 'Aldeinha',
        dataNascimento: DateTime(2018, 9, 20),
        vacinasTomadas: [],
      ),
      Indigena(
        id: '3',
        cns: '700222333444555',
        nome: 'Araci Guarani',
        aldeiaAtual: 'Itaoca Guarani',
        dataNascimento: DateTime(2012, 3, 8),
        vacinasTomadas: [],
      ),
    ];
  }
}