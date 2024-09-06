import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './widgets/default_widget.dart'; // DefaultWidget을 import

// 목표사항 : 첫화면이 홈 화면이 되도록 수정

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter가 초기화되기 전에 Firebase 초기화 필요
  await Firebase.initializeApp(); // Firebase 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue.shade900),
        useMaterial3: true,
      ),
      home: const DefaultWidget(), // DefaultWidget을 home으로 설정
    );
  }
}