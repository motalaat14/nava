import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava/helpers/constants/LoadingDialog.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/RichTextFiled.dart';
import 'package:nava/layouts/Home/Home.dart';
import 'package:nava/layouts/auth/active_account/ActiveAccount.dart';
import 'package:nava/layouts/auth/forget_password/ForgetPassword.dart';
// import 'package:nava/layouts/home/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../../../res.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  GlobalKey<ScaffoldState> _scaffold=new GlobalKey();
  GlobalKey<FormState> _formKey=new GlobalKey();
  TextEditingController _phone=new TextEditingController();
  TextEditingController _pass=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 50),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Image(
                image: AssetImage(Res.logo),
                fit: BoxFit.contain,
                height: 120,
              ),
            ),

            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr("login"),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: MyColors.offPrimary,),),

                    RichTextFiled(
                      controller: _phone,
                      label: tr("phone"),
                      type: TextInputType.emailAddress,
                      margin: EdgeInsets.only(top: 20,bottom: 10),
                      fillColor: MyColors.secondary.withOpacity(.5),
                      action: TextInputAction.next,
                    ),

                    RichTextFiled(
                      controller: _pass,
                      label: tr("password"),
                      type: TextInputType.emailAddress,
                      margin: EdgeInsets.only(top: 12,bottom: 25),
                      fillColor: MyColors.secondary.withOpacity(.5),
                    ),


                    InkWell(
                      onTap: (){
                        Navigator.push(context, CupertinoPageRoute(builder: (context)=>ForgetPassword()));
                      },
                      child: Align(
                        alignment: Alignment.bottomLeft,
                          child: Text(tr("forgetPassword"),style: TextStyle(fontSize: 13,color: MyColors.primary,decoration: TextDecoration.underline,fontWeight: FontWeight.bold),)),
                    ),


                    CustomButton(
                        title: tr("login"),
                        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 25),
                        onTap: (){
                          login();
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false,);
                          //
                          // Navigator.push(context, CupertinoPageRoute(builder: (context)=>Home()));
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String uuid ;
  void getUuid()async{
    SharedPreferences preferences =await SharedPreferences.getInstance();
    print("uuid get token >>>> ${preferences.getString("fcmToken")}");
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    if(Platform.isAndroid){
      var build = await deviceInfoPlugin.androidInfo;
      uuid = build.androidId;
      preferences.setString("uuid", uuid);
    }else if(Platform.isIOS){
      var data = await deviceInfoPlugin.iosInfo;
      uuid = data.identifierForVendor;
      preferences.setString("uuid", uuid);
    }
  }

  Future login() async {
    SharedPreferences preferences =await SharedPreferences.getInstance();
    print("========> login");
    LoadingDialog.showLoadingDialog();
    print(preferences.getString("fcmToken"));
    final url = Uri.https(URL, "api/login");
    try {
      final response = await http.post(url,
        body: {
          "uuid":"$uuid",
          "phone": "${_phone.text}",
          "password": "${_pass.text}",
          "device_id": preferences.getString("fcmToken"),
          "device_type": Platform.isIOS ?"ios":"android",
          "lang":preferences.getString("lang"),
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {throw 'no internet please connect to internet';});
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if(responseData["key"]=="success"){
          preferences.setString("userId", responseData["data"]["user_base_info"]["id"].toString());
          preferences.setString("name",   responseData["data"]["user_base_info"]["name"]);
          preferences.setString("phone",  responseData["data"]["user_base_info"]["phone"]);
          preferences.setString("email",  responseData["data"]["user_base_info"]["email"]);
          preferences.setString("token",  responseData["data"]["user_base_info"]["token"]);
          preferences.setString("image",  responseData["data"]["user_base_info"]["image"]);
          // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false,);
        }else if(responseData["key"]=="needActive"){
          Fluttertoast.showToast(msg: responseData["data"]);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>ActiveAccount(phone: _phone.text,)), (route) => false,);
        }else{
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("fail 222222222   $e}" );
    }
  }


}
