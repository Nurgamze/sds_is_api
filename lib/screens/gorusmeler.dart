import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';

class GorusmelerPage extends StatefulWidget {
  final String email;
  final String password;
  const GorusmelerPage({Key? key, required this.email, required this.password}) : super(key: key);

  @override
  State<GorusmelerPage> createState() => _GorusmelerPageState();
}

class _GorusmelerPageState extends State<GorusmelerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Görüşmeler"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(email: widget.email, password: widget.password,)));
          },
        ),
      ),
      body: Column(

      ),
    );
  }
}
