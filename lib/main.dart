import 'package:flutter/material.dart';
import 'package:mtfarm2/view/home.dart';
import 'package:mtfarm2/view/mortal/mortal_view.dart';
import 'package:mtfarm2/view/populasi/populasi_view.dart';

import 'view/potong/potong_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
