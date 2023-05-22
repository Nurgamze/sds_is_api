import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';

class BasvuruPage extends StatefulWidget {
  final String email;
  final String password;
  const BasvuruPage({Key? key, required this.email, required this.password}) : super(key: key);

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(email: widget.email, password: widget.password,)));
          },
        ),
      ),
    );
  }
}
