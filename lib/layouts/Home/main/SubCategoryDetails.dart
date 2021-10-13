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
import 'package:nava/helpers/models/SubCategoriesModel.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:http/http.dart' as http;
import 'package:nava/helpers/models/SubCategoryDetailsModel.dart';
import 'package:nava/layouts/Home/cart/Cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubCategoryDetails extends StatefulWidget {
  final int id,categoryId;
  final String name, img;

  const SubCategoryDetails({Key key, this.id, this.name, this.img, this.categoryId})
      : super(key: key);

  @override
  _SubCategoryDetailsState createState() => _SubCategoryDetailsState();
}

class _SubCategoryDetailsState extends State<SubCategoryDetails> {
  @override
  void initState() {
    getSubCategoryDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.greyWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(68),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              title: Text(
                widget.name,
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: .5),
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  padding: const EdgeInsets.all(5),
                  child: Image(
                      image: NetworkImage(widget.img),
                      color: MyColors.black,
                      width: 25),
                ),
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
            child: loading ? MyLoading()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .625,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                            itemCount:
                                subCategoryDetailsModel.data.services.length,
                            itemBuilder: (c, i) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                // height: 75,
                                margin: EdgeInsets.only(top: 8),
                                padding: EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  color: MyColors.white,
                                  border: Border.all(width: .5,color: MyColors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap:(){
                                              if(subCategoryDetailsModel.data.services[i].checked){
                                                if(i==0){
                                                  addToCart(counter: "down",serviceId: subCategoryDetailsModel.data.services[i].id.toString(),unchecked: "0");
                                                }else{
                                                  addToCart(counter: "down",serviceId: subCategoryDetailsModel.data.services[i].id.toString(),unchecked: "1");
                                                }
                                              }else{
                                                addToCart(counter: "up",serviceId: subCategoryDetailsModel.data.services[i].id.toString(),unchecked: "0");
                                              }
                                              setState(() {
                                                subCategoryDetailsModel.data.services[i].checked = !subCategoryDetailsModel.data.services[i].checked;
                                              });
                                              },
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(subCategoryDetailsModel.data.services[i].checked ? Icons.check_circle : Icons.radio_button_unchecked,color: MyColors.primary,),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                                  child: Text(subCategoryDetailsModel.data.services[i].title,style: TextStyle(fontWeight: FontWeight.bold),),
                                                ),
                                              ],
                                            ),
                                          ),
                                          i==0 ? Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                                child: Text(subCategoryDetailsModel.data.services[i].price.toString().toString(),style: TextStyle(fontWeight: FontWeight.bold,color: MyColors.primary),),
                                              ),
                                              Text(tr("rs"),style: TextStyle(fontSize: 12,color: MyColors.primary),),
                                            ],
                                          ) :Container(),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                                        child: Text(subCategoryDetailsModel.data.services[i].description,style: TextStyle(fontSize: 12,color: MyColors.grey,fontWeight: FontWeight.bold),),
                                      ),
                                      i!=0 ? Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                                  child: Text(subCategoryDetailsModel.data.services[i].price.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: MyColors.primary),),
                                                ),
                                                Text(tr("rs"),style: TextStyle(fontSize: 12,color: MyColors.primary),),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: (){

                                                    addToCart(
                                                      serviceId: subCategoryDetailsModel.data.services[i].id.toString(),
                                                      counter: "up",
                                                      unchecked: "0",
                                                    );

                                                    setState(() {
                                                      subCategoryDetailsModel.data.services[i].count++;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(5),
                                                    child: Icon(Icons.add_circle_outline,size: 28,color: MyColors.primary,),
                                                  ),
                                                ),
                                                Text(subCategoryDetailsModel.data.services[i].count.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: MyColors.primary,fontSize: 18),),
                                                InkWell(
                                                    onTap: (){
                                                      if(subCategoryDetailsModel.data.services[i].count>1){
                                                        setState(() {
                                                          subCategoryDetailsModel.data.services[i].count--;
                                                        });
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(5),
                                                      child: Icon(Icons.remove_circle_outline,size: 28,color: subCategoryDetailsModel.data.services[i].count>1 ? MyColors.primary:MyColors.grey,),
                                                    )
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ) :Container(),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .26,
                        decoration: BoxDecoration(
                            color: MyColors.white,
                            border: Border.all(color: MyColors.grey, width: .5),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
                          child: Column(
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(tr("vat"), style: TextStyle(fontSize: 16)),
                                  Row(
                                    children: [
                                      Text(addToCartModel.data==null?subCategoryDetailsModel.data.tax.toString():addToCartModel.data.tax.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.primary),
                                      ),
                                      Text(
                                        tr("rs"),
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(tr("total"), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                    Row(
                                      children: [
                                        Text(addToCartModel.data==null?subCategoryDetailsModel.data.price.toString():addToCartModel.data.price.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: MyColors.primary),
                                        ),
                                        Text(
                                          tr("rs"),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                              Text(tr("longText01"), style: GoogleFonts.mada(fontSize: 13), textAlign: TextAlign.center),
                              CustomButton(
                                margin: EdgeInsets.only(top: 8),
                                title: tr("continue"),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (c)=>Cart()));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  String total,vat;
  AddToCartModel addToCartModel =AddToCartModel();
  Future addToCart({String serviceId,counter, unchecked}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    LoadingDialog.showLoadingDialog();
    print("----------------------------00");
    print(preferences.getString("uuid"));
    print(counter);
    print(preferences.getInt("cityId").toString());
    // print(widget.categoryId);
    print(widget.id);
    print(serviceId);
    print(unchecked);
    print(preferences.getString("token"));
    final url = Uri.https(URL, "api/add-to-cart");
    print("----------------------------01");
    try {
      final response = await http.post(url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "uuid": preferences.getString("uuid"),
          "city_id": preferences.getInt("cityId").toString(),
          "category_id": widget.id.toString(),
          "service_id": serviceId,
          "counter": counter,
          "unchecked": unchecked,
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {throw 'no internet please connect to internet';});
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          getSubCategoryDetails();
          setState(() {
            addToCartModel =AddToCartModel.fromJson(responseData);
          });
          Fluttertoast.showToast(msg: responseData["msg"]);
        } else {
          print("----------------------------07");
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("----------------------------08");
      print("error $e" + " ==>> track $t");
    }
  }




  bool loading = true;
  SubCategoryDetailsModel subCategoryDetailsModel = SubCategoryDetailsModel();
  Future getSubCategoryDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/single-category");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "subcategory_id": widget.id.toString(),
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
          subCategoryDetailsModel = SubCategoryDetailsModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }


}
