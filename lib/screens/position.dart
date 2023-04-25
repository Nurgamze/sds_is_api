import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:sds_is_platformu/const/sabitler.dart';
import '../model/positionModel.dart' show Data, PositionModel;
import 'basvurupage.dart';
import 'homePage.dart';

class PozisyonPage extends StatefulWidget {
  final String email;
  final String password;
  const PozisyonPage({Key? key, required this.email, required this.password}) : super(key: key);

  @override
  State<PozisyonPage> createState() => _PozisyonPageState();

}
class _PozisyonPageState extends State<PozisyonPage> {

  PositionModel? positionModel;
  Iterable<Data> data = [];
  String url=apiUrl;


  @override
  void initState() {
    super.initState();
    pozisyonlar();
  }

  Future<void> pozisyonlar() async {
    final response = await http.get(
        Uri.parse("$url/position"));
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(email: widget.email, password: widget.password,)));
            },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: positionModel?.data?.length ?? 0,
                    itemBuilder: (BuildContext context ,int index) {
                      Data? d =positionModel?.data?.elementAt(index);
                      return GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BasvuruPage()));
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
                              subtitle: Text("Min Deneyim: ${d.deneyimYili} yıl"),
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
    );
  }
}
