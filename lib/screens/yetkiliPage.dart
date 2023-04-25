import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sds_is_platformu/screens/homePage.dart';
import 'package:sds_is_platformu/screens/insertYetkili.dart';
import '../const/sabitler.dart';
import '../model/yetkiliModel.dart' show Yetkili, YetkiliModel;


class YetkiliPage extends StatefulWidget {
  final String email;
  final String password;
  const YetkiliPage({Key? key, required this.email, required this.password,}) : super(key: key);

  @override
  State<YetkiliPage> createState() => _YetkiliPageState();
}

class _YetkiliPageState extends State<YetkiliPage> {
  YetkiliModel? yetkiliModel;
  List<Yetkili?> yetkilisList = [];
  List<Yetkili?> filteredYetkilisList = [];
  final searchController = TextEditingController();
  TextEditingController unvanController =TextEditingController();
  String url = apiUrl;


  @override
  void initState() {
    super.initState();
    yetkili();
  }

  Future<void> yetkili() async {
    final response =
    await http.get(Uri.parse("$url/yetkili"));
    if (response.statusCode == 200) {
      print(response.body);
    }
    setState(() {
      yetkiliModel = YetkiliModel.fromJson(jsonDecode(response.body));
      yetkilisList = yetkiliModel!.yetkili!;
      filteredYetkilisList = yetkilisList;
    });
  }

  void filterYetkili(String query) {
    setState(() {
      filteredYetkilisList = yetkilisList
          .where((yetkili) => yetkili!.adsoyad!.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context){
     return Scaffold(
       appBar: AppBar(
         title: Text('Yetkililer'),
         centerTitle: true,
         backgroundColor: Colors.brown,
         leading: IconButton(
           icon: Icon(Icons.arrow_back),
           onPressed: (){
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage(email: widget.email, password: widget.password,)));
           },
         ),
       ),
       body: SingleChildScrollView(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(
                 children: [
                   Container(
                     width:MediaQuery.of(context).size.width * 0.8,
                     decoration: BoxDecoration(
                       boxShadow: [
                         BoxShadow(
                           color: Colors.grey.withOpacity(0.5),
                           blurRadius: 15,
                           offset: Offset(0,2),
                         )
                       ]
                     ),
                     child: TextFormField(
                         controller: searchController,
                         decoration: InputDecoration(
                           filled: true,
                           fillColor: Colors.white,
                           hintText: 'Ara...',
                           prefixIcon: Icon(Icons.search),
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(15),
                             borderSide: BorderSide(
                               color: Colors.red,
                             )
                           ),
                         ),
                         onChanged: (value) {
                           filterYetkili(value);
                         },
                       ),
                   ),
                   SizedBox(width: 10,),

                   Container(
                     width: 55,
                     height: 60,
                       decoration: BoxDecoration(
                         color: Colors.white,
                         border: Border.all(color: Colors.grey,width: 1),
                         borderRadius: BorderRadius.circular(13)
                       ),
                       child: IconButton(
                         icon: Icon( Icons.add,color: Colors.brown,),
                         iconSize: 40,
                         onPressed: () {
                           bool superyetkili=false;
                           for (var i = 0; i < yetkilisList.length; i++) {
                             if (yetkilisList[i]?.superyetkili == true) {
                               superyetkili = true;
                               break;
                             }
                           }
                           //kullanıcı süper yetkiliyse yetkili ekleyebilsin
                           if(superyetkili){
                             Navigator.pushReplacement(context, MaterialPageRoute(
                                 builder: (context) => InsertYetkili(email: widget.email, password: widget.password,),));
                           }
                           else{
                             showDialog(context: context, builder: (BuildContext context){
                               return AlertDialog(
                                 content: Text("Yetkiniz bulunmamaktadır"),
                                 actions: [
                                   ElevatedButton(onPressed: (){
                                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>YetkiliPage(email: widget.email, password: widget.password,)));
                                   }, child: Text("Tamam"))
                                 ],
                               );
                             });
                           }
                         },
                         color: Colors.grey.shade500,
                       ),
                   ),
                 ],
               ),
             ),
             SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: DataTable(
                 columns: const [
                   DataColumn(label: Text('Ad Soyad')),
                   DataColumn(label: Text('Unvan ')),
                   DataColumn(label: Text('E-Posta')),
                   DataColumn(label: Text('Gsm')),
                 ],

                 rows: filteredYetkilisList.map((yetkili) => DataRow(
                   cells: [
                     DataCell(Text(yetkili!.adsoyad!)),
                     DataCell(Text(yetkili.unvan!)),
                     DataCell(Text(yetkili.email!)),
                     DataCell(Text(yetkili.gsm!.toString())),
                   ],

                   onLongPress: (){
                     int? id=yetkili.id;
                     showDialog(context: context, builder: (BuildContext context){
                       return AlertDialog(
                         title: Text("Yapmak istediğiniz işlemi seçin"),
                         content: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             SizedBox(
                               height:40,
                               width:MediaQuery.of(context).size.width * 0.8,
                                 child: ElevatedButton(onPressed: (){
                                   showDialog(context: context, builder: (context){
                                    return AlertDialog(
                                       title: Text("Unvan Giriniz"),
                                       content: TextField(
                                         controller: unvanController,
                                         decoration: InputDecoration(
                                             labelText: "Unvan"
                                         ),
                                       ),
                                       actions: [
                                         ElevatedButton(onPressed: (){
                                           void editYetkili() async{
                                             final response=await http.post(Uri.parse("$url/edit/$id"),
                                                 body: {
                                                   'unvan':unvanController.text,
                                                 });
                                             if(response.statusCode==201){
                                               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>YetkiliPage(email: widget.email, password: widget.password,)));
                                             }
                                           }
                                           setState(() {
                                             editYetkili();
                                           });
                                         },
                                           child: Text("Tamam"),
                                           style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[400])),
                                         ),
                                         ElevatedButton(onPressed: (){
                                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>YetkiliPage(email: widget.email, password: widget.password,)));
                                         }, child: Text("İptal"),
                                           style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[400])),
                                         )
                                       ],
                                     );
                                   });
                                 },
                                   child: Text("Düzenle"),
                                   style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),)),
                             SizedBox(height: 10,),
                             SizedBox( height:40,
                                 width:MediaQuery.of(context).size.width * 0.8,
                                 child: ElevatedButton(onPressed: (){
                                   void deleteYetkili() async{
                                     final response=await http.delete(Uri.parse("$url/delete/$id"));
                                     if(response.statusCode==201){
                                       print(response.body);
                                     }
                                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>YetkiliPage(email: widget.email, password: widget.password,)));
                                   }
                                   setState(() {
                                     deleteYetkili();
                                   });
                                 },
                                   child: Text("Sil"),
                                   style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),)),
                           ],
                         )
                       );
                     });
                   }
                 )).toList(),

               ),
             ),
           ],
         ),
       ),
     );
  }
}
