import 'package:flutter/material.dart';
import 'package:habit_app/screens/login_screen.dart';
import 'package:habit_app/screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habitt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const SignupScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}