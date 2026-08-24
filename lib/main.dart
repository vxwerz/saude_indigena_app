import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/agente_funai.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase no dispositivo/navegador
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SaudeIndigenaApp());
}

class SaudeIndigenaApp extends StatelessWidget {
  const SaudeIndigenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Agente de demonstração ajustado com todos os campos necessários
    final agenteAtual = AgenteFunai(
      nome: 'Maria Silva',
      cargo: 'Agente Indígena de Saúde',
      matricula: 'AIS-12345',
    );

    return MaterialApp(
      title: 'Saúde Indígena',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006A4E)),
        useMaterial3: true,
      ),
      home: HomeScreen(agente: agenteAtual),
    );
  }
}