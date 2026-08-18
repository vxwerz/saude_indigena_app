import 'package:flutter/material.dart';
import 'package:saude_indigena_app/screens/login_screens.dart';

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
        colorSchemeSeed: const Color(0xFF006A4E),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}