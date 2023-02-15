import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mauthn/login/loginPage.dart';
import '../theme.dart';
import '../login/loginPage.dart';
import '../pages/mainPage.dart';
import '../pages/camera.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: LoginPage(),
    );
  }
}
