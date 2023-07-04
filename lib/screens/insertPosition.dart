import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sds_is_platformu/model/isletmelerModel.dart';
import 'package:sds_is_platformu/screens/position.dart';
import '../const/sabitler.dart';
import '../model/isletmelerModel.dart' show Isletmeler,  IsletmeModel;
import '../model/positionModel.dart';


class PozisyonEkle extends StatefulWidget {

  final String adsoyad;
  final String email;
  final String password;
  final int id;

  const PozisyonEkle({Key? key, required this.adsoyad,required this.id, required this.email, required this.password}) : super(key: key);
  @override
  State<PozisyonEkle> createState() => _PozisyonEkleState();
}

class _PozisyonEkleState extends State<PozisyonEkle> {

        PositionModel? positionModel;
        List<Data?> positionList = [];
        IsletmeModel? isletmeModel;
        List<Isletme>? isletmeList=[];


      TextEditingController unvanCont =TextEditingController(),
       deneyimYiliCont=TextEditingController(),
       maxYasCont =TextEditingController(),
       minYasCont =TextEditingController(),
       seyehatCont =TextEditingController(),
       cinsiyetCont =TextEditingController(),
       askerlikCont =TextEditingController(),
       ehliyetCont =TextEditingController(),
       sehirContr =TextEditingController(),
       bolgeCont =TextEditingController(),
       mezuniyetCont =TextEditingController(),
       isletmeCont =TextEditingController();


      bool varSeyahatEngeli = false, yokSeyahatEngeli = false, kadinSecili = false, erkekSecili = false, yapildiSecili = false, yapilmadiSecili = false, ehliyetVar = false, ehliyetYok = false;
      String url=apiUrl;

      int? deneyimYili, maxYas, minYas, yetkiliId, isletmeId, seciliIsletmeId;

      String? seciliSehir,seciliBolge,yetkili,seciliMezuniyet,unvan,seyahatEngeli,cinsiyet,askerlik,ehliyet,sehir,bolge,mezuniyet;


      List<String> sehirler=['Adana', 'Ankara', 'İstanbul', 'İzmir', 'Bursa', 'Antalya', 'Mersin', 'Trabzon', 'Konya', 'Gaziantep',
       ];

      List<String> bolgeler=[
        'Bölge Seçiniz','Marmara','Ege' ,'Akdeniz','İç Anadolu'
      ];

      List<String> mezuniyetler=['Ortaöğretim','Lise','Lisans','Yüksek Lisans'];

        @override
        void initState() {
          super.initState();
          isletmelist();
        }


