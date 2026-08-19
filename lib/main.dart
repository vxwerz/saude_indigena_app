import 'package:flutter/material.dart';
import 'package:saude_indigena_app/screens/login_screens.dart';
import 'database/app_database.dart'; // 1. Importa o banco de dados

// 2. Cria a variável global do banco para ser usada em qualquer tela
late AppDatabase database;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 3. Inicializa a conexão com o SQLite local
  database = AppDatabase();

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
        colorSchemeSeed: const Color(0xFF006A4E),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}