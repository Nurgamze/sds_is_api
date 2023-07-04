import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sds_is_platformu/model/gorusmelerModel.dart';
import 'package:sds_is_platformu/model/yetkiliModel.dart';
import '../const/sabitler.dart';
import 'package:http/http.dart' as http;
import '../model/gorusmeyeKatilimModel.dart';
import 'homePage.dart';
import 'insertGorusme.dart';

class GorusmelerPage extends StatefulWidget {
  final String email;
  final String password;
  final String adsoyad;
  final int id;

  const GorusmelerPage({Key? key, required this.email, required this.password, required this.adsoyad, required this.id,}) : super(key: key);

  @override
  State<GorusmelerPage> createState() => _GorusmelerPageState();
}
class _GorusmelerPageState extends State<GorusmelerPage> {


  GorusmeModel? gorusmeModel;
  List<Gorusme?> gorusmeList = [];
  List<Gorusme?> filteredGorusmeList = [];

  GorusmeyeKatilimModel? gorusmeyeKatilimModel;
  List<GorusmeyeKatilim?> gorusmeYetkiliList = [];
  List<GorusmeyeKatilim?> GorusmeYetkiliList = [];

  YetkiliModel? yetkiliModel;
  List<Yetkili>? yetkiliList = [];
  //List<Yetkili?> YetkiliList = [];

  TextEditingController notCont = TextEditingController();
  final searchYetkiliController = TextEditingController();
  final searchIsletmeController = TextEditingController();
  final searchAdayController = TextEditingController();
  final searchPozisyonController = TextEditingController();
  final secilenYetkiliController = TextEditingController();


  @override
  void initState() {
    super.initState();
    gorusmeler();
    gorusmeyeKatilim();
    yetkililer();
  }

  String url = apiUrl;
  DateTime? selectedBaslangic;
  DateTime? selectedBitis;
  int? seciliYetkiliId;
  String selectedYetkiliName = '';
  String bitisTarihiText = 'Bitiş Tarihi';
  String baslangicTarihiText = 'Başlangıç Tarihi';
  String? yetkiliID;
  int? gorusmeId,yetkiliIdd;

  Future<void> yetkililer() async {
    final response = await http.get(Uri.parse("$url/yetkili"));
    if (response.statusCode == 200) {
      print(response.body);
    }
    setState(() {
      yetkiliModel = YetkiliModel.fromJson(jsonDecode(response.body));
      yetkiliList = yetkiliModel!.yetkili!;
    });
  }

  Future<void> gorusmeler() async {
    final response = await http.get(Uri.parse("$url/gorusmeler"));
    if (response.statusCode == 200) {
      print(response.body);
    }
    setState(() {
      gorusmeModel = GorusmeModel.fromJson(jsonDecode(response.body));
      gorusmeList = gorusmeModel!.gorusmeler!;
      filteredGorusmeList=gorusmeList;
    });
  }

  Future<void> gorusmeyeKatilim() async {
    final response = await http.get(Uri.parse("$url/gorusmeyekatilim"));
    if (response.statusCode == 200) {
      print(response.body);
    }
    setState(() {
      gorusmeyeKatilimModel = GorusmeyeKatilimModel.fromJson(jsonDecode(response.body));
      gorusmeYetkiliList = gorusmeyeKatilimModel!.data!;
      //GorusmeYetkiliList=gorusmeYetkiliList;
    });
  }

  void showGorusmeYetkililer(Gorusme gorusme) {
    setState(() {
      GorusmeYetkiliList = gorusmeYetkiliList.where((yetkili) => yetkili!.gorusmeId == gorusme.id).toList();
    });
  }

