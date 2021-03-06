import 'dart:convert';

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
import 'package:nava/layouts/auth/active_account/ActiveAccount.dart';
import 'package:nava/layouts/auth/login/Login.dart';
import 'package:nava/layouts/auth/reset_password/ResetPassword.dart';
// import 'package:nava/layouts/home/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../../../res.dart';

class ForgetPassword extends StatefulWidget {

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  GlobalKey<ScaffoldState> _scaffold=new GlobalKey();
  GlobalKey<FormState> _formKey=new GlobalKey();
  TextEditingController _phone=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        backgroundColor: MyColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: MyColors.offPrimary,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Image(
                image: AssetImage(Res.logo),
                fit: BoxFit.contain,
                height: 110,
              ),
            ),

            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr("restorePassword"),style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600,color: MyColors.offPrimary,),),

                    RichTextFiled(
                      controller: _phone,
                      label: tr("phone"),
                      type: TextInputType.emailAddress,
                      margin: EdgeInsets.only(top: 20,bottom: 10),
                      fillColor: MyColors.secondary.withOpacity(.5),
                      action: TextInputAction.next,
                    ),

                    CustomButton(
                      title: tr("confirm"),
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                      onTap: (){
                        if(_phone.text==""){
                          Fluttertoast.showToast(msg: tr("enterPhone"));
                        }else{
                          forgetPassword();
                        }
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


  Future forgetPassword() async {
    SharedPreferences preferences =await SharedPreferences.getInstance();
      LoadingDialog.showLoadingDialog();
      final url = Uri.https(URL, "api/send-active-code");
      try {
        final response = await http.post(url,
          body: {
            "phone": "${_phone.text}",
            "lang": "${preferences.getString("lang")}",
          },
        ).timeout( Duration(seconds: 7), onTimeout: () {throw 'no internet';},);
        final responseData = json.decode(response.body);
        if (response.statusCode == 200) {
          EasyLoading.dismiss();
          print("------------ 200");
          print(responseData);
          if(responseData["key"]=="success"){
            print("------------ success");
            Fluttertoast.showToast(msg: responseData["msg"]);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>ResetPassword(phone: _phone.text)), (route) => false);
          }else{
            print("------------ else");
            Fluttertoast.showToast(msg: responseData["msg"]);
          }
        }
      } catch (e) {
        print("fail 222222222   $e}" );
      }
    // }
  }

}
