import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nava/helpers/constants/LoadingDialog.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/Loading.dart';
import 'package:nava/helpers/models/AddToCartModel.dart';
import 'package:nava/helpers/models/CartModel.dart';
import 'package:nava/helpers/models/SubCategoriesModel.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:http/http.dart' as http;
import 'package:nava/helpers/models/SubCategoryDetailsModel.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';

class Cart extends StatefulWidget {

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    getCart();
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
              elevation: 0,
              title: Text(tr("orderSummary"), style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                InkWell(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (c) => ContactUs()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.add,size: 30,color: MyColors.white,),
                  ),
                )
              ],
            ),
            AppBarFoot(),
          ],
        ),
      ),

      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .888,
            child:
            // loading ? MyLoading():
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [],
            ),
          ),
        ],
      ),
    );
  }

  Widget cartItem(){
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(),
      ),
      child: Column(
        children: [
          Row(
            children: [

            ],
          ),
        ],
      ),
    );
  }




  bool loading = true;
  CartModel cartModel = CartModel();
  Future getCart() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/cart");
    try {
      final response = await http.post(url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "uuid": preferences.getString("uuid"),
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          cartModel = CartModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }


}
