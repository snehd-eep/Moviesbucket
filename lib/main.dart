import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:movie_bucket/screens/formscreen.dart';
import 'package:movie_bucket/screens/loginscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Bucket',
      home: Loginscreen(),
    );
  }
}
