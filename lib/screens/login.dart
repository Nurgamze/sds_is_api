import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sds_is_platformu/const/sabitler.dart';
import 'package:sds_is_platformu/screens/register.dart';
import 'homePage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, }) : super(key: key);


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //statede controller tanımlanır


  final emailController=TextEditingController();
  final passwordController=TextEditingController();

  String? email;
  String? password;
  String url=apiUrl;


  void login() async{
    setState(() {
      email=emailController.text;
      password=passwordController.text;
    });

    final response=await http.post(Uri.parse("$url/login"),

        body: {
          "email":email,
          "password":password,
        });

    print(response.body);

    if(response.statusCode==200){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(email:email.toString(),password:password.toString(),)));
    }
    else{
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          content: Text("Kullanıcı bilgileri yanlış"),
        );
      });
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
                SizedBox(height: 20,),
                //logo
                /* ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset("assets/images/gh.jpeg",scale: 2.5,)
                  ),*/
                Icon(Icons.lock,size: 100,),
                SizedBox(height: 20,),
                //welcome4
                Text("Uygulama Girişi",
                  style: TextStyle(
                    color: Colors.grey.shade700,fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),),

                SizedBox(height: 50,),
                //username textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: emailController,
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
                    controller: passwordController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400)

                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "Şifre",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        )
                    ),
                  ),
                ),
                SizedBox(height: 10,),


                //forgot password
                Padding(
                  padding: const EdgeInsets.only(right:25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Şifremi Unuttum?',
                        style: TextStyle(
                          color:Colors.grey[600],
                        ),),
                    ],
                  ),
                ),

                SizedBox(height: 20,),
                //sign in button
                GestureDetector(
                  //    onTap: signUserIn(),
                  child: Container(
                      padding: EdgeInsets.all(25),
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child:Center(
                        child: GestureDetector(
                          onTap: (){
                            login();
                          },
                          child: Text("Giriş Yap",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),),
                        ),

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
                      Text("İle Giriş Yap"), //yazı
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

                    GestureDetector(
                      onTap: () async
                      {
                        //final GoogleSignInAccount? googleUser= await _googleSignIn.signIn();
                        // final GoogleSignInAuthentication googleAuth =await googleUser!.authentication;

                      },
                      child: Container(
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
                SizedBox(height: 70,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Kayıtlı değil misiniz?"),
                    SizedBox(width: 4,),
                    GestureDetector(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                        },
                        child: Text(" Kayıt olun!",
                            style: TextStyle(
                                color: Colors.blue,fontWeight: FontWeight.bold
                            )
                        ))
                  ],
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
