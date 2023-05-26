import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:sds_is_platformu/const/sabitler.dart';
import '../model/positionModel.dart' show Data, PositionModel;
import 'insertPosition.dart';
import 'pozisyonDetay.dart';

class PozisyonPage extends StatefulWidget {
  final String adsoyad;
  final int id;

  const PozisyonPage({Key? key, required  this.adsoyad, required this.id,}) : super(key: key);



  @override
  State<PozisyonPage> createState() => _PozisyonPageState();

}
class _PozisyonPageState extends State<PozisyonPage> {

  PositionModel? positionModel;
  String url=apiUrl;

  @override
  void initState() {
    super.initState();
    pozisyonlar();
  }

  Future<void> pozisyonlar() async {
    final response = await http.get(Uri.parse("$url/position"));
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        positionModel = PositionModel.fromJson(json.decode(response.body));
      });
      print("positionmodel: $positionModel");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İş Pozisyonları"),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),

      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height *0.85,
                child: ListView.builder(
                  itemExtent: 100,
                    itemCount: positionModel?.data?.length ?? 0,
                    itemBuilder: (BuildContext context ,int index) {
                      Data? d =positionModel?.data?.elementAt(index);
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> PozisyonDetay(data: d)));
                        },
                        child: Card(
                          child: ListTile(
                            title:Text.rich(
                              TextSpan(
                                text: 'Pozisyon Adı: ',style: TextStyle(fontWeight: FontWeight.w500),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${d!.unvan.toString()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey[600], // değiştirmek istediğiniz renk
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top:10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(text: "Talebi Oluşturan : ",style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(text: '${d.yetkili}', style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey[600], // değiştirmek istediğiniz renk
                                          ),),
                                        ]),
                                  ),
                                  SizedBox(height: 8,),
                                  Text.rich(
                                    TextSpan(text: "Min Deneyim :",style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(text: ' ${d.deneyimYili} yıl', style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey[600], // değiştirmek istediğiniz renk
                                          ),),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                          ) ,
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 56,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PozisyonEkle(adsoyad:widget.adsoyad, id: widget.id,)));
         print("posiyon ekleye gitti");
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.brown,
        ),
      ),
    );
  }
}
