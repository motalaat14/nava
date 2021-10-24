// To parse this JSON data, do
//
//     final processingOrdersModel = processingOrdersModelFromJson(jsonString);

import 'dart:convert';

ProcessingOrdersModel processingOrdersModelFromJson(String str) => ProcessingOrdersModel.fromJson(json.decode(str));

String processingOrdersModelToJson(ProcessingOrdersModel data) => json.encode(data.toJson());

class ProcessingOrdersModel {
  ProcessingOrdersModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  List<Datum> data;

  factory ProcessingOrdersModel.fromJson(Map<String, dynamic> json) => ProcessingOrdersModel(
    key: json["key"],
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.orderNum,
    this.categoryTitle,
    this.price,
    this.status,
  });

  int id;
  String orderNum;
  String categoryTitle;
  String price;
  String status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    orderNum: json["order_num"],
    categoryTitle: json["category_title"],
    price: json["price"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_num": orderNum,
    "category_title": categoryTitle,
    "price": price,
    "status": status,
  };
}
