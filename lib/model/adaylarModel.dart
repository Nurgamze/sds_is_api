class AdayModel {
  List<Aday>? aday;

  AdayModel({this.aday});


  AdayModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      aday = <Aday>[];
      json['data'].forEach((v) {
        aday!.add(new Aday.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aday != null) {
      data['data'] = this.aday!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Aday {
  int? id;
  String? ad;
  String? soyad;
  int? gsm;
  String? email;
  String? cvUrl;
  String? cinsiyet;
  int? yas;
  String? dogumTarihi;
  bool? askerlik;
  bool? ehliyet;
  String? mezuniyet;
  String? yasadigiSehir;
  String? dogduguSehir;
  bool? sigara;
  bool? alkol;
  bool? evlilik;
  int? cocukSayisi;
  int? toplamDeneyim;
  String? sonIsyeri;
  String? sonIsyeriSuresi;

  Aday(
      {this.id,
        this.ad,
        this.soyad,
        this.gsm,
        this.email,
        this.cvUrl,
        this.cinsiyet,
        this.yas,
        this.dogumTarihi,
        this.askerlik,
        this.ehliyet,
        this.mezuniyet,
        this.yasadigiSehir,
        this.dogduguSehir,
        this.sigara,
        this.alkol,
        this.evlilik,
        this.cocukSayisi,
        this.toplamDeneyim,
        this.sonIsyeri,
        this.sonIsyeriSuresi});

  Aday.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ad = json['ad'];
    soyad = json['soyad'];
    gsm = json['gsm'];
    email = json['email'];
    cvUrl = json['cv_url'];
    cinsiyet = json['cinsiyet'];
    yas = json['yas'];
    dogumTarihi = json['dogum_tarihi'];
    askerlik = json['askerlik'];
    ehliyet = json['ehliyet'];
    mezuniyet = json['mezuniyet'];
    yasadigiSehir = json['yasadigi_sehir'];
    dogduguSehir = json['dogdugu_sehir'];
    sigara = json['sigara'];
    alkol = json['alkol'];
    evlilik = json['evlilik'];
    cocukSayisi = json['cocuk_sayisi'];
    toplamDeneyim = json['toplam_deneyim'];
    sonIsyeri = json['son_isyeri'];
    sonIsyeriSuresi = json['son_isyeri_suresi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ad'] = this.ad;
    data['soyad'] = this.soyad;
    data['gsm'] = this.gsm;
    data['email'] = this.email;
    data['cv_url'] = this.cvUrl;
    data['cinsiyet'] = this.cinsiyet;
    data['yas'] = this.yas;
    data['dogum_tarihi'] = this.dogumTarihi;
    data['askerlik'] = this.askerlik;
    data['ehliyet'] = this.ehliyet;
    data['mezuniyet'] = this.mezuniyet;
    data['yasadigi_sehir'] = this.yasadigiSehir;
    data['dogdugu_sehir'] = this.dogduguSehir;
    data['sigara'] = this.sigara;
    data['alkol'] = this.alkol;
    data['evlilik'] = this.evlilik;
    data['cocuk_sayisi'] = this.cocukSayisi;
    data['toplam_deneyim'] = this.toplamDeneyim;
    data['son_isyeri'] = this.sonIsyeri;
    data['son_isyeri_suresi'] = this.sonIsyeriSuresi;
    return data;
  }
}