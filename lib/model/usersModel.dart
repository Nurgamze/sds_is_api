class UsersModel {
  List<User>? data;

  UsersModel({this.data});

  UsersModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <User>[];
      json['data'].forEach((v) {
        data!.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class User {
  int? id;
  String? adsoyad;
  String? email;
  String? password;
  bool? approved;

  User({this.id, this.adsoyad, this.email, this.password,this.approved});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adsoyad = json['adsoyad'];
    email = json['email'];
    password = json['password'];
    approved = json['approved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['adsoyad'] = this.adsoyad;
    data['email'] = this.email;
    data['password'] = this.password;
    data['approved'] = this.approved;
    return data;
  }
}