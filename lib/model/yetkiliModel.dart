class YetkiliModel {

  List<Yetkili>? yetkili;

  YetkiliModel({this.yetkili});

  YetkiliModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      yetkili = <Yetkili>[];
      json['data'].forEach((v) {
        yetkili!.add(new Yetkili.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.yetkili != null) {
      data['data'] = this.yetkili!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Yetkili {
  int? id;
  String? adsoyad;
  String? email;
  String? password;
  String? unvan;
  int? gsm;
  bool? superyetkili;

  Yetkili(
      {
        this.id,
        this.adsoyad,
        this.email,
        this.password,
        this.unvan,
        this.gsm,
        this.superyetkili
      });

  Yetkili.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adsoyad = json['adsoyad'];
    email = json['email'];
    password = json['password'];
    unvan = json['unvan'];
    gsm = json['gsm'];
    superyetkili = json['superyetkili'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['adsoyad'] = this.adsoyad;
    data['email'] = this.email;
    data['password'] = this.password;
    data['unvan'] = this.unvan;
    data['gsm'] = this.gsm;
    data['superyetkili'] = this.superyetkili;
    return data;
  }
}