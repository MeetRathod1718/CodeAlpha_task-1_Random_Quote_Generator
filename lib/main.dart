import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Quote Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Rqg(),
    );
  }
}

class Rqg extends StatefulWidget {
  const Rqg({super.key});

  @override
  State<Rqg> createState() => _RqgState();
}

class _RqgState extends State<Rqg> {
  final String quoteURL = "https://api.adviceslip.com/advice";
  String quote = 'Random Quote';
  generatequote() async {
    var res = await http.get(Uri.parse(quoteURL));
    var result = jsonDecode(res.body);
    debugPrint(result["slip"]["advice"]);
    setState(() {
      quote = result["slip"]["advice"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random Quote Generator"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(quote),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                generatequote();
              },
              child: const Text('Generate')),
        ],
      )),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
