import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sds_is_platformu/model/gorusmelerModel.dart';
import '../const/sabitler.dart';
import 'package:http/http.dart' as http;

import '../model/yetkiliModel.dart';

class GorusmelerPage extends StatefulWidget {
  final String email;
  final String password;

  const GorusmelerPage({Key? key, required this.email, required this.password}) : super(key: key);

  @override
  State<GorusmelerPage> createState() => _GorusmelerPageState();
}

class _GorusmelerPageState extends State<GorusmelerPage> {

  YetkiliModel? yetkiliModel;
  List<Yetkili?> yetkilisList = [];
  List<Yetkili?> filteredYetkilisList = [];
  List<Gorusme?> filteredGorusmeList = [];

  TextEditingController notCont = TextEditingController();
  TextEditingController searchYetkiliController = TextEditingController();
  TextEditingController searchIsletmeController = TextEditingController();
  TextEditingController searchAdayController = TextEditingController();
  TextEditingController searchPozisyonController = TextEditingController();

  GorusmeModel? gorusmeModel;
  List<Gorusme?> gorusmeList = [];
  String url = apiUrl;


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
  void filterYetkili(String query) {
    setState(() {
      filteredGorusmeList = gorusmeList
          .where((yetkili) => yetkili!.degerlendirme!.toLowerCase().contains(query.toLowerCase())).toList();
    });
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
  void initState() {
    super.initState();
    gorusmeler();

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width:MediaQuery.of(context).size.width * 0.2,
                    height: 40,
                    child: TextFormField(
                      controller: searchYetkiliController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Yetkili Ara',
                        prefixIcon:Icon(Icons.search,size: 20,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        filterYetkili(value);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width:MediaQuery.of(context).size.width * 0.2,
                    height: 40,
                    child: TextFormField(
                      controller: searchIsletmeController,
                      decoration: InputDecoration(
                         filled: true,
                        fillColor: Colors.white,
                        hintText: 'İşletme Ara',
                        prefixIcon:Icon(Icons.search,size: 20,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        //filterYetkili(value);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width:MediaQuery.of(context).size.width * 0.2,
                    height: 40,
                    child: TextFormField(
                      controller: searchAdayController,
                      decoration: InputDecoration(
                         filled: true,
                        fillColor: Colors.white,
                        hintText: 'Aday Ara',
                        prefixIcon:Icon(Icons.search,size: 20,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        //filterYetkili(value);
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width:MediaQuery.of(context).size.width * 0.2,
                    height: 40,
                    child: TextFormField(
                      controller: searchPozisyonController,
                      decoration: InputDecoration(
                         filled: true,
                        fillColor: Colors.white,
                        hintText: 'Pozisyon Ara',
                        prefixIcon:Icon(Icons.search,size: 20,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        //filterYetkili(value);
                      },
                    ),
                  ),
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
                rows: gorusmeList.map((gorusme) => DataRow(
                  cells: [
                    DataCell(Text(gorusme!.yetkiliID!)),
                    DataCell(Text(gorusme!.isletmeID!.split(" ").take(2).join( " "))), // 2 kelimesini alır sadece
                    DataCell(Text(gorusme.adayID!)),
                    DataCell(Text(gorusme.pozisyonID!)),
                    DataCell(Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(gorusme.tarih.toString())))),
                    DataCell(Text(DateFormat('HH:mm').format(DateTime.parse(gorusme.saat!.toString())))),
                    DataCell(
                      GestureDetector(
                        child: gorusme.degerlendirme != null ? Text(gorusme.degerlendirme!) : ElevatedButton(onPressed: () {}, child: Text('Not Ekle')),
                        onLongPress: () {
                          _showDialog(gorusme);
                        },
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
