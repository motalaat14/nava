import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/Badge.dart';
import 'package:nava/helpers/customs/Loading.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  bool isLoading = true;
  String desc ;

  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    getAbout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        backgroundColor: MyColors.white,
        title: Text(
          tr("about"),
          style: TextStyle(color: MyColors.primary, fontSize: 16),
        ),
        iconTheme: IconThemeData(color: MyColors.primary),
        actions: [
          // InkWell(
          //   onTap: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (c) => Notifications()));
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 10),
          //     child: Badge(
          //         value: "3",
          //         color: MyColors.red,
          //         child: IconButton(
          //           icon: Icon(
          //             Icons.notifications,
          //             color: MyColors.offPrimary,
          //             size: 28,
          //           ),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (c) => Notifications()));
          //           },
          //         )),
          //   ),
          // ),
        ],
      ),

      body:
          loading ?
              MyLoading()
              : Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          )),
    );
  }






  bool loading =true;
  DioBase dioBase = DioBase();
  Future getAbout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      "Authorization": "Bearer ${preferences.getString("token")}"
    };
    dioBase.get("sidePages?type=aboutUs", headers: headers).then((response) {
      if (response.data["key"] == "success") {
        setState(() {loading=false;});
        desc = response.data["data"]["aboutUs"];
      } else {
        print("------------------------else");
        Fluttertoast.showToast(msg: response.data["msg"]);
      }
    });
  }


}