  void filterGorusmeYetkili(String query) {
    setState(() {
      filteredGorusmeList = gorusmeList.where((gorusme) => gorusme!.yetkiliID!.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }
  void filterGorusmeIsletme(String query) {
    setState(() {
      filteredGorusmeList = gorusmeList.where((gorusme) => gorusme!.isletmeID!.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }
  void filterGorusmeAday(String query) {
    setState(() {
      filteredGorusmeList = gorusmeList.where((gorusme) => gorusme!.adayID!.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }
  void filterGorusmePozisyon(String query) {
    setState(() {
      filteredGorusmeList = gorusmeList.where((gorusme) => gorusme!.pozisyonID!.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void filterGorusmeTarih(DateTime? baslangic, DateTime? bitis) {
    setState(() {
      if (baslangic != null && bitis != null) {
        filteredGorusmeList = gorusmeList.where((gorusme) {
          final gorusmeTarihi = DateTime.parse(gorusme!.tarih!);
          return gorusmeTarihi.isAfter(baslangic.subtract(Duration(days: 1))) &&
              gorusmeTarihi.isBefore(bitis.add(Duration(days: 1)));
        }).toList();
      } else {
        filteredGorusmeList = gorusmeList;
      }
    });
  }
  void showBaslangicDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedBaslangic = pickedDate;
        baslangicTarihiText =DateFormat('dd/MM/yyyy').format(selectedBaslangic!);
      });
      filterGorusmeTarih(selectedBaslangic, selectedBitis);
    }
  }
  void showBitisDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedBitis = pickedDate;
        bitisTarihiText = DateFormat('dd/MM/yyyy').format(selectedBitis!);
      });
      filterGorusmeTarih(selectedBaslangic, selectedBitis);
    }
  }
  void _showDialog(Gorusme gorusme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not Düzenle'),
          content: TextFormField(
            controller: notCont..text = gorusme.degerlendirme ?? "",
            decoration: InputDecoration(hintText: 'Notunuzu girin.'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final response = await http.post(
                    Uri.parse('$url/insertnot/${gorusme.id}'),
                    body: {'degerlendirme': notCont.text});
                if (response.statusCode == 201) {
                  gorusmeler();
                } else {
                  print('Not güncellenirken bir hata oluştu. Hata kodu: ${response.statusCode}');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Hata var'),
                      );
                    },
                  );
                }
                Navigator.pop(context);
              },
              child: Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }
  void _showDialog2(Gorusme gorusme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not Ekle'),
          content: TextFormField(
            controller: notCont..text = gorusme.degerlendirme ?? "",
            decoration: InputDecoration(hintText: 'Notunuzu girin.'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final response = await http.post(Uri.parse('$url/insertnot/${gorusme.id}'),
                    body: {'degerlendirme': notCont.text});
                if (response.statusCode == 201) {
                  gorusmeler();
                } else {
                  print('Not güncellenirken bir hata oluştu. Hata kodu: ${response.statusCode}');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Hata var'),
                      );
                    },
                  );
                }
                Navigator.pop(context);
              },
              child: Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Görüşmeler'),
          centerTitle: true,
          backgroundColor: Color(0xFF0E47A1),
          leading:IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(email: widget.email, password: widget.password, adsoyad: widget.adsoyad, id: widget.id,)));
            },),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width:145,
                          height: 40,
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'İşletme Ara', hintStyle: TextStyle(color: Colors.grey,fontSize: 15),contentPadding: EdgeInsets.symmetric(vertical: 8.0,),
                              prefixIcon:Icon(Icons.search,size: 17,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              filterGorusmeIsletme(value);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width:145,
                          height: 40,
                          child: TextFormField(
                            controller: searchAdayController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Aday Ara', hintStyle: TextStyle(color: Colors.grey,fontSize: 15),contentPadding: EdgeInsets.symmetric(vertical: 8.0, ),
                              prefixIcon:Icon(Icons.search,size: 17,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              filterGorusmeAday(value);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width:153,
                          height: 40,
                          child: TextFormField(
                            controller: searchPozisyonController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Pozisyon Ara', hintStyle: TextStyle(color: Colors.grey,fontSize: 15),contentPadding: EdgeInsets.symmetric(vertical: 8.0, ),
                              prefixIcon:Icon(Icons.search,size: 17,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              filterGorusmePozisyon(value);
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 45,),
                      ElevatedButton(
                        onPressed: (){
                          showBaslangicDatePicker();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(baslangicTarihiText),
                        ),
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0E47A1),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text('-',style: TextStyle(fontSize: 25),),
                      ),
                      ElevatedButton(
                        onPressed: (){
                          showBitisDatePicker();
                        },
                        child: Container(
                          width: 105,
                          child: Padding(
                            padding: const EdgeInsets.all(8.5),
                            child: Center(child: Text(bitisTarihiText)),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0E47A1),),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        DataTable(
                          columnSpacing: 36,//Hücreler arasındaki boşluk miktarı
                          columns:  [
                            DataColumn(label: Text('İşletme')),
                            DataColumn(label: Text('Aday ')),
                            DataColumn(label: Text('Pozisyon')),
                            DataColumn(label: Text('Tarih ')),
                            DataColumn(label: Text('Saat')),
                            DataColumn(label: Text('Değerlendirme')),
                            DataColumn(label: Text('Yetkili')),

                          ],
                          rows: filteredGorusmeList.map((gorusme) => DataRow(
                            cells: [
                              DataCell(Text(gorusme!.isletmeID!.split(" ").take(2).join( " "))), // 2 kelimesini alır sadece
                              DataCell(Text(gorusme.adayID!)),
                              DataCell(Text(gorusme.pozisyonID!)),
                              DataCell(GestureDetector(child: Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(gorusme.tarih.toString()))),),),
                              DataCell(Text(DateFormat('HH:mm').format(DateTime.parse(gorusme.saat!.toString())))),
                              DataCell(gorusme.degerlendirme != null  && gorusme.degerlendirme!.isNotEmpty ?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded( child: Container(
                                      child: Text( gorusme.degerlendirme! ),
                                     width: 150,)),
                                  SizedBox(width: 20,),
                                  ElevatedButton(onPressed: (){
                                    _showDialog(gorusme);
                                  },
                                    child: Text('Not Düzenle '),
                                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0EF6C00),  padding:EdgeInsets.symmetric(horizontal: 10), ),),
                                ],) : ElevatedButton(onPressed: () {
                                _showDialog2(gorusme);
                              },
                                child: Text('Not Ekle'),
                                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0E47A1),  padding:EdgeInsets.symmetric(horizontal: 16), ),),
                              ),

                              DataCell(
                                  Row(
                                      children: [
                                        ElevatedButton(onPressed: (){
                                          int? selectedGorusmeId = gorusme.id;
                                          setState(() {
                                            showGorusmeYetkililer(gorusme);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                    builder:  (BuildContext context, StateSetter setState) {
                                                      return SingleChildScrollView(
                                                        child: AlertDialog(
                                                          title: Row(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(Icons.arrow_back),
                                                                onPressed: () {
                                                                  setState((){
                                                                    //Navigator.pop(context);
                                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GorusmelerPage(email: widget.email, password: widget.password, adsoyad: widget.adsoyad, id: widget.id)));
                                                                  });
                                                                },

                                                              ),
                                                            ],
                                                          ),
                                                          actions: [
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 15),
                                                                      child: Container(
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            DropdownButton(
                                                                              isExpanded: false,
                                                                              hint: Text(selectedYetkiliName.isEmpty ? "Yetkili Seç" : selectedYetkiliName),
                                                                              value: seciliYetkiliId,
                                                                              onChanged: (secilenYetkili) {
                                                                                setState(() {
                                                                                  seciliYetkiliId = int.tryParse(secilenYetkili.toString());
                                                                                  selectedYetkiliName = yetkiliList!.firstWhere((yetkili) => yetkili.id == seciliYetkiliId)?.adsoyad ?? '';
                                                                                  secilenYetkiliController.text = '$seciliYetkiliId';
                                                                                });
                                                                                print("secilen set state içi : $secilenYetkiliController");
                                                                              },
                                                                              items: yetkiliList?.map((yetkili) => DropdownMenuItem(child: Text(yetkili!.adsoyad.toString()), value: yetkili.id,)).toList(),
                                                                            ),
                                                                            SizedBox(height: 8),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(width:15 ),
                                                                    Container(
                                                                      height: 33,
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                        border: Border.all(color: Colors.grey, width: 1),
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: Center(
                                                                        child: IconButton(
                                                                          onPressed: ()  {
                                                                            void insertYetkili() async{
                                                                              // Yetkili ekleme işlemi
                                                                              gorusmeId = selectedGorusmeId;
                                                                              yetkiliIdd = seciliYetkiliId;
                                                                              yetkiliID=selectedYetkiliName.toString();

                                                                              print("insert yetkili içiii   ${gorusmeId},${yetkiliIdd},   ${yetkiliID}  ");
                                                                              final isYetkiliAdded = GorusmeYetkiliList.any((yetkili) => yetkili?.yetkiliId == yetkiliIdd && yetkili?.gorusmeId == gorusmeId);

                                                                              if (isYetkiliAdded) {
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(
                                                                                      title: Text("Hata"),
                                                                                      content: Text("Bu yetkili zaten eklenmiş."),
                                                                                      actions: [
                                                                                        ElevatedButton(
                                                                                          onPressed: () {
                                                                                            //navigotor ile pushlayıp gönderelim alert yeniden başlasın
                                                                                            setState(() {
                                                                                              Navigator.pop(context);
                                                                                            });
                                                                                          },
                                                                                          child: Text("Tamam"),
                                                                                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0E47A1)),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                );
                                                                              } else {
                                                                                final response = await http.post(Uri.parse("$url/insertgorusmeykatilim"),
                                                                                    body: {
                                                                                      "gorusmeId": gorusmeId.toString(),
                                                                                      "yetkiliId": yetkiliIdd.toString(),
                                                                                    });
                                                                                print("sbdv ${response.body}");
                                                                                if (response.statusCode == 201) {
                                                                                  setState((){
                                                                                    GorusmeYetkiliList.add(GorusmeyeKatilim(yetkiliID: yetkiliID, gorusmeId: gorusmeId,));
                                                                                    seciliYetkiliId = null;
                                                                                    selectedYetkiliName = '';
                                                                                    secilenYetkiliController.clear();
                                                                                    yetkiliList?.removeWhere((yetkili) => yetkili?.id == yetkiliIdd);
                                                                                  });
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return AlertDialog(
                                                                                        title: Text("Başarılı"),
                                                                                        content: Text("Yetkili Eklendi."),
                                                                                        actions: [
                                                                                          ElevatedButton(
                                                                                            onPressed: () {
                                                                                              setState(() {
                                                                                                Navigator.pop(context);
                                                                                              });
                                                                                            },
                                                                                            child: Text("Tamam"),
                                                                                            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0E47A1)),
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                }
                                                                              }
                                                                            }
                                                                            setState(() {
                                                                              insertYetkili();
                                                                            });
                                                                          },
                                                                          icon: Icon(Icons.add, color: Color(0xFF0E47A1)),
                                                                          iconSize: 15,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 25),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    DataTable(
                                                                      dividerThickness: 0,
                                                                      columnSpacing: 8.0,
                                                                      columns: const [
                                                                        DataColumn(label: Text("Görüşmeye Katılan" + "\nYetkililer" ) ),
                                                                        DataColumn(label: Text("")),
                                                                      ],
                                                                      rows: GorusmeYetkiliList.map((yetkili) =>
                                                                          DataRow(
                                                                            cells: [
                                                                              DataCell(Text(yetkili!.yetkiliID.toString())),
                                                                              DataCell(
                                                                                ElevatedButton(
                                                                                  // Yetkili kaldırma işlemi
                                                                                  onPressed: () async {
                                                                                    int? yetkiliId = yetkili.yetkiliId;
                                                                                    int? gorusmeId = yetkili.gorusmeId;
                                                                                    try {
                                                                                      final response = await http.delete(Uri.parse('$url/deletegorusmeyekatilan/$gorusmeId/$yetkiliId'));
                                                                                      if (response.statusCode == 201) {
                                                                                        setState(() {
                                                                                          GorusmeYetkiliList.remove(yetkili);
                                                                                        });
                                                                                        //  Navigator.of(context).pop(); // Uyarı penceresini kapatır.
                                                                                      } else {
                                                                                        showDialog(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return AlertDialog(
                                                                                              title: Text("Hata"),
                                                                                              content: Text("Yetkili silinemedi."),
                                                                                              actions: [
                                                                                                ElevatedButton(
                                                                                                  onPressed: () {
                                                                                                    setState(() {
                                                                                                      Navigator.pop(context);
                                                                                                    });
                                                                                                  },
                                                                                                  child: Text("Tamam"),
                                                                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                                                                ),
                                                                                              ],
                                                                                            );
                                                                                          },
                                                                                        );
                                                                                      }
                                                                                    } catch (e) {
                                                                                      print(e.toString());
                                                                                    }
                                                                                  },

                                                                                  child: Text("Kaldır"),
                                                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                                                                                ),

                                                                              ),
                                                                            ],
                                                                          ),
                                                                      ).toList(),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 185),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                );
                                              },
                                            );
                                          });
                                        },
                                            child: Text("Yetkililer"),
                                            style: ElevatedButton.styleFrom(fixedSize: Size(96, 29),)
                                        ),
                                        SizedBox(width: 10,)
                                      ]
                                  ),

                              ),
                            ],
                          )).toList(),
                        ),
                       // SizedBox(width: 150,)
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),

        floatingActionButton: Container(
          height: 56,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>GorusmeEkle(adsoyad: widget.adsoyad, id:widget.id, email: widget.email, password: widget.password,)));
            },
            child: Icon(Icons.add),
            backgroundColor:Color(0xFF0EF6C00),
          ),),
    );

  }
}
