import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../const/sabitler.dart';
import '../model/usersModel.dart';
import '../model/yetkiliModel.dart';
import 'homePage.dart';

class KullanicilarPage extends StatefulWidget {
  final String email;
  final String password;
  final String adsoyad;
  final int id;

  KullanicilarPage({Key? key, required this.email, required this.password, required this.adsoyad, required this.id,}) : super(key: key);

  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  UsersModel usersModel = UsersModel();
  bool isLoading = true;
  String url = apiUrl;

  late YetkiliModel yetkiliModel;
  bool isAuthorized = false;


  @override
  void initState() {
    super.initState();
    users();
    fetchAuthorization();
  }


  Future<void> users() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('$url/users'));
    if (response.statusCode == 200) {
      setState(() {
        usersModel = UsersModel.fromJson(jsonDecode(response.body));
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> activity(User user, bool status) async {
    if (!isAuthorized) return;
    print('istek gitti');

    final response = await http.post(Uri.parse('$url/users/${user.id}'),
      body: {
        'isActive': status ? "true" : "false",
      },
    );
    if (response.statusCode == 200) {
      print('200 döndü');
      print(user.id);

      setState(() {
        user.isActive = status;
        print('status: $status');
      });

      // update the user's isActive status in the local list
      final int userIndex = usersModel.data!.indexWhere((u) => u.id == user.id);
      if (userIndex != -1) {
        setState(() {
          usersModel.data![userIndex].isActive = status;
        });
      }
      print("isactive değeri değiştirildi $userIndex. indexdeki kullanıcı , db id si ${user.id} olan  $status edildi");
      String message= ('${user.adsoyad} kullanıcısı ${status ? 'aktif' : 'pasif'} hale getirildi.');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: [
              TextButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

    } else {
      print('hata oluştu'); // log an error message if failed
    }
  }

  Future<void> fetchAuthorization() async {
    final response = await http.get(Uri.parse('$url/yetkili'));
    if (response.statusCode == 200) {
      setState(() {
        yetkiliModel = YetkiliModel.fromJson(jsonDecode(response.body));
        isAuthorized = yetkiliModel.yetkili!.any((y) => y.email == widget.email);
      });
    } else {
      throw Exception('Yetkilendirme hatası');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcılar'),
        centerTitle: true,
        backgroundColor: Color(0xFF0E47A1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  email: widget.email,
                  password: widget.password,
                  adsoyad: widget.adsoyad,
                  id: widget.id,
                ),
              ),
            );
          },
        ),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: usersModel.data?.length,
        itemBuilder: (context, index) {
          final user = usersModel.data?[index];
          return SwitchListTile(
            title: Text(user?.adsoyad ?? ''),
            subtitle: Text(user?.email ?? ''),
            value: user?.isActive ?? false,
            onChanged: isAuthorized ? (bool value) => activity(user!, value) : null,
            activeColor: Colors.green,
            inactiveThumbColor: Colors.grey,
          );
        },
      ),
    );
  }
}
