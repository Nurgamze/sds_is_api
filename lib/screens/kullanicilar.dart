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


  Future<void> fetchAuthorization() async {
    final response = await http.get(Uri.parse('$url/yetkili'));
    if (response.statusCode == 200) {
      setState(() {
        yetkiliModel = YetkiliModel.fromJson(jsonDecode(response.body));
        isAuthorized = yetkiliModel.yetkili!.any((yetkili) => yetkili.email == widget.email);
      });
    } else {
      throw Exception('Yetkilendirme hatası');
    }
  }

  Future<void> updateUserStatus(User? user, bool isActive) async {
    // Check if the user object and authorization information are available
    if (user == null || !isAuthorized) {
      return;
    }

    final userId = user.id; // Assuming there is an 'id' property in the User model
    print("${userId}   useridli kişi ");
    // Perform the API request to update the user's status
    final response = await http.put(Uri.parse('$url/users/$userId'), body: {
      'isActive': isActive.toString(),
    });

    if (response.statusCode == 200) {

      setState(() {
        user.isActive = isActive;
      });
    } else {
      throw Exception('Failed to update user status');
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
          return ListTile(
            title: Text(user?.adsoyad ?? ''),
            trailing: Switch(
              value: user?.isActive ?? false,
              onChanged: isAuthorized ? (bool value) => updateUserStatus(user, value) : null,
              activeColor: Colors.green,
              inactiveThumbColor: Colors.grey,

            ),
          );
        },
      ),
    );
  }
}
