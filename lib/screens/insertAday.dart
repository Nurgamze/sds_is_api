import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sds_is_platformu/screens/adaylar.dart';
import '../const/sabitler.dart';

class AdayEkle extends StatefulWidget {
  final String email;
  final String password;
  final String adsoyad;
  final int id;
  const AdayEkle({Key? key, required this.email, required this.password, required this.adsoyad, required this.id,}) : super(key: key);

  @override
  State<AdayEkle> createState() => _AdayEkleState();
}

class _AdayEkleState extends State<AdayEkle> {

  TextEditingController adController =TextEditingController(),
      soyadController =TextEditingController(),
      telNoController =TextEditingController(),
      mailController =TextEditingController(),
      mezuniyetController =TextEditingController(),
      yasController =TextEditingController(),
      dogumTarihiController =TextEditingController(),
      yasadigiSehirController =TextEditingController(),
      dogduguSehirController =TextEditingController(),
      sonIsyeriController = TextEditingController(),
      cinsiyetController = TextEditingController(),
      ehliyetController = TextEditingController(),
      askerlikController = TextEditingController(),
      sigaraController = TextEditingController(),
      alkolController = TextEditingController(),
      evlilikController = TextEditingController(),
      toplamDeneyimController = TextEditingController(),
      cvController = TextEditingController(),
      sonIsyeriCalismaController = TextEditingController(),
      cocukSayisiController = TextEditingController();

