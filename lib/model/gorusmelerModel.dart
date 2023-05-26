class GorusmeModel {
  List<Gorusme>? gorusmeler;

  GorusmeModel({this.gorusmeler});

  GorusmeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      gorusmeler = <Gorusme>[];
      json['data'].forEach((v) {
        gorusmeler!.add(new Gorusme.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gorusmeler != null) {
      data['data'] = this.gorusmeler!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Gorusme {
  int? id;
  String? yetkiliID;
  String? pozisyonID;
  String? adayID;
  String? isletmeID;
  String? saat;
  String? tarih;
  String? degerlendirme;

  Gorusme(
      {this.id,
        this.yetkiliID,
        this.pozisyonID,
        this.adayID,
        this.isletmeID,
        this.saat,
        this.tarih,
        this.degerlendirme});

  Gorusme.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yetkiliID = json['yetkili_ID'];
    pozisyonID = json['pozisyon_ID'];
    adayID = json['aday_ID'];
    isletmeID = json['isletmeID'];
    saat = json['saat'];
    tarih = json['tarih'];
    degerlendirme = json['degerlendirme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yetkili_ID'] = this.yetkiliID;
    data['pozisyon_ID'] = this.pozisyonID;
    data['aday_ID'] = this.adayID;
    data['isletmeID'] = this.isletmeID;
    data['saat'] = this.saat;
    data['tarih'] = this.tarih;
    data['degerlendirme'] = this.degerlendirme;
    return data;
  }
}