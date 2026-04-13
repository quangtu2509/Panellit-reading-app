import 'package:flutter/material.dart';

import 'features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Panellit Reading',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2F3F5),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2AA6DF)),
      ),
      home: const LoginPage(),
    );
  }
}
