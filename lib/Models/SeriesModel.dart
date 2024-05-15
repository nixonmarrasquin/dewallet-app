import 'package:siglo21/Entities/Sesion.dart';

import '../Entities/Series.dart';

class SeriesModel extends Object{

  final bool? msg;
  final int? code;
  final List<Series>? data;


  SeriesModel({this.msg, this.code, this.data});

  factory SeriesModel.fromJson(Map<String, dynamic> json) {

    var listData = json['data'] != null ? json['data'] as List : [];
    List<Series> data = listData!=null && listData.length > 0 ? listData.map((i) => Series.fromJson(i)).toList() : [];

    return SeriesModel(
        msg: json['msg'] ?? false,
        code: json['code'] ?? 0,
        data : data
    );
  }

}