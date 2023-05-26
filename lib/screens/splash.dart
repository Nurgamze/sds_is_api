import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sds_is_platformu/screens/login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      Duration(seconds: 3), ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()))
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/vLogo.png',scale: 2.5,),
            SizedBox(height: 20,),
            Center(
              child: Text("SDS İŞE ALIM PLATFORMUNA HOŞ GELDİNİZ",
                style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),
               ),
             ),
           ],
         )
      ),
    );
  }
}