     //isletmeController = TextEditingController(),

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateTime) {
      setState(() {
        _selectedDateTime = picked.toUtc();
        _selectedDate = DateFormat('yyyy.MM.dd', 'tr_TR').format(_selectedDateTime!);
        dogumTarihiController.text = DateFormat('dd.MM.yyyy').format(_selectedDateTime!);
      });
    }
  }


  String url=apiUrl;

  bool kadinSecili = false, erkekSecili = false,yapildiSecili = false,yapilmadiSecili = false,ehliyetVar = false,ehliyetYok = false,
       sigaraVar = false,sigaraYok = false,alkolVar = false,alkolYok = false, evlilikVar = false,evlilikYok = false;

  int? yas, telNo, toplam_deneyim ; /*yetkiliId, isletmeId, seciliIsletmeId*/
  int cocuksayisi=0;
  String? ad, soyad, email, yasadigi_sehir ,dogdugu_sehir, sonIsyeri,son_IsyeriSuresi, cv_url, /*yetkili*/ seciliMezuniyet,cinsiyet,askerlik,ehliyet,sigara,alkol,evlilik;

  String? _selectedDate;
  DateTime? _selectedDateTime;

  List<String> mezuniyetler=['Ortaöğretim','Lise','Lisans','Yüksek Lisans'];


  void insertAday() async{

    if (
        adController.text.isEmpty || soyadController.text.isEmpty ||
        telNoController.text.isEmpty || mezuniyetController.text.isEmpty ||
        mailController.text.isEmpty || yasController.text.isEmpty ||
        dogumTarihiController.text.isEmpty || yasadigiSehirController.text.isEmpty ||
        dogduguSehirController.text.isEmpty || sonIsyeriController.text.isEmpty ||
        cinsiyetController.text.isEmpty ||ehliyetController.text.isEmpty ||
        askerlikController.text.isEmpty ||sigaraController.text.isEmpty ||
        alkolController.text.isEmpty ||evlilikController.text.isEmpty ||
        toplamDeneyimController.text.isEmpty ||cvController.text.isEmpty ||
        alkolController.text.isEmpty ||evlilikController.text.isEmpty ||
        sonIsyeriCalismaController.text.isEmpty ||cocukSayisiController.text.isEmpty

    ) {
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
    ad=adController.text;
    soyad=soyadController.text;
    telNo=int.tryParse(telNoController.text);
    email=mailController.text;
    yas=int.tryParse(yasController.text);
    _selectedDate = dogumTarihiController.text;
    yasadigi_sehir=yasadigiSehirController.text;
    dogdugu_sehir=dogduguSehirController.text;
    toplam_deneyim=int.tryParse(toplamDeneyimController.text);
    sonIsyeri=sonIsyeriController.text;
    son_IsyeriSuresi=sonIsyeriCalismaController.text;
    cv_url=cvController.text;
    seciliMezuniyet=mezuniyetController.text;
    cinsiyet=cinsiyetController.text;
    askerlik=askerlikController.text;
    ehliyet=ehliyetController.text;
    sigara=sigaraController.text;
    alkol=alkolController.text;
    evlilik=evlilikController.text;
    cocuksayisi=int.tryParse(cocukSayisiController.text)!;
    //yetkiliId=widget.id.toInt();
    //yetkili=widget.adsoyad;
    //isletmeId=int.tryParse(isletmeCont.text);

    print("$ad,$soyad ,$telNo ,$email ,$yas ,$_selectedDate,$yasadigi_sehir ,$dogdugu_sehir ,$toplam_deneyim , $sonIsyeri, $son_IsyeriSuresi ,$cv_url ,$seciliMezuniyet ,$cinsiyet ,$askerlik ,$sigara ,$alkol ,$evlilik ,$cocuksayisi}"/*$yetkili,$yetkiliId*/);

    String utcDate = _selectedDateTime!.toUtc().toIso8601String();
    final response=await http.post(Uri.parse("$url/insertaday"),
        body:{
          "ad": ad,
          "soyad": soyad,
          "gsm": telNo.toString(),
          "email": email,
          "cv_url": cv_url,
          "cinsiyet": cinsiyet,
          "yas": yas.toString(),
          "dogum_tarihi": utcDate,
          "askerlik": askerlik,
          "ehliyet": ehliyet,
          "mezuniyet": seciliMezuniyet,
          "yasadigi_sehir": yasadigi_sehir,
          "dogdugu_sehir": dogdugu_sehir,
          "sigara": sigara,
          "alkol": alkol,
          "evlilik": evlilik,
          "cocuk_sayisi": cocuksayisi.toString(),
          "toplam_deneyim": toplam_deneyim.toString(),
          "son_isyeri": sonIsyeri,
          "son_isyeri_suresi": son_IsyeriSuresi,

        });
    print("Eklenen aday :${response.body}");
    if(response.statusCode==201) {
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text("Başarılı",),
          content: Text("Aday eklenmiştir."),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AdaylarPage(email: widget.email, password: widget.password, adsoyad: widget.adsoyad, id: widget.id,)));
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AdaylarPage(email: widget.email, password: widget.password, adsoyad: widget.adsoyad, id: widget.id,)));
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
        title: Text("Aday Ekle"),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: adController,
                decoration: InputDecoration(
                    labelText: "Ad :",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: soyadController,
                decoration: InputDecoration(
                    labelText: "Soyad :",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: telNoController,
                maxLength: 11,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Telefon Numarası :",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: mailController,
                decoration: InputDecoration(
                    labelText: "E-Mail :",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: yasController,
                keyboardType:TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Yaş:",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: dogumTarihiController,
                    decoration: InputDecoration(
                      labelText: 'Doğum Tarihi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: yasadigiSehirController,
                decoration: InputDecoration(
                    labelText: "Yaşadığı Şehir:",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: dogduguSehirController,
                decoration: InputDecoration(
                    labelText: "Doğduğu Şehir:",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: toplamDeneyimController,
                keyboardType:TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Toplam Deneyim:",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: sonIsyeriController,
                decoration: InputDecoration(
                    labelText: "Son İşyeri:",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: sonIsyeriCalismaController,
                decoration: InputDecoration(
                    labelText: "Son İşyeri Çalışma Süresi:",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: cvController,
                decoration: InputDecoration(
                    labelText: "CV URL:",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Mezuniyet:",style: TextStyle(fontSize: 16),),
                  SizedBox(width: 40,),
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
                                mezuniyetController.text=seciliMezuniyet!;
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
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    cinsiyetController.text="Kadın";
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
                                    cinsiyetController.text="Erkek";
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
                                    askerlikController.text="True";
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
                                    askerlikController.text="False";
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
                                    ehliyetController.text="True";
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
                                    ehliyetController.text="False";
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
                          Text("Sigara:                  ",style: TextStyle(fontSize: 16),),
                          Text("Var",style: TextStyle(fontSize: 15),),
                          Checkbox(
                              value: sigaraVar,
                              onChanged: (value){
                                setState(() {
                                  sigaraVar=value!;
                                  if(sigaraVar){
                                    sigaraYok=false;
                                    sigaraController.text="True";
                                  }
                                });
                              }
                          ),
                          SizedBox(width: 40,),
                          Text("Yok",style: TextStyle(fontSize: 15),),
                          Checkbox(
                              value: sigaraYok,
                              onChanged: (value){
                                setState(() {
                                  sigaraYok=value!;
                                  if(sigaraYok){
                                    sigaraVar=false;
                                    sigaraController.text="False";
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
                          Text("Alkol:                     ",style: TextStyle(fontSize: 16),),
                          Text("Var",style: TextStyle(fontSize: 15),),
                          Checkbox(
                              value: alkolVar,
                              onChanged: (value){
                                setState(() {
                                  alkolVar=value!;
                                  if(alkolVar){
                                    alkolYok=false;
                                    alkolController.text="True";
                                  }
                                });
                              }
                          ),
                          SizedBox(width: 40,),
                          Text("Yok",style: TextStyle(fontSize: 15),),
                          Checkbox(
                              value: alkolYok,
                              onChanged: (value){
                                setState(() {
                                  alkolYok=value!;
                                  if(alkolYok){
                                    alkolVar=false;
                                    alkolController.text="False";
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
                          Text("Medeni Hal:          ",style: TextStyle(fontSize: 16),),
                          Text("Evli",style: TextStyle(fontSize: 15),),
                          Checkbox(
                              value: evlilikVar,
                              onChanged: (value){
                                setState(() {
                                  evlilikVar=value!;
                                  if(evlilikVar){
                                    evlilikYok=false;
                                    evlilikController.text="True";
                                  }
                                });
                              }
                          ),
                          SizedBox(width: 25,),
                          Text("Bekar",style: TextStyle(fontSize: 15),),
                          Checkbox(
                              value: evlilikYok,
                              onChanged: (value){
                                setState(() {
                                  evlilikYok=value!;
                                  if(evlilikYok){
                                    evlilikVar=false;
                                    evlilikController.text="False";
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
                    children: [
                      Text("Çocuk Sayısı"),
                      IconButton(onPressed: (){
                        setState(() {
                          cocuksayisi ??= 0;
                          cocuksayisi++;
                          cocukSayisiController.text=cocuksayisi.toString();
                        });
                      },
                          icon: Icon(Icons.add)),
                      Text(cocuksayisi.toString(),style: TextStyle(fontSize: 18),),
                      IconButton(onPressed: (){
                        setState(() {
                          cocuksayisi ??= 0;
                          if(cocuksayisi! > 0){
                            cocuksayisi--;
                            cocukSayisiController.text=cocuksayisi.toString();
                          }
                        });
                      }, icon:Icon(Icons.remove) )

                    ],
                  ),
                  SizedBox(height: 15,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          insertAday();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text("Aday Ekle",style: TextStyle(fontSize: 18),),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
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
