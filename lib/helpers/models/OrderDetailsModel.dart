// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
  OrderDetailsModel({
    this.key,
    this.msg,
    this.data,
  });

  String key;
  String msg;
  Data data;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
    key: json["key"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "msg": msg,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.allStatus,
    this.statusName,
    this.status,
    this.details,
    this.invoice,
    this.payType,
    this.billId,
  });

  AllStatus allStatus;
  String statusName;
  String status;
  Details details;
  bool invoice;
  String payType;
  int billId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    allStatus: AllStatus.fromJson(json["allStatus"]),
    statusName: json["status_name"],
    status: json["status"],
    details: Details.fromJson(json["details"]),
    invoice: json["invoice"],
    payType: json["pay_type"],
    billId: json["bill_id"],
  );

  Map<String, dynamic> toJson() => {
    "allStatus": allStatus.toJson(),
    "status_name": statusName,
    "status": status,
    "details": details.toJson(),
    "invoice": invoice,
    "pay_type": payType,
    "bill_id": billId,
  };
}

class AllStatus {
  AllStatus({
    this.created,
    this.accepted,
    this.arrived,
    this.inProgress,
    this.finished,
    this.userCancel,
  });

  String created;
  String accepted;
  String arrived;
  String inProgress;
  String finished;
  String userCancel;

  factory AllStatus.fromJson(Map<String, dynamic> json) => AllStatus(
    created: json["created"],
    accepted: json["accepted"],
    arrived: json["arrived"],
    inProgress: json["in-progress"],
    finished: json["finished"],
    userCancel: json["user_cancel"],
  );

  Map<String, dynamic> toJson() => {
    "created": created,
    "accepted": accepted,
    "arrived": arrived,
    "in-progress": inProgress,
    "finished": finished,
    "user_cancel": userCancel,
  };
}

class Details {
  Details({
    this.id,
    this.orderNum,
    this.date,
    this.time,
    this.categoryTitle,
    this.categoryImage,
    this.lat,
    this.lng,
    this.region,
    this.residence,
    this.floor,
    this.street,
    this.addressNotes,
    this.services,
    this.tax,
    this.total,
  });

  int id;
  String orderNum;
  String date;
  String time;
  String categoryTitle;
  String categoryImage;
  double lat;
  double lng;
  String region;
  String residence;
  String floor;
  String street;
  String addressNotes;
  List<DetailsService> services;
  double tax;
  String total;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    id: json["id"],
    orderNum: json["order_num"],
    date: json["date"],
    time: json["time"],
    categoryTitle: json["category_title"],
    categoryImage: json["category_image"],
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
    region: json["region"],
    residence: json["residence"],
    floor: json["floor"],
    street: json["street"],
    addressNotes: json["address_notes"],
    services: List<DetailsService>.from(json["services"].map((x) => DetailsService.fromJson(x))),
    tax: json["tax"].toDouble(),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_num": orderNum,
    "date": date,
    "time": time,
    "category_title": categoryTitle,
    "category_image": categoryImage,
    "lat": lat,
    "lng": lng,
    "region": region,
    "residence": residence,
    "floor": floor,
    "street": street,
    "address_notes": addressNotes,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "tax": tax,
    "total": total,
  };
}

class DetailsService {
  DetailsService({
    this.id,
    this.title,
    this.image,
    this.services,
    this.total,
  });

  int id;
  String title;
  String image;
  List<ServiceService> services;
  int total;

  factory DetailsService.fromJson(Map<String, dynamic> json) => DetailsService(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    services: List<ServiceService>.from(json["services"].map((x) => ServiceService.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
    "total": total,
  };
}

class ServiceService {
  ServiceService({
    this.id,
    this.title,
    this.price,
    this.image,
  });

  int id;
  String title;
  int price;
  String image;

  factory ServiceService.fromJson(Map<String, dynamic> json) => ServiceService(
    id: json["id"],
    title: json["title"],
    price: json["price"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "image": image,
  };
}
