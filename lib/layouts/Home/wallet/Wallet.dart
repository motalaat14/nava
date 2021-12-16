import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/Visitor.dart';
import 'package:nava/helpers/providers/visitor_provider.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:provider/provider.dart';

import '../../../res.dart';
import 'dart:convert';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/Loading.dart';
import 'package:nava/helpers/models/ProcessingOrdersModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Wallet extends StatefulWidget {

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  @override
  void initState() {
    getWallet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    VisitorProvider visitorProvider = Provider.of<VisitorProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: MyColors.greyWhite,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(tr("wallet"), style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              // leading: IconButton(
              //   icon: Icon(Icons.arrow_back_ios),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (c) => ContactUs()));
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
      
      body:

      visitorProvider.visitor?

      Visitor()

          : ListView(
        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 15),
        children: [
          Image(
            image: ExactAssetImage(Res.wallet3),
            height: 200,
          ),
          Center(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(tr("currentBalance"),style: TextStyle(fontSize: 22),),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(wallet,style: TextStyle(fontSize: 90,fontWeight: FontWeight.bold,color: MyColors.primary),),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr("r"),style: TextStyle(fontSize: 18),),
                      Text(tr("s"),style: TextStyle(fontSize: 18),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
              title: tr("chargeBalance"),
              margin: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              onTap: (){},
          )

        ],
      ),
    );
  }


  String wallet="0";
  bool loading = true;
  Future getWallet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/wallet");
    try {
      final response = await http.post(url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          setState(() {
            wallet = responseData["data"].toString();
          });

        } else {
          // Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }


}