      Future<void> isletmelist() async {
        final response = await http.get(
            Uri.parse("$url/isletmeler")); // GET isteği

        if (response.statusCode == 200) {
          print(response.body);
        }
        setState(() {
          isletmeModel = IsletmeModel.fromJson(jsonDecode(response.body));
          isletmeList = isletmeModel!.isletme!;
        });
        print("işletme listesiiii $isletmeList");
      }
      void insertPosition() async{
        if ( unvanCont.text.isEmpty || deneyimYiliCont.text.isEmpty ||
            minYasCont.text.isEmpty || maxYasCont.text.isEmpty ||
            seyehatCont.text.isEmpty || cinsiyetCont.text.isEmpty ||
            askerlikCont.text.isEmpty || ehliyetCont.text.isEmpty ||
            sehirContr.text.isEmpty || bolgeCont.text.isEmpty || mezuniyetCont.text.isEmpty ||isletmeCont.text.isEmpty) {


          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Hata"),
              content: Text("Lütfen tüm alanları doldurun."),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Tamam"),
                ),
              ],
            ),
          );
          return;
        }
        unvan=unvanCont.text;
        yetkiliId=widget.id.toInt();
        yetkili=widget.adsoyad;
        deneyimYili=int.tryParse(deneyimYiliCont.text);
        minYas=int.tryParse(minYasCont.text);
        maxYas=int.tryParse(maxYasCont.text);
        seyahatEngeli=seyehatCont.text;
        cinsiyet=cinsiyetCont.text;
        askerlik=askerlikCont.text;
        ehliyet=ehliyetCont.text;
        sehir=sehirContr.text;
        bolge=bolgeCont.text;
        mezuniyet=mezuniyetCont.text;
        isletmeId=int.tryParse(isletmeCont.text);

        print("$unvan,$yetkili,$yetkiliId,$deneyimYili,$minYas,$maxYas,$seyahatEngeli,$cinsiyet,$askerlik,$sehir,$isletmeId,$mezuniyet}");


        final response=await http.post(Uri.parse("$url/insertposition"),
        body:{
          "unvan": unvan,
          "yetkili": widget.adsoyad,
          "isletmeId": isletmeId.toString(),
          "yetkiliId": widget.id.toString(),
          "deneyim_yili": deneyimYili.toString(),
          "min_yas": minYas.toString(),
          "max_yas": maxYas.toString(),
          "seyehat_engeli": seyahatEngeli,
          "cinsiyet": cinsiyet,
          "askerlik": askerlik,
          "ehliyet": ehliyet,
          "sehir": sehir,
          "bolge": bolge,
          "mezuniyet": mezuniyet
        });
        print("açılan pozisyon :${response.body}");
        if(response.statusCode==201) {
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: Text("Başarılı",),
            content: Text("Pozisyon açılmıştır."),
              actions: [
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PozisyonPage(adsoyad: widget.adsoyad, id: widget.id, email: widget.email, password: widget.password,)));
                }, child: Text("Tamam"))
              ],
            );
           }
         );
      }
        else{
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: Text("Başarısız",),
              content: Text("Pozisyon açılırken hata oluştu. Lütfen tekrar deneyiniz."),
              actions: [
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PozisyonEkle(adsoyad: widget.adsoyad, id: widget.id, email: widget.email, password: widget.password,)));
                }, child: Text("Tamam"))
              ],
            );
          }
          );
        }
    }

        @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pozisyon Aç"),
        centerTitle: true,
        backgroundColor: Color(0xFF0E47A1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TextFormField(
                controller: unvanCont,
                decoration: InputDecoration(
                  labelText: "Unvan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: deneyimYiliCont,
                decoration: InputDecoration(
                    labelText: "Deneyim Yılı",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(
                height:10,
              ),
              TextFormField(
                controller: minYasCont,
                decoration: InputDecoration(
                    labelText: "Min Yaş ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(
                height:10,
              ),
              TextFormField(
                controller: maxYasCont,
                decoration: InputDecoration(
                    labelText: "Max Yaş",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(
                height:10,
              ),
              TextFormField(
                controller: bolgeCont,
                decoration: InputDecoration(
                    labelText: "Bölge",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(
                height:10,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Seyehat Engeli:   ",style: TextStyle(fontSize: 16),),
                          Text(" Var",style: TextStyle(fontSize: 15),),
                          Checkbox(
                              value: varSeyahatEngeli,
                              onChanged: (value){
                                setState(() {
                                  varSeyahatEngeli=value!;
                                  if(varSeyahatEngeli){
                                    yokSeyahatEngeli = false;
                                    seyehatCont.text="True";
                                    //seyehatengelim varsa true dönecek
                                  }
                                });
                              }
                          ),
                          SizedBox(width: 42,),
                          Text("Yok",style: TextStyle(fontSize: 15),),
                          Checkbox(
                              value: yokSeyahatEngeli,
                              onChanged: (value){
                                setState(() {
                                  yokSeyahatEngeli=value!;
                                  if(yokSeyahatEngeli){
                                    varSeyahatEngeli = false;
                                    seyehatCont.text="False";
                                  }
                                });
                              }
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Cinsiyet:            ",style: TextStyle(fontSize: 16),),
                          Text("Kadın",style: TextStyle(fontSize: 15),),
                          Checkbox(
                              value: kadinSecili,
                              onChanged: (value){
                                setState(() {
                                  kadinSecili=value!;
                                  if(kadinSecili){
                                    erkekSecili=false;
                                    cinsiyetCont.text="Kadın";
                                  }
                                });
                              }
                          ),
                          SizedBox(width: 30,),
                          Text("Erkek",style: TextStyle(fontSize: 15),),
                          Checkbox(
                              value: erkekSecili,
                              onChanged: (value){
                                setState(() {
                                  erkekSecili=value!;
                                  if(erkekSecili){
                                    kadinSecili=false;
                                    cinsiyetCont.text="Erkek";
                                  }
                                });
                              }
                          ),
                        ],
                      ),
                      SizedBox(width: 15,)
                    ],
                  ),
                  SizedBox(height: 9,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Askerlik:          ",style: TextStyle(fontSize: 16),),
                          Text("Yapıldı",style: TextStyle(fontSize: 15),),
                          Checkbox(
                              value: yapildiSecili,
                              onChanged: (value){
                                setState(() {
                                  yapildiSecili=value!;
                                  if(yapildiSecili){
                                    yapilmadiSecili=false;
                                    askerlikCont.text="True";
                                  }
                                });
                              }
                          ),
                          SizedBox(height: 1),
                          Text("Yapılmadı",style: TextStyle(fontSize: 15),),
                          Checkbox(
                              value: yapilmadiSecili,
                              onChanged: (value){
                                setState(() {
                                  yapilmadiSecili=value!;
                                  if(yapilmadiSecili){
                                    yapildiSecili=false;
                                    askerlikCont.text="False";
                                  }
                                });
                              }
                          ),
                        ],
                      ),
                      SizedBox(width: 15,)
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Ehliyet:                  ",style: TextStyle(fontSize: 16),),
                          Text("Var",style: TextStyle(fontSize: 15),),
                          Checkbox(
                              value: ehliyetVar,
                              onChanged: (value){
                                setState(() {
                                  ehliyetVar=value!;
                                  if(ehliyetVar){
                                    ehliyetYok=false;
                                    ehliyetCont.text="True";
                                  }
                                });
                              }
                          ),
                          SizedBox(width: 40,),
                          Text("Yok",style: TextStyle(fontSize: 15),),
                          Checkbox(
                              value: ehliyetYok,
                              onChanged: (value){
                                setState(() {
                                  ehliyetYok=value!;
                                  if(ehliyetYok){
                                    ehliyetVar=false;
                                    ehliyetCont.text="False";
                                  }
                                });
                              }
                          ),
                        ],
                      ),
                      SizedBox(width: 15,)
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Şehir:",style: TextStyle(fontSize: 16),),
                      SizedBox(width: 65,),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          children: [
                            Container(
                              width:130,
                              child: DropdownButton(
                                isExpanded: false,
                                hint:Text("Şehir Seçiniz"),
                                value: seciliSehir,
                                onChanged: (yeniSehir){
                                  setState(() {
                                    seciliSehir=yeniSehir.toString();
                                    sehirContr.text=seciliSehir!;
                                  });
                                },
                                items: sehirler.map((sehir) => DropdownMenuItem(
                                  child: Text(sehir),
                                  value: sehir =='' ? null: sehir,
                                )).toList(),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Mezuniyet:",style: TextStyle(fontSize: 16),),
                      SizedBox(width: 30,),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          children: [
                            Container(
                              width:160,
                              child: DropdownButton(
                                hint: Text("Mezuniyet Seç"),
                                isExpanded: false,
                                value: seciliMezuniyet,
                                onChanged: (yeniMezuniyet){
                                  setState(() {

                                    seciliMezuniyet=yeniMezuniyet.toString();
                                    mezuniyetCont.text=seciliMezuniyet!;

                                  });
                                },
                                items: mezuniyetler.map((mezuniyet) => DropdownMenuItem(
                                  child: Text("$mezuniyet"),
                                  value: mezuniyet =='' ? null: mezuniyet,
                                )).toList(),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text("İşletme:",style: TextStyle(fontSize: 16),),
                      SizedBox(width: 40,),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          children: [
                            Container(
                              width:MediaQuery.of(context).size.width * 0.65,
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Text("İşletme Merkezi Seç"),
                                value: seciliIsletmeId,
                                onChanged: (yeniIsletmeId){
                                  setState(() {
                                    seciliIsletmeId=int.tryParse(yeniIsletmeId.toString());
                                    isletmeCont.text=seciliIsletmeId.toString();
                                  });
                                },
                                items: isletmeList?.map((isletme) => DropdownMenuItem(
                                  child: Text(isletme.unvan.toString().split(" ").take(5).join(" ")),
                                  value: isletme.id,
                                )).toList(),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),


                  SizedBox(height: 15,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          insertPosition();
                        });

                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text("Pozisyon Aç",style: TextStyle(fontSize: 18),),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0E47A1),),
                    ),
                  ),
                  SizedBox(
                    height: 85,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
