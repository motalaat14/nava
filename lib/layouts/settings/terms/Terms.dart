import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/Badge.dart';
import 'package:nava/helpers/customs/Loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Terms extends StatefulWidget {
  final String from;

  const Terms({Key key, this.from}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TermsState();
  }
}

class _TermsState extends State<Terms> {
  String desc;
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getTerms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.white,
        title: Text(
          tr("terms"),
          style: TextStyle(color: MyColors.primary, fontSize: 16),
        ),
        iconTheme: IconThemeData(color: MyColors.primary),
        actions: [
          widget.from == "register"
              ? Container()
              : InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (c) => Notifications()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Badge(
                        value: "3",
                        color: MyColors.red,
                        child: IconButton(
                          icon: Icon(
                            Icons.notifications,
                            color: MyColors.offPrimary,
                            size: 28,
                          ),
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (c) => Notifications()));
                          },
                        )),
                  ),
                ),
        ],
      ),
      key: _scaffold,
      body: loading
          ? MyLoading()
          : Center(
              child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
    );
  }

  bool loading = true;
  DioBase dioBase = DioBase();
  Future getTerms() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      "Authorization": "Bearer ${preferences.getString("token")}"
    };
    dioBase
        .get("sidePages?type=termsConditions", headers: headers)
        .then((response) {
      if (response.data["key"] == "success") {
        setState(() {
          loading = false;
        });
        desc = response.data["data"]["termsConditions"];
      } else {
        print("------------------------else");
        Fluttertoast.showToast(msg: response.data["msg"]);
      }
    });
  }
}
