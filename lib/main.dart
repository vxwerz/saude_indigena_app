import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:saude_indigena_app/screens/home_screen.dart';
import 'package:saude_indigena_app/models/agente_funai.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Conexão com o Firebase ativada
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saúde Indígena',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF006644),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _entrarNoSistema() {
    final agente = AgenteFunai(
      nome: 'Carlos Silva',
      cargo: 'Agente de Saúde Indígena',
      matricula: '123456-A',
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(agente: agente),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color(0xFF006644),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006644),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          onPressed: _entrarNoSistema,
          child: const Text(
            'Entrar no Sistema',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}