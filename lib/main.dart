import 'package:doom/pages/chat_page.dart';
import 'package:doom/pages/data_screen.dart';
import 'package:doom/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:doom/pages/login.dart';
import 'package:doom/pages/news.dart'; 
import 'package:doom/pages/speechToText.dart'; 
import 'package:doom/pages/sign_up.dart'; 
import 'package:doom/pages/home_page.dart'; 
import 'package:audioplayers/audioplayers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC8iiorgJonWlzeFL8_KIuY_4hlnQa5D54",
      authDomain: "doom-230ab.firebaseapp.com",
      projectId: "doom-230ab",
      storageBucket: "doom-230ab.appspot.com",
      messagingSenderId: "171136645660",
      appId: "1:171136645660:web:9f838dad5f7fb7c8e8fdd9",
      measurementId: "G-WK071TJ76G",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello, Doctor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const MyLoginPage(),
        '/news': (context) => const NewsPage(),
        '/speech_to_text': (context) => const SpeechToTextPage(),
        '/signup': (context) => const MySignUpState(), 
        '/home': (context) => HomePage(),
        '/Profile':(context) => const ProfilePage(), 
        '/data': (context) => const DataScreen(),
        '/chat': (context) => const ChatPage(),
      },
    );
  }
}
