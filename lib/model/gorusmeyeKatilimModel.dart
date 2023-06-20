class GorusmeyeKatilimModel {
  List<GorusmeyeKatilim>? data;

  GorusmeyeKatilimModel({this.data});

  GorusmeyeKatilimModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GorusmeyeKatilim>[];
      json['data'].forEach((v) {
        data!.add(new GorusmeyeKatilim.fromJson(v));
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

class GorusmeyeKatilim {
  int? id;
  int? gorusmeId;
  int? yetkiliId;
  String? yetkiliID;

  GorusmeyeKatilim({this.id, this.gorusmeId,this.yetkiliId, this.yetkiliID});

  GorusmeyeKatilim.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gorusmeId = json['gorusmeId'];
    yetkiliId = json['yetkiliId'];
    yetkiliID = json['yetkili_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['gorusmeId'] = this.gorusmeId;
    data['yetkiliId'] = this.yetkiliId;
    data['yetkili_ID'] = this.yetkiliID;
    return data;
  }
}