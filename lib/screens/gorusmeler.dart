import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sds_is_platformu/model/gorusmelerModel.dart';
import '../const/sabitler.dart';
import 'package:http/http.dart' as http;

class GorusmelerPage extends StatefulWidget {
  final String email;
  final String password;

  const GorusmelerPage({Key? key, required this.email, required this.password}) : super(key: key);

  @override
  State<GorusmelerPage> createState() => _GorusmelerPageState();
}
class _GorusmelerPageState extends State<GorusmelerPage> {

  GorusmeModel? gorusmeModel;
  List<Gorusme?> gorusmeList = [];
  List<Gorusme?> filteredGorusmeList = [];

  TextEditingController notCont = TextEditingController();
  final searchYetkiliController = TextEditingController();
  final searchIsletmeController = TextEditingController();
  final searchAdayController = TextEditingController();
  final searchPozisyonController = TextEditingController();
  //final searchDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    gorusmeler();
  }
  String url = apiUrl;
  DateTime? selectedBaslangic;
  DateTime? selectedBitis;

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
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width:MediaQuery.of(context).size.width * 0.45,
                    height: 40,
                    child: TextFormField(
                      controller: searchYetkiliController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Yetkili Ara',hintStyle: TextStyle(color: Colors.grey,),contentPadding: EdgeInsets.symmetric(vertical: 8.0, ),
                        prefixIcon:Icon(Icons.search,size: 20,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        filterGorusmeYetkili(value);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width:MediaQuery.of(context).size.width * 0.45,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'İşletme Ara', hintStyle: TextStyle(color: Colors.grey,),contentPadding: EdgeInsets.symmetric(vertical: 8.0,),
                        prefixIcon:Icon(Icons.search,size: 20,),
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
                    width:MediaQuery.of(context).size.width * 0.45,
                    height: 40,
                    child: TextFormField(
                      controller: searchAdayController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Aday Ara', hintStyle: TextStyle(color: Colors.grey,),contentPadding: EdgeInsets.symmetric(vertical: 8.0, ),
                        prefixIcon:Icon(Icons.search,size: 20,),
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
                      width:MediaQuery.of(context).size.width * 0.48,
                      height: 40,
                      child: TextFormField(
                        controller: searchPozisyonController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Pozisyon Ara', hintStyle: TextStyle(color: Colors.grey,),contentPadding: EdgeInsets.symmetric(vertical: 8.0, ),
                          prefixIcon:Icon(Icons.search,size: 20,),
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
                ElevatedButton(
                  onPressed: (){
                    showBaslangicDatePicker();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Başlangıç Tarihi'),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: (){
                    showBitisDatePicker();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Bitiş Tarihi'),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Yetkili')),
                  DataColumn(label: Text('İşletme')),
                  DataColumn(label: Text('Aday ')),
                  DataColumn(label: Text('Pozisyon')),
                  DataColumn(label: Text('Tarih ')),
                  DataColumn(label: Text('Saat')),
                  DataColumn(label: Text('Değerlendirme')),
                ],
                rows: filteredGorusmeList.map((gorusme) => DataRow(
                  cells: [
                    DataCell(Text(gorusme!.yetkiliID!)),
                    DataCell(Text(gorusme!.isletmeID!.split(" ").take(2).join( " "))), // 2 kelimesini alır sadece
                    DataCell(Text(gorusme.adayID!)),
                    DataCell(Text(gorusme.pozisyonID!)),
                    DataCell(GestureDetector(
                      child: Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(gorusme.tarih.toString()))),
                    ),),
                    DataCell(Text(DateFormat('HH:mm').format(DateTime.parse(gorusme.saat!.toString())))),
                    DataCell(
                      GestureDetector(
                        child: gorusme.degerlendirme != null ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(gorusme.degerlendirme!),
                          SizedBox(width: 15,),
                          ElevatedButton(onPressed: (){
                               _showDialog(gorusme);
                          },
                            child: Text('Not Düzenle '),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow.shade800),)
                        ],) : ElevatedButton(onPressed: () {}, child: Text('Not Ekle')),
                      ),
                    ),
                  ],
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
