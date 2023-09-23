import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recommendationsapp/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Recommendations App",
      home: LoginPage(),
    ),
  );
}
