import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sds_is_platformu/const/sabitler.dart';
import '../model/usersModel.dart';
import 'homePage.dart';
import 'package:http/http.dart'as http;


class KullanicilarPage extends StatefulWidget {

  final String email;
  final String password;

   KullanicilarPage ({Key? key, required this.email, required this.password}) : super(key: key);

  @override
  State<KullanicilarPage> createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {


  UsersModel? usersModel;
  List<User?> userList = [];
  String url = apiUrl;


  @override
  void initState() {
    users();
    super.initState();
  }

  Future<void> users() async{
    final response = await http.get(Uri.parse("$url/users"));
    if(response.statusCode==200){
      print(response.body);
    }
    setState(() {
      usersModel=UsersModel.fromJson(jsonDecode(response.body));
      userList=usersModel!.data!;
    });
  }

  Future<void> approveUser(User user) async {
    final response = await http.post( Uri.parse("$url/users/${user.id}"),
      body: {
         'approved':'True',
      },
    );
    print("listile idsi ${user.id}");
    if (response.statusCode == 200) {
      print("Kullanıcı onaylandı: ${response.body}");
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text("Başarılı"),
          content: Text("Kullanıcı onaylandı"),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>KullanicilarPage(email: widget.email, password: widget.password)));
            }, child: Text("Tamam"),style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade400))
          ],
        );
      });
    }else{
      print("Kullanıcı onaylanırken bir hata oluştuuu.: ${response.body}");
      return;
    }
    setState(() {});
  }

  Future<void> passiveUser(User user) async{
    final response= await http.post(Uri.parse("$url/users/${user.id}"),
    body: {
      'approved':'False',
    });
    if (response.statusCode == 200) {
      print("Kullanıcı pasife alındı: ${response.body}");
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text("Başarılı"),
          content: Text("Kullanıcı pasife alındı"),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>KullanicilarPage(email: widget.email, password: widget.password)));
            }, child: Text("Tamam"),style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade400))
          ],
        );
      });
    }else{
      print("Kullanıcı pasife alınırken bir hata oluştuuu.: ${response.body}");
      return;
    }
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcılar"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(email: widget.email, password: widget.password,)));
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            final user = userList[index];
            return ListTile(
              title: Text(user!.adsoyad.toString()),
              subtitle: Text(user!.email.toString()),
            trailing: Row(
             // mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                user.approved != true ? ElevatedButton(
                 onPressed: (){
                   approveUser(user);
                 },
                child: Text("Onayla")):
                SizedBox(width: 10,),
                ElevatedButton(
                    onPressed: (){
                      passiveUser(user);
                    },
                  child: Text("Pasif"),style: ElevatedButton.styleFrom(backgroundColor: Colors.red),)
              ],
            ),
            );
          },
        ),
      ),
    );
  }
}
