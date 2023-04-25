import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';

class IsletmelerPage extends StatefulWidget {
  final String email;
  final String password;
  const IsletmelerPage({Key? key, required this.email, required this.password}) : super(key: key);

  @override
  State<IsletmelerPage> createState() => _IsletmelerPageState();
}

class _IsletmelerPageState extends State<IsletmelerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İşletmeler"),
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
