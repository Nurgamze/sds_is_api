import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasvuruPage extends StatefulWidget {
  const BasvuruPage({Key? key}) : super(key: key);

  @override
  State<BasvuruPage> createState() => _BasvuruPageState();
}

class _BasvuruPageState extends State<BasvuruPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Başvuru Sayfası"),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
    );
  }
}
