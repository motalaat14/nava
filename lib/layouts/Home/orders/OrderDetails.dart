import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:nava/helpers/constants/LoadingDialog.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/Loading.dart';
import 'package:nava/helpers/models/OrderDetailsModel.dart';
import 'package:nava/layouts/Home/Home.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../res.dart';
import 'Pay.dart';

class OrderDetails extends StatefulWidget {
  final int id;

  const OrderDetails({Key key, this.id}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {


  @override
  void initState() {
    print(widget.id);
    getOrderDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.greyWhite,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(tr("orderDetails"),
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (c) => ContactUs()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image(
                      image: ExactAssetImage(Res.contactus),
                      width: 26,
                    ),
                  ),
                )
              ],
            ),
            AppBarFoot(),
          ],
        ),
      ),
      body: loading
          ? MyLoading()
          : ListView(
              padding: EdgeInsets.symmetric(horizontal: 15),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tr("orderNum"),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        orderDetailsModel.data.details.orderNum,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                Column(
                  children: [
                    followItem(
                      title: orderDetailsModel.data.allStatus.created,
                      done: orderDetailsModel.data.status == "created" ? true : false,
                      location: "top",
                    ),
                    followItem(
                        title: orderDetailsModel.data.allStatus.accepted,
                        done: orderDetailsModel.data.status == "accepted" ? true : false,
                        location: "",
                    ),
                    followItem(
                        title: orderDetailsModel.data.allStatus.arrived,
                        done: orderDetailsModel.data.status == "arrived" ? true : false,
                        location: ""),
                    followItem(
                        title: orderDetailsModel.data.allStatus.inProgress,
                        done: orderDetailsModel.data.status == "in-progress" ? true : false,
                        location: ""),
                    followItem(
                        title: orderDetailsModel.data.allStatus.finished,
                        done: orderDetailsModel.data.status == "finished" ? true : false,
                        location: "end"),
                  ],
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(orderDetailsModel.data.details.categoryTitle,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Image(
                        image: NetworkImage(orderDetailsModel.data.details.categoryImage),
                        height: 30,
                        color: MyColors.black,
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                InkWell(
                  onTap: () {
                    MapsLauncher.launchCoordinates(orderDetailsModel.data.details.lat,orderDetailsModel.data.details.lng);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tr("address"),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(tr("showMap"),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .23,
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColors.offPrimary, width: 1)),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(orderDetailsModel.data.details.lat,orderDetailsModel.data.details.lng),
                      zoom: 11,
                    ),
                    markers: Set<Marker>.of(markers.values),
                  ),
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          tr("address"),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColors.offPrimary),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "${tr("city")} : ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(orderDetailsModel.data.details.region,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:8),
                        child: Row(
                          children: [
                            Text(
                              "${tr("addedNotes")} : ",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(orderDetailsModel.data.details.addressNotes,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "تفاصيل الخدمة",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MyColors.offPrimary),
                  ),
                ),
                Container(
                  height: 130.0 * orderDetailsModel.data.details.services.length,
                  child: ListView.builder(
                      itemCount: orderDetailsModel.data.details.services.length,
                      itemBuilder: (c, i) {
                        return serviceItem(
                          index: i,
                          img: orderDetailsModel.data.details.services[i].image,
                          title: orderDetailsModel.data.details.services[i].title,
                          price: orderDetailsModel.data.details.services[i].total.toString(),
                        );
                      }),
                ),
                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr("vat"),
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(orderDetailsModel.data.details.tax.toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            tr("rs"),
                            style:
                                TextStyle(fontSize: 14, color: MyColors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr("total"),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(orderDetailsModel.data.details.total.toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            tr("rs"),
                            style:
                                TextStyle(fontSize: 14, color: MyColors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),





                Divider(
                  thickness: .5,
                  color: MyColors.black,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5,bottom: 20,left: 5,right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr("payWay"),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(orderDetailsModel.data.payType,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,color: MyColors.primary),
                      ),
                    ],
                  ),
                ),

                orderDetailsModel.data.status == "user_cancel" ?
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Center(
                    child: Text(
                      orderDetailsModel.data.statusName,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ):Container(),



                orderDetailsModel.data.invoice?
                CustomButton(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  title: tr("payBell"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (c) => Pay(
                      orderId: orderDetailsModel.data.details.id,
                      price: orderDetailsModel.data.details.total,
                      tax: orderDetailsModel.data.details.tax.toString(),
                    )));
                  },
                ):orderDetailsModel.data.status=="created"?
                CustomButton(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  title: tr("cancelOrder"),
                  color: MyColors.red,
                  onTap: () {
                    cancelOrder();
                  },
                ):orderDetailsModel.data.status=="finished"?
                CustomButton(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  title: tr("addGuarantee"),
                  color: MyColors.accent,
                  borderColor: MyColors.offPrimary,
                  textColor: MyColors.offPrimary,
                  onTap: () {
                    granteeOrder();
                  },
                )
                    :Container(),
              ],
            ),
    );
  }

  Widget followItem({String title, bool done, String location}) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 25,
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: location == "top"
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))
                    : location == "end"
                        ? BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))
                        : BorderRadius.circular(0),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: done ? MyColors.primary : MyColors.accent.withOpacity(.8),
                    size: 45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    title,
                    style: TextStyle(fontSize:done ? 18:16,fontWeight: done ? FontWeight.bold:FontWeight.normal),
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget serviceItem({int index , String img, title, price}) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      width: MediaQuery.of(context).size.width,
      // height: 150,
      decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all()),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(),
                    image: DecorationImage(
                        image: NetworkImage(img), fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),


          Container(
            height: orderDetailsModel.data.details.services[index].services.length*18.0,
            child: ListView.builder(
              itemCount: orderDetailsModel.data.details.services[index].services.length,
                itemBuilder: (c,i){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      orderDetailsModel.data.details.services[index].services[i].title,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: MyColors.primary),
                    ),
                  );
                },
            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("price"),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      price,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      tr("rs"),
                      style: TextStyle(fontSize: 14, color: MyColors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),







        ],
      ),
    );
  }

  bool loading = true;
  OrderDetailsModel orderDetailsModel = OrderDetailsModel();
  Future getOrderDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/order-details");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "order_id": widget.id.toString(),
        },
      ).timeout(Duration(seconds: 10),
          onTimeout: () => throw 'no internet please connect to internet');
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          orderDetailsModel = OrderDetailsModel.fromJson(responseData);
          print(orderDetailsModel.data.status);
          print(orderDetailsModel.data.status);
          print(orderDetailsModel.data.status);
          print(orderDetailsModel.data.status);
          _add();
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

  Future cancelOrder() async {
    LoadingDialog.showLoadingDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/order-cancel");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "order_id": widget.id.toString(),
        },
      ).timeout(Duration(seconds: 10),
          onTimeout: () => throw 'no internet please connect to internet');
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          Fluttertoast.showToast(msg: responseData["msg"]);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

  Future granteeOrder() async {
    LoadingDialog.showLoadingDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/order-guarantee");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "order_id": widget.id.toString(),
        },
      ).timeout(Duration(seconds: 10),
          onTimeout: () => throw 'no internet please connect to internet');
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          Fluttertoast.showToast(msg: responseData["msg"]);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  void _add() {
    var markerIdVal = "1";
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(orderDetailsModel.data.details.lat,orderDetailsModel.data.details.lng),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {},
    );
    setState(() {
      markers[markerId] = marker;
    });
  }
}













