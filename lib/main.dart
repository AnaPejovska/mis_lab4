import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/exams-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD3JRUdWQ1cog1LBIBLMcYNhFXf7CXO7Xk",
      appId: "1:693951245263:android:0c295a8eaf114482fa80ba",
      messagingSenderId: "693951245263",
      projectId: "mobilni-lab4", ), );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exams Page',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'Exams Flutter App'),
    );
  }
}