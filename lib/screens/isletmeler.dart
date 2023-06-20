import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sds_is_platformu/const/sabitler.dart';
import 'package:http/http.dart' as http;
import 'package:sds_is_platformu/model/isletmelerModel.dart';
import 'homePage.dart';

class IsletmelerPage extends StatefulWidget {
  final String email;
  final String password;
  final String adsoyad;
  final int id;
  const IsletmelerPage({Key? key, required this.email,required this.password, required this.adsoyad, required this.id}) : super(key: key);

  @override
  State<IsletmelerPage> createState() => _IsletmelerPageState();
}

class _IsletmelerPageState extends State<IsletmelerPage> {
  IsletmeModel? isletmeModel;
  List<Isletme?> isletmeList = [];
  String url = apiUrl;

  TextEditingController unvanController = TextEditingController();
  TextEditingController unvanCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    isletmeler();
  }

  Future<void> isletmeler() async {
    final response = await http.get(Uri.parse("$url/isletmeler"));
    if (response.statusCode == 200) {
      print(response.body);

      setState(() {
        isletmeModel = IsletmeModel.fromJson(jsonDecode(response.body));
        isletmeList = isletmeModel!.isletme!;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("İşletmeler"),
          centerTitle: true,
          backgroundColor:Color(0xFF0E47A1),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage( email: widget.email, password: widget.password, adsoyad: widget.adsoyad, id: widget.id,)));
            },
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('id')),
              DataColumn(label: Text('Unvan ')),
            ],
            rows: isletmeList.map((isletme) => DataRow(
                        cells: [
                          DataCell(Text(isletme!.id.toString())),
                          DataCell(Text(isletme!.unvan!)),
                        ],
                        onLongPress: () {
                          int? id = isletme.id;
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text("Yapmak istediğiniz işlemi seçin"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: 40,width: MediaQuery.of(context).size.width * 0.8,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                showDialog( context: context,builder: (context) {
                                                      return AlertDialog(
                                                        title: Text("Bilgileri Değiştirin"),
                                                        content: Column(
                                                          mainAxisSize:MainAxisSize.min,
                                                          children: [
                                                            TextField(
                                                              controller:unvanController,
                                                              decoration: InputDecoration(
                                                                  labelText: "Unvan",
                                                                  border: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular( 5))),),
                                                            SizedBox( height: 10,),
                                                          ],
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              void editYetkili() async {
                                                                final response =await http.post(Uri.parse("$url/isletmeedit/$id"),
                                                                        body: {
                                                                            'unvan':unvanController.text,
                                                                      //'password':passwordController.text,
                                                                    });
                                                                if (response .statusCode ==201) {
                                                                  Navigator.push(context,
                                                                      MaterialPageRoute(builder: (context) => IsletmelerPage(email: widget.email,password: widget.password,adsoyad: widget.adsoyad,id: widget.id,)));
                                                                }
                                                              }
                                                              setState(() {
                                                                editYetkili();
                                                              });
                                                            },
                                                            child:Text("Tamam"),
                                                            style: ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.grey[400])),
                                                          ),
                                                          ElevatedButton(onPressed: () { Navigator.push( context,MaterialPageRoute(builder: (context) => IsletmelerPage( email: widget.email,password:widget.password,adsoyad:widget.adsoyad,id: widget.id,)));
                                                            },
                                                            child: Text("İptal"),style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty.all( Colors.grey[400])),
                                                          )
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Text("Düzenle"),
                                              style: ElevatedButton.styleFrom(backgroundColor:Colors.brown),
                                            )),
                                        SizedBox(height: 10, ),
                                        SizedBox( height: 40,width: MediaQuery.of(context).size.width * 0.8,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                void deleteIsletme() async {
                                                  final response = await http.delete(Uri.parse("$url/deleteisletme/$id"));
                                                  if (response.statusCode == 201) {
                                                    print(response.body);
                                                  }
                                                  Navigator.push(context,MaterialPageRoute(builder: (context) =>IsletmelerPage( email: widget.email,password: widget .password, adsoyad: widget.adsoyad,id: widget.id,)));
                                                }
                                                setState(() {
                                                  deleteIsletme();
                                                });
                                              },
                                              child: Text("Sil"),
                                              style: ElevatedButton.styleFrom( backgroundColor:Colors.brown),)),
                                      ],
                                    ));
                              });
                        }))
                .toList(),
          ),
        ),
        floatingActionButton: Container(
          height: 56,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('İşletme Ekle',),
                      content: Column(
                        mainAxisSize:MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: unvanCont,
                            decoration: InputDecoration(
                                labelText: "Unvan",
                                border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                            )),
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            void insertIsletme() async {
                              final response =await http.post(Uri.parse("$url/insertisletme"),
                                  body: {
                                    'unvan':unvanCont.text,
                                    //'password':passwordController.text,
                                  });
                              if (response .statusCode ==201) {
                                print('asjdgaj: ${unvanCont.text}');
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => IsletmelerPage(email: widget.email,password: widget.password,adsoyad: widget.adsoyad,id: widget.id,)));
                              }
                            }
                            setState(() {
                              insertIsletme();
                            });
                          },
                          child:Text("Tamam"),
                          style: ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.grey[400])),
                        ),
                        ElevatedButton(onPressed: () { Navigator.push( context,MaterialPageRoute(builder: (context) => IsletmelerPage( email: widget.email,password:widget.password,adsoyad:widget.adsoyad,id: widget.id,)));
                        },
                          child: Text("İptal"),style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all( Colors.grey[400])),
                        )
                      ],
                    );
                  });
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xFF0EF6C00),

          ),
        ));
  }
}
