import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/login_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint('Firebase inicializado com sucesso.');
  } catch (e) {
    debugPrint('Erro ao inicializar o Firebase: $e');
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006A4E),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}