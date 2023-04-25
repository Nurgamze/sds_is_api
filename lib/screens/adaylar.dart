import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';

class AdaylarPage extends StatefulWidget {
  final String email;
  final String password;
  const AdaylarPage({Key? key, required this.email, required this.password,}) : super(key: key);

  @override
  State<AdaylarPage> createState() => _AdaylarPageState();
}

class _AdaylarPageState extends State<AdaylarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adaylar"),
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
