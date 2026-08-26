import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:saude_indigena_app/screens/login_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Proteção para evitar travamento na Web
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase não inicializado no ambiente atual: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saúde Indígena App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF006A4E),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006A4E)),
      ),
      home: const LoginScreen(),
    );
  }
}