import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sds_is_platformu/model/positionModel.dart';


class PozisyonDetay extends StatefulWidget {

  final Data data;
  const PozisyonDetay({Key? key,required this.data}) : super(key: key);

  @override
  State<PozisyonDetay> createState() => _PozisyonDetayState();
}

class _PozisyonDetayState extends State<PozisyonDetay> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.data.unvan}"),
        centerTitle: true,
        backgroundColor: Colors.brown,


      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0,1)
                    )
                  ],
                  border:Border.all(color: Colors.grey.shade300,),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 3,left: 7),
                  child: Image.asset("assets/images/vLogo.png", ),
                ),
              ),
              SizedBox(height: 20,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                      "${widget.data.unvan}",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,)
                  ),
                  SizedBox(height:10),
                  Text("${widget.data.isletme}"),
                  SizedBox(height:15),
                  Divider(color: Colors.grey.shade500,),
                  SizedBox(height: 5,),
                  Text("ÇALIŞMA ŞEKLİ",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 5,),
                  Text("Tam Zamanlı"),
                  Divider(color: Colors.grey.shade500,),
                  SizedBox(height: 15,),
                  Text("ADAY KRİTERLERİ",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 16,),

                  Text("Bölge",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 6,),
                  Text("Tercihen ${widget.data.bolge} Bölgesinde yaşayan"),
                  SizedBox(height: 6,),
                  Divider(color: Colors.grey.shade500,),
                  SizedBox(height: 6,),

                  Text("Şehir",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 6,),
                  Text("Tercihen ${widget.data.sehir} İlinde ikamet eden  "),
                  SizedBox(height: 6,),
                  Divider(color: Colors.grey.shade500,),
                  SizedBox(height: 6,),

                  Text("Yaş Aralığı",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 6,),
                  Text(" ${widget.data.minYas} - ${widget.data.maxYas} arasında olan "),
                  SizedBox(height: 6,),
                  Divider(color: Colors.grey.shade500,),
                  SizedBox(height: 6,),

                  Text("Seyehat Engeli",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 6,),
                  Text("Tercihen seyehat engeli olmayan"),
                  SizedBox(height: 6,),
                  Divider(color: Colors.grey.shade500,),
                  SizedBox(height: 6,),

                  Text("Deneyim",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 6,),
                  Text("Deneyim ${widget.data.deneyimYili}+ yıl ve üstü olanlar "),
                  SizedBox(height: 6,),
                  Divider(color: Colors.grey.shade500,),
                  SizedBox(height: 6,),

                  Text("Eğitim Seviyesi",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 6,),
                  Text("Mezuniyet ${widget.data.mezuniyet}+  üstü olanlar "),
                  Divider(color: Colors.grey.shade500,),
                  SizedBox(height: 20,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
