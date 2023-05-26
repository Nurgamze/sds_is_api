import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sds_is_platformu/const/sabitler.dart';
import 'login.dart';


class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key, }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  //statede controller tanımlanır

  final emailRegisterController=TextEditingController();
  final passwordRegisterController=TextEditingController();
  final adsoyadRegisterController=TextEditingController();

  String? email;
  String? adsoyad;
  String? password;
  bool? approved;
  String url=apiUrl;


  void register() async{

    setState(() {
      email=emailRegisterController.text;
      adsoyad=adsoyadRegisterController.text;
      password=passwordRegisterController.text;
    });

    var response=await http.post(Uri.parse("$url/register"),
        body: {
          "adsoyad":adsoyadRegisterController.text,
          "email":emailRegisterController.text,
          "password":passwordRegisterController.text,
          'approved':'false',

        });
    if(response.statusCode==201){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          content: Text("Kayıt başarılı şekilde oluşturulmuştur."),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
            }, child: Text("Tamam"),
              style:ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade400),
              ),)

          ],
        );
      });
    }
    else{
      AlertDialog(
        content: Text("Bir hata oluştu"),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
          }, child: Text("Tamam"))
        ],
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                SizedBox(height: 30,),
                //logo
                /*ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset("assets/images/gh.jpeg",scale: 2.5,)
                ),*/
                Icon(Icons.lock,size: 100,),
                SizedBox(height: 20,),
                //welcome4
                Text("Kayıt ol",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16,
                  ),),

                SizedBox(height: 50,),
                //username
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: adsoyadRegisterController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400)
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "Ad Soyad",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        )
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                //email textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: emailRegisterController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400)
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "Email",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        )
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                //password textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordRegisterController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400)

                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "Şİfre",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        )
                    ),
                  ),
                ),
                SizedBox(height: 20,),

                //sign in button
                GestureDetector(
                  onTap:(){
                    register();
                  },
                  child: Container(
                      padding: EdgeInsets.all(25),
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child:Center(
                        child: Text("Kayıt Ol",style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),),

                      )
                  ),
                ),

                SizedBox(height: 50,),
                //or continue with
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          //sool çizgisi
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Text("Birlikte aç"), //yazı
                      Expanded(
                        //sağ çizgi
                          child: Divider(thickness: 0.5,
                            color: Colors.grey,))
                    ],
                  ),
                ),
                //google +apple sign in buttons
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius:BorderRadius.circular(15),
                            color: Colors.grey[200]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset('assets/images/google.png',
                              height: 55
                          ),
                        )
                    ),
                    SizedBox(width: 10,),

                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius:BorderRadius.circular(15),
                          color: Colors.grey[200]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/images/apple.png',
                            height: 55
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                        },
                        child: Text("Giriş Yap!",
                            style: TextStyle(
                                color: Colors.blue,fontWeight: FontWeight.bold
                            )
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
