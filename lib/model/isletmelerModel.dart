class IsletmeModel {
  List<Isletme>? isletme;

  IsletmeModel({this.isletme});

  IsletmeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      isletme = <Isletme>[];
      json['data'].forEach((v) {
        isletme!.add(new Isletme.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.isletme != null) {
      data['data'] = this.isletme!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Isletme {
  int? id;
  String? unvan;

  Isletme({this.id, this.unvan});

  Isletme.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unvan = json['unvan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unvan'] = this.unvan;
    return data;
  }
}