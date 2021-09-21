import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/LabelTextField.dart';
import 'package:nava/layouts/Home/orders/RejectReason.dart';
import 'package:nava/layouts/Home/orders/SuccessfulOrder.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';

import '../../../res.dart';
enum PayType { visa,apple,cash,wallet }

class Pay extends StatefulWidget {

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {

  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController _coupon = new TextEditingController();

  PayType type =PayType.visa ;
  String payment="visa";

  @override
  void initState() {
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
              title: Text(tr("pay"), style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
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

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:  MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text("${tr("addedDetails")} :",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text("هذا النص هو مثال لنص يمكن ان يستخدم في نفس المساحة هذا النص هو مثال لنص يمكن ان يستخدم في نفس المساحة",style: TextStyle(fontSize: 14),),
                ),
                Divider(thickness: .5,color: MyColors.black,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr("vat"),style: TextStyle(fontSize: 16),),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text("95",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        ),
                        Text(tr("rs"),style: TextStyle(fontSize: 14,color: MyColors.grey),),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tr("total"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Text("1205",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          ),
                          Text(tr("rs"),style: TextStyle(fontSize: 14,color: MyColors.grey),),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(thickness: .5,color: MyColors.black,),
                Text("${tr("coupon")}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                Form(
                  key: _formKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    margin: EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LabelTextField(
                          // margin: EdgeInsets.only(top: 5),
                          maxWidth: MediaQuery.of(context).size.width*.65,
                          minWidth: MediaQuery.of(context).size.width*.60,
                          label: tr("coupon"),
                          type: TextInputType.text,
                          controller: _coupon,
                        ),
                        CustomButton(
                          width: MediaQuery.of(context).size.width*.27,
                          height: 48,
                          color: MyColors.white,
                          borderColor: MyColors.primary,
                          textColor: MyColors.primary,
                          margin: EdgeInsets.only(top: 0),
                          borderRadius: BorderRadius.circular(10),
                          title: tr("active"),
                          onTap: (){},
                        ),

                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(tr("selectPayType"),
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: MyColors.offPrimary),),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          type = PayType.visa;
                          payment = "visa";
                        });print(payment);},
                      child: Row(
                        children: <Widget>[
                          Radio(
                              activeColor: MyColors.accent,
                              hoverColor: MyColors.white,
                              focusColor: MyColors.white,
                              value: PayType.visa,
                              groupValue: type,
                              onChanged: (PayType value) {
                                setState(() {
                                  print(value);
                                  type = value;
                                  payment = "visa";
                                });
                                print(payment);

                              }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Image(image: ExactAssetImage(Res.visa),width: 40,),
                          ),
                          Text(tr("visa"),
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: payment=="visa" ? MyColors.primary :MyColors.grey),),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          type = PayType.apple;
                          payment = "apple";
                        });
                        print(payment);
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                              activeColor: MyColors.accent,
                              hoverColor: MyColors.white,
                              focusColor: MyColors.white,
                              value: PayType.apple,
                              groupValue: type,
                              onChanged: (PayType value) {
                                setState(() {
                                  print(value);
                                  type = value;
                                  payment = "apple";
                                });
                                print(payment);

                              }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Image(image: ExactAssetImage(Res.applepay),width: 40,),
                          ),
                          Text(tr("apple"),
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: payment=="apple" ? MyColors.primary :MyColors.grey),),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          type = PayType.cash;
                          payment = "cash";
                        });
                        print(payment);
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                              activeColor: MyColors.accent,
                              hoverColor: MyColors.white,
                              focusColor: MyColors.white,
                              value: PayType.cash,
                              groupValue: type,
                              onChanged: (PayType value) {
                                setState(() {
                                  print(value);
                                  type = value;
                                  payment = "cash";
                                });
                                print(payment);

                              }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Image(image: ExactAssetImage(Res.cashpayment),width: 40,),
                          ),
                          Text(tr("cash"),
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: payment=="cash" ? MyColors.primary :MyColors.grey),),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          type = PayType.wallet;
                          payment = "wallet";
                        });
                        print(payment);
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                              activeColor: MyColors.accent,
                              value: PayType.wallet,
                              groupValue: type,
                              onChanged: (PayType value) {
                                setState(() {
                                  print(value);
                                  type = value;
                                  payment = "wallet";
                                });
                                print(payment);
                              }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Image(image: ExactAssetImage(Res.wallet),width: 35,),
                          ),
                          Text(tr("wallet"),
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: payment=="wallet" ? MyColors.primary :MyColors.grey),),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),


            Column(
              children: [
                CustomButton(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  title: tr("payIt"),
                  onTap: (){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>SuccessfulOrder()), (route) => false);
                  },
                ),
                CustomButton(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  title: tr("rejectIt"),
                  color: MyColors.red,
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (c)=>RejectReason()));
                  },
                ),
              ],
            ),


          ],
        ),
      ),

    );
  }
}
