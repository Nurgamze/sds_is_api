import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sds_is_platformu/const/sabitler.dart';
import 'package:sds_is_platformu/screens/yetkiliPage.dart';



class InsertYetkili extends StatefulWidget {

  const InsertYetkili({Key? key, required this.email, required this.password, required this.adsoyad, required this.id,}) : super(key: key);

  final String email;
  final String password;
  final String adsoyad;
  final int id;

  @override
  State<InsertYetkili> createState() => _InsertYetkiliState();
}


class _InsertYetkiliState extends State<InsertYetkili> {
  TextEditingController _adsoyad= TextEditingController();
  TextEditingController _email= TextEditingController();
  TextEditingController _password= TextEditingController();
  TextEditingController _unvan= TextEditingController();
  TextEditingController _gsm= TextEditingController();


  String? adsoyad,email,password,unvan,gsm;
  String url=apiUrl;


  void insertYetkili() async{
    adsoyad=_adsoyad.text;
    email=_email.text;
    password=_password.text;
    unvan=_unvan.text;
    gsm=_gsm.text;

    final response=await http.post(Uri.parse("$url/insertyetkili"),
    body:{
      "adsoyad":adsoyad,
      "email":email,
      "password":password,
      "unvan":unvan,
      "gsm":gsm,
     }
    );
    print("sbdv${response.body}");
    if(response.statusCode==201){
      Navigator.push(context, MaterialPageRoute(builder: (context) =>YetkiliPage(email: widget.email, password: widget.password,adsoyad: widget.adsoyad, id: widget.id,) ));
    }
    else{
      showDialog(
          context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text("Hata"),
          content: Text("Yetkili eklenirken bir sorun oluştu. Daha sonra tekrar deneyiniz"),
          actions: [
            ElevatedButton(onPressed: (){
              setState(() {

                Navigator.pop(context);
              });
            }, child: Text("Tamam"))
          ],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Yetkili Ekle"),
          centerTitle: true,
          backgroundColor: Colors.brown,
        ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TextFormField(
                controller: _adsoyad,
                decoration: InputDecoration(
                  labelText: "Ad Soyad",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  )
                ),
              ),
              SizedBox(height: 12,),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: 12,),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                    labelText: "Şifre",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: 12,),
              TextFormField(
                controller: _unvan,
                decoration: InputDecoration(
                    labelText: "Unvan",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: 12,),
              TextFormField(
                controller: _gsm,
                decoration: InputDecoration(
                    labelText: "Gsm",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: 20,),

              Container(
                width: MediaQuery.of(context).size.width *0.8,
                child: ElevatedButton(onPressed: (){
                  insertYetkili();
                }, child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text("Yetkili Ekle",style: TextStyle(fontSize: 15),),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
