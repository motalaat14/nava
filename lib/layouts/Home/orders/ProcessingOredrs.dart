import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/EmptyBox.dart';
import 'package:nava/helpers/customs/Loading.dart';
import 'package:nava/helpers/models/ProcessingOrdersModel.dart';
import 'package:nava/layouts/Home/orders/OrderDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProcessingOrders extends StatefulWidget {
  @override
  _ProcessingOrdersState createState() => _ProcessingOrdersState();
}

class _ProcessingOrdersState extends State<ProcessingOrders> {
  @override
  void initState() {
    getProcessingOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? MyLoading()
          : processingOrdersModel.data.length == 0
              ? EmptyBox(
                  title: tr("noOrders"),
                  widget: Container(),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  itemCount: processingOrdersModel.data.length,
                  itemBuilder: (c, i) {
                    return orderItem(
                        id: processingOrdersModel.data[i].id,
                        title: processingOrdersModel.data[i].categoryTitle,
                        orderNum: processingOrdersModel.data[i].orderNum,
                        price: processingOrdersModel.data[i].price,
                        status: processingOrdersModel.data[i].status);
                  }),
    );
  }

  Widget orderItem({int id, String title, status, price, orderNum}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => OrderDetails(
                  id: id,
                )));
      },
      child: Container(
        margin: EdgeInsets.only(top: 5),
        child: Card(
          elevation: 6,
          color: MyColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: BorderSide(color: Colors.grey, width: 1),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(8),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: MyColors.grey),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://png.pngtree.com/element_our/20200702/ourlarge/pngtree-cartoon-light-bulb-image_2296728.jpg")),
                        ),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(status,
                        style: TextStyle(fontSize: 12, color: MyColors.green)),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr("totalPrice"),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MyColors.offPrimary)),
                    Row(
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColors.offPrimary),
                        ),
                        Text(
                          tr("rs"),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: MyColors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                height: 2,
                color: MyColors.grey,
                indent: 8,
                endIndent: 8,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr("orderNum"),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MyColors.offPrimary)),
                    Text(
                      orderNum,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.offPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool loading = true;
  ProcessingOrdersModel processingOrdersModel = ProcessingOrdersModel();
  Future getProcessingOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/my-orders/current");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          // "uuid": preferences.getString("uuid"),
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          processingOrdersModel = ProcessingOrdersModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }
}
