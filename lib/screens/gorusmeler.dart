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
  final searchDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    gorusmeler();
  }
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
                        filterGorusmeYetkili(value);
                      },
                    ),
                  ),
                ),
                TextFormField(
                  controller: searchDateController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Tarihleri Seçin',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )

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
