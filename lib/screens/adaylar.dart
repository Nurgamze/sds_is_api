import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sds_is_platformu/model/adaylarModel.dart';
import 'package:sds_is_platformu/screens/adayDetay.dart';
import 'package:sds_is_platformu/screens/editAday.dart';
import '../const/sabitler.dart';
import 'package:http_parser/http_parser.dart';
import 'homePage.dart';
import 'insertAday.dart';


class AdaylarPage extends StatefulWidget {
  final String email;
  final String password;
  final String adsoyad;
  final int id;
  const AdaylarPage({Key? key, required this.email, required this.password, required this.adsoyad, required this.id,}) : super(key: key);

  @override
  State<AdaylarPage> createState() => _AdaylarPageState();
}

class _AdaylarPageState extends State<AdaylarPage> {

  AdayModel? adayModel;
  List<Aday?> adayList=[];
  String url = apiUrl;


  Future<void> adaylar() async{
    final response=await http.get(Uri.parse("$url/adaylar"));
    if(response.statusCode==200){
      print(response.body);

      setState(() {
        adayModel = AdayModel.fromJson(jsonDecode(response.body));
        adayList  = adayModel!.aday!;
        print(adayModel);
      });
    }}

  Future<void> uploadPdf(int adayId, String ad, String soyad) async {
    var dio = Dio(BaseOptions(receiveTimeout: Duration(seconds: 5)));

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String filePath = result.files.single.path ?? '';
      File file = File(filePath);
      print(file);
      String modifiedFileName = '$adayId-${ad}_${soyad}CV.pdf';

      FormData data = FormData.fromMap({
        'pdf': await MultipartFile.fromFile(
          file.path,
          filename: modifiedFileName,
          contentType: MediaType('application', 'pdf'),
        ),
        'adayId': adayId,
      });
      try {
        await dio.post('$apiUrl/upload',
          data: data,
          onSendProgress: (int sent, int total) {
            print('$sent / $total');
          },
        );
        print('Dosya başarıyla yüklendi.');
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            title: Text('Dosya Yükleme Başarılı '),
            actions: [
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AdaylarPage(email: widget.email, password: widget.password, adsoyad: widget.adsoyad, id: widget.id,)));
              }, child: Text('Tamam'))
            ],
          );
        });
      } catch (e) {
        print('API isteği sırasında bir hata oluştu: $e');
      }
    } else {
      print('Boş sonuç');
    }
  }


  @override
  void initState() {
    super.initState();
    adaylar();}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Adaylar"),
          centerTitle: true,
          backgroundColor:Color(0xFF0E47A1),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(email: widget.email, password: widget.password, adsoyad: widget.adsoyad, id: widget.id,)));
            },),),
        body:  ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (BuildContext context,int index) {
              return DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.transparent),
                  columns: const [
                    DataColumn(label: Text('Ad')),
                    DataColumn(label: Text('Soyad')),
                    DataColumn(label: Text('Mezuniyet ')),
                    DataColumn(label: Text('Toplam Deneyim ')),
                    DataColumn(label: Text('Yas')),],
                  rows: adayList.map((aday) => DataRow(
                      cells: [
                        DataCell(Text(aday!.ad!)),
                        DataCell(Text(aday!.soyad!)),
                        DataCell(Text(aday!.mezuniyet!)),
                        DataCell(Text("${aday!.toplamDeneyim.toString()} yıl")),
                        DataCell(Text(aday!.yas.toString())),],
                      onSelectChanged: (isSelected) {
                        if (isSelected != null && isSelected) {
                          Navigator.push( context,MaterialPageRoute(builder: (context) => AdayDetayPage(aday: aday)),);}
                      }, onLongPress: (){
                        int? id=aday.id;
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Yapmak istediğiniz işlemi seçin"),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.8,

                                  child: ElevatedButton(onPressed: (){
                                    setState(() {
                                      uploadPdf(aday.id!,aday.ad!,aday.soyad!);
                                    });

                                  },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text("CV Yükle"),
                                    ),style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0E47A1),),),
                                ),),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.8,
                                  child: ElevatedButton(onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditAday(email: widget.email, password: widget.password, adsoyad: widget.adsoyad, id: widget.id,aday: aday,)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text("Düzenle"),
                                    ),style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0E47A1),),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.8,
                                  child: ElevatedButton(onPressed: (){
                                    void deleteAday() async {
                                      final response=await http.delete(Uri.parse("$url/deleteaday/$id"));
                                      if(response.statusCode==201){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AdaylarPage(email: widget.email, password: widget.password, adsoyad: widget.adsoyad, id: widget.id)));}}
                                    setState(() {
                                      deleteAday();
                                    });},
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text("Sil"),
                                      ),style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0E47A1),),)
                                ),
                              ),],);});
                      }
                  )).toList(),
              );
            }
        ),
        floatingActionButton: Container(
          height: 56,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AdayEkle(email: widget.email, password: widget.password, adsoyad: widget.adsoyad, id: widget.id,)));
            },
            child: Icon(Icons.add),
            backgroundColor:Color(0xFF0EF6C00),
          ),)
    );
  }

}

