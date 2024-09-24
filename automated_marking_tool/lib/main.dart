import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:automated_marking_tool/Pages/AuthenticationScreens/Login_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Firebase/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'Providers/project_provider.dart';
import 'package:automated_marking_tool/Theme/AppTheme.dart';
import 'package:automated_marking_tool/Theme/ThemeNotifier.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env.local"); // Load the .env.local file

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _fetchAndSetApiKey();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(), // Add this line
      child: ChangeNotifierProvider(
        create: (context) => ProjectProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

Future<void> _fetchAndSetApiKey() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Retrieve API Key from Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        String apiKey = documentSnapshot['apiKey'] ?? '';
        OpenAI.apiKey = apiKey; // Set API Key for OpenAI
      }
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Added the missing super call

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automated Marking Tool',
      debugShowCheckedModeBanner: false,
      theme: context.watch<ThemeNotifier>().isDarkMode
          ? AppTheme.darkTheme
          : AppTheme.lightTheme,
      home: LoginPage(),
    );
  }
}
