class PositionModel {
  List<Data>? data;

  PositionModel({this.data});

  PositionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  int? yetkiliId;
  int? isletmeId;
  String? yetkili;
  String? isletme;
  String? unvan;
  int? deneyimYili;
  bool? seyehatEngeli;
  int? maxYas;
  int? minYas;
  String? cinsiyet;
  String? sehir;
  String? bolge;
  bool? askerlik;
  bool? ehliyet;
  String? mezuniyet;
  String? yetkiliAdsoyad;

  Data(
      {
        this.id,
        this.yetkiliId,
        this.yetkili,
        this.isletme,
        this.isletmeId,
        this.unvan,
        this.deneyimYili,
        this.seyehatEngeli,
        this.maxYas,
        this.minYas,
        this.cinsiyet,
        this.sehir,
        this.bolge,
        this.askerlik,
        this.ehliyet,
        this.mezuniyet,
        this.yetkiliAdsoyad
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yetkiliId = json['yetkiliId'];
    yetkili = json['yetkili'];
    isletmeId = json['isletmeId'];
    isletme = json['isletme'];
    unvan = json['unvan'];
    deneyimYili = json['deneyim_yili'];
    seyehatEngeli = json['seyehat_engeli'];
    maxYas = json['max_yas'];
    minYas = json['min_yas'];
    cinsiyet = json['cinsiyet'];
    sehir = json['sehir'];
    bolge = json['bolge'];
    askerlik = json['askerlik'];
    ehliyet = json['ehliyet'];
    mezuniyet = json['mezuniyet'];
    yetkiliAdsoyad = json['yetkiliAdsoyad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yetkiliId'] = this.yetkiliId;
    data['yetkili'] = this.yetkili;
    data['isletme'] = this.isletme;
    data['isletmeId'] = this.isletmeId;
    data['unvan'] = this.unvan;
    data['deneyim_yili'] = this.deneyimYili;
    data['seyehat_engeli'] = this.seyehatEngeli;
    data['max_yas'] = this.maxYas;
    data['min_yas'] = this.minYas;
    data['cinsiyet'] = this.cinsiyet;
    data['sehir'] = this.sehir;
    data['bolge'] = this.bolge;
    data['askerlik'] = this.askerlik;
    data['ehliyet'] = this.ehliyet;
    data['mezuniyet'] = this.mezuniyet;
    data['yetkiliAdsoyad'] = this.yetkiliAdsoyad;
    return data;
  }
}