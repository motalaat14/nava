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
import 'package:nava/layouts/Home/main/SubCategoryDetails.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home.dart';
import 'AddNotesAndImages.dart';
import 'Address.dart';

class Cart extends StatefulWidget {
  final int categoryId;

  const Cart({Key key, this.categoryId}) : super(key: key);

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
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(tr("orderSummary"), style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false);
                    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false);
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
            height: MediaQuery.of(context).size.height * .86,
            child:
            loading ? MyLoading():
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .6,
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      itemCount: cartModel.data.services.length,
                      itemBuilder: (c,i)=>cartItem(
                        id: cartModel.data.services[i].id,
                        index: i,
                        img: cartModel.data.services[i].image,
                        title: cartModel.data.services[i].title,
                      )),
                ),


                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .25,
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(cartModel.data.tax,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.primary),
                                  ),
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(cartModel.data.total,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyColors.primary),
                                    ),
                                  ),
                                  Text(tr("rs"),style: TextStyle(fontSize: 14)),
                                ],
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Spacer(),
                        CustomButton(
                          margin: EdgeInsets.only(top: 8),
                          color: MyColors.white,
                          textColor: MyColors.primary,
                          borderColor: MyColors.primary,
                          title: tr("addNotesAndImages"),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (c)=>AddNotesAndImages(id: cartModel.data.id,)));
                          },
                        ),
                        CustomButton(
                          margin: EdgeInsets.only(top: 8),
                          title: tr("continue"),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (c)=>Address(orderId: cartModel.data.id,)));
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

  Widget cartItem({int id,int index,String title , img,}){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: .5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image(image: NetworkImage(img),width: 30,height: 30,fit: BoxFit.cover,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(title,style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>SubCategoryDetails(
                            id: cartModel.data.services[index].id,
                            name: cartModel.data.services[index].title,
                            img: cartModel.data.services[index].image,
                            categoryId: widget.categoryId,
                          )), (route) => false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.edit,color: MyColors.primary,),
                        ),
                      ),
                      InkWell(
                          onTap: (){
                            deleteCartItem(id: id.toString());
                          },
                          child: Icon(CupertinoIcons.delete,color: MyColors.red,)
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: cartModel.data.services[index].services.length*30.0,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: cartModel.data.services[index].services.length,
                itemBuilder: (c,i)=>cartServiceItem(
                  title: cartModel.data.services[index].services[i].title,
                  price: cartModel.data.services[index].services[i].price.toString()
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cartServiceItem({String title,price}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: TextStyle(color: MyColors.primary),),
          Row(
            children: [
              Text(price,style: TextStyle(fontWeight: FontWeight.bold),),
              Text(tr("rs"),style: TextStyle(fontSize: 12,color: MyColors.grey),),
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
      ).timeout(Duration(seconds: 10), onTimeout: () {throw 'no internet';});
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        print(responseData);
        if (responseData["key"] == "success") {
          if(responseData["data"]["services"] == null){
            print("________________________ empty");
            Navigator.of(context).pop();
          }else if(responseData["data"]["total"] == "0"){
            print("________________________ empty []");
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false);
          }else{
            cartModel = CartModel.fromJson(responseData);
            print("________________________ not");
          }
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

  Future deleteCartItem({String id}) async {
    LoadingDialog.showLoadingDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(preferences.getString("token"));
    print(cartModel.data.id.toString());
    print(id);
    final url = Uri.https(URL, "api/delete-cart-item");
    try {
      final response = await http.post(url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "order_id": cartModel.data.id.toString(),
          "sub_category_id": id,
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {throw 'no internet';});
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        print(responseData);
        if (responseData["key"] == "success") {
          getCart();
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }else{
        print("${response.statusCode}");
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

}
