import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sds_is_platformu/screens/gorusmeler.dart';
import '../const/sabitler.dart';
import '../model/adaylarModel.dart';
import '../model/positionModel.dart';
import 'homePage.dart';



class GorusmeEkle extends StatefulWidget {
  final String email;
  final String password;
  final String adsoyad;
  final int id;
  const GorusmeEkle({Key? key, required this.email, required this.password, required this.adsoyad, required this.id,}) : super(key: key);


  @override
  State<GorusmeEkle> createState() => _GorusmeEkleState();
}

class _GorusmeEkleState extends State<GorusmeEkle> {

  PositionModel? positionModel;
  List<Data?> positionList = [];

  AdayModel? adayModel;
  List<Aday?> adayListesi = [];

  TextEditingController pozisyonCont =TextEditingController(),
      adayCont=TextEditingController(),
      tarihCont =TextEditingController(),
      saatCont =TextEditingController(),
      notCont =TextEditingController();

  String? tarih,saat,degerlendirme;

  int? seciliPozisyon_id,seciliAday_id;
  String url=apiUrl;
  DateTime selectedDate = DateTime.now();
  DateTime? _selectedTime;

  @override
  void initState() {
    super.initState();
    pozisyonList();
    adayList();
  }

  Future<void> adayList() async {
    final response = await http.get(Uri.parse("$url/adaylar")); // GET isteği

    if (response.statusCode == 200) {
      print(response.body);
    }
    setState(() {
      adayModel = AdayModel.fromJson(jsonDecode(response.body));
      adayListesi = adayModel!.aday!;
    });

    //print("aday listesiiii $adayListesi");
  }


  Future<void> pozisyonList() async {
    final response = await http.get(Uri.parse("$url/position")); // GET request

    if (response.statusCode == 200) {
      print(response.body);
    }
    setState(() {
      positionModel = PositionModel.fromJson(jsonDecode(response.body));
      positionList = positionModel!.data!.toSet().toList();
    });
    print("pozisyon listesiiii $positionList");
  }




  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(Duration(days: 3650)));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        tarihCont.text = DateFormat('MM/dd/yyyy').format(selectedDate); // Değişkeninizi güncelleyin
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
        saatCont.text = DateFormat("h:mm a").format(_selectedTime!);
      });
    }
  }

  void insertGorusme() async{
    if ( pozisyonCont.text.isEmpty || adayCont.text.isEmpty ||
        tarihCont.text.isEmpty || saatCont.text.isEmpty)
    {

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

    seciliPozisyon_id=int.tryParse(pozisyonCont.text);
    seciliAday_id=int.tryParse(adayCont.text);
    tarih=tarihCont.text;
    saat=saatCont.text;
    degerlendirme = notCont.text.isEmpty ? null : notCont.text;

    print("$seciliPozisyon_id,$seciliAday_id,$tarih,$saat,$degerlendirme}");


    final response=await http.post(Uri.parse("$url/insertgorusme"),
        body:{
          "pozisyon_id": seciliPozisyon_id.toString(),
          "aday_id": seciliAday_id.toString(),
          "tarih": tarih,
          "saat": saat,
          "degerlendirme": degerlendirme ?? "",
        });

    print("oluşturulan görüşme  :${response.body}");
    if(response.statusCode==201) {
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text("Başarılı",),
          content: Text("Görüşme oluşturulmuştur."),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>GorusmelerPage(adsoyad: widget.adsoyad, id:widget.id, email: widget.email, password: widget.password,)));
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
          content: Text("Görüşme oluşturulken hata oluştu. Lütfen tekrar deneyiniz."),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>GorusmelerPage(adsoyad: widget.adsoyad, id:widget.id, email: widget.email, password: widget.password,)));
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
        title: Text("Görüşme Oluştur"),
        centerTitle: true,
        backgroundColor:Color(0xFF0E47A1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(email: widget.email, password: widget.password, adsoyad: widget.adsoyad, id: widget.id,)));
          },),

      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children:[
              Row(
                children: [
                  Text("Pozisyon:",style: TextStyle(fontSize: 16),),
                  SizedBox(width: 50,),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      children: [
                        Container(
                          width:MediaQuery.of(context).size.width * 0.65,
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text("Pozisyon Seç"),
                            value: seciliPozisyon_id,
                            onChanged: (secilenPosition){
                              setState(() {
                                seciliPozisyon_id=int.tryParse(secilenPosition.toString());
                                pozisyonCont.text=seciliPozisyon_id.toString();
                              });
                            },
                            items: positionList?.map((pozisyon) => DropdownMenuItem(
                              child: Text(pozisyon!.unvan.toString()),
                              value: pozisyon.id,
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
                  Text("Aday:",style: TextStyle(fontSize: 16),),
                  SizedBox(width: 75,),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      children: [
                        Container(
                          width:MediaQuery.of(context).size.width * 0.65,
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text("Aday Seç"),
                            value: seciliAday_id,
                            onChanged: (secilenAday){
                              setState(() {
                                seciliAday_id=int.tryParse(secilenAday.toString());
                                adayCont.text=seciliAday_id.toString();
                              });
                            },
                            items: adayListesi?.map((aday) => DropdownMenuItem(
                              child: Text("${aday!.ad.toString()+" "+ aday!.soyad.toString()}"),
                              value: aday.id,
                            )).toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height:20,
              ),
              Row(
                children: [
                  Text("Tarih: "),
                  SizedBox(width: 75,),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _selectDate(context);
                    },
                    child: Text(
                      selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(selectedDate)
                          : 'Tarih',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height:20,
              ),
              Row(
                children: [
                  Text("Saat: "),
                  SizedBox(width: 63),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _selectTime(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: Text(
                        _selectedTime != null
                            ? DateFormat.jm().format(_selectedTime!)
                            : DateFormat.jm().format(DateTime.now()),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height:10,
              ),

              TextFormField(
                controller: notCont,
                decoration: InputDecoration(
                    labelText: "Not",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(
                height: 55,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: ElevatedButton(
                  onPressed: (){
                    setState(() {
                      insertGorusme();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text("Oluştur",style: TextStyle(fontSize: 18),),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor:Color(0xFF0E47A1),),
                ),
              ),
              SizedBox(
                height: 85,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
