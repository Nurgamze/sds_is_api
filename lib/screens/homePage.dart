import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sds_is_platformu/screens/gorusmeler.dart';
import 'package:sds_is_platformu/screens/isletmeler.dart';
import 'package:sds_is_platformu/screens/position.dart';
import 'package:sds_is_platformu/screens/yetkiliPage.dart';
import '../const/sabitler.dart';
import '../model/yetkiliModel.dart';
import 'adaylar.dart';
import 'kullanicilar.dart';


class HomePage extends StatefulWidget {
  final String email;
  final String password;
  final String adsoyad;
  final int id;
  const HomePage({Key? key, required this.email,required this.password, required this.adsoyad, required this.id}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   bool isAutherized= false;

  YetkiliModel? yetkiliModel;
  List<Yetkili?> yetkilisList = [];
   String url=apiUrl;

  @override
  void initState() {
    super.initState();
    yetkili();
  }

   Future<YetkiliModel?> yetkili() async {
     final response = await http.get(Uri.parse("$url/yetkili"),);
     if(response.statusCode == 200) {
       setState(() {
         yetkiliModel = YetkiliModel.fromJson(jsonDecode(response.body));
         yetkilisList = yetkiliModel!.yetkili!;
       });
     } else {
       throw Exception('API bağlantı sorunu. Hata kodu: ${response.statusCode}');
     }
   }

  @override
  Widget build(BuildContext context) {
    print("emaillll,${widget.email}");
    print("passwordd,${widget.password}");


    return Scaffold(
      appBar: AppBar(
        title: Text("SDS"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(email: widget.email, password: widget.password, adsoyad: widget.adsoyad, id: widget.id,)));
          },
        ),
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
            child:SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            for(var i=0 ; i<yetkilisList.length;i++){
                              if(yetkilisList[i]?.email==widget.email && yetkilisList[i]?.password==widget.password){
                                isAutherized=true;
                                break;
                              }
                            }
                            if(isAutherized){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>YetkiliPage(email:widget.email,password:widget.password, adsoyad: widget.adsoyad, id: widget.id,)));
                            }
                            else{
                              showDialog(
                                  context: context, builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("Hata"),
                                  content: Text("Yetkiniz Bulunmamaktadır!"),
                                  actions: [
                                    ElevatedButton(onPressed: (){
                                      setState(() {
                                        Navigator.pop(context);
                                      });

                                    }, child: Text("Tamam"),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[500]),)
                                  ],
                                );
                              });
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: SizedBox(
                              width: 180,
                              height: 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 7,
                                      offset: Offset(0,3),
                                    ),
                                  ],
                                ),
                                child: Card(
                                  color: Colors.grey[300],
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text("Yetkililer",style: TextStyle(fontSize:17 ),),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PozisyonPage(adsoyad:widget.adsoyad, id: widget.id,)));
                        },
                          child: SizedBox(
                            height: 100,
                            width: 180,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Card(
                                  color: Colors.grey[300],
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text("İş Pozisyonları",style: TextStyle(fontSize:17 ),),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        GestureDetector(onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>AdaylarPage(email: widget.email, password: widget.password, adsoyad: widget.adsoyad, id: widget.id,)));
                        },
                          child: SizedBox(
                            height: 100,
                            width: 180,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Card(
                                  color: Colors.grey[300],
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text("Adaylar",style: TextStyle(fontSize:17 ),),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>GorusmelerPage(email:widget.email,password:widget.password)));
                        },
                          child: SizedBox(
                            height: 100,
                            width: 180,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Card(
                                  color: Colors.grey[300],
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text("Görüşmeler",style: TextStyle(fontSize:17 ),),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                    child: Row(
                      children: [
                        GestureDetector(onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>IsletmelerPage(email:widget.email,password:widget.password, adsoyad: widget.adsoyad, id: widget.id,)));
                        },
                          child: SizedBox(
                            height: 100,
                            width: 180,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Card(
                                  color: Colors.grey[300],
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text("İşletmeler",style: TextStyle(fontSize:17 ),),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>KullanicilarPage(email:widget.email,password:widget.password, adsoyad: widget.adsoyad, id:widget.id)));
                        },
                          child: SizedBox(
                            height: 100,
                            width: 180,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Card(
                                  color: Colors.grey[300],
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text("Kullanıcılar",style: TextStyle(fontSize:17 ),),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
    );
  }
}
