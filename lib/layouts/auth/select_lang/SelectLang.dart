import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/layouts/auth/login/Login.dart';
import 'package:nava/layouts/auth/register/Register.dart';
import 'package:nava/layouts/auth/welcome/Welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';

class SelectLang extends StatefulWidget {

  @override
  _SelectLangState createState() => _SelectLangState();
}

class _SelectLangState extends State<SelectLang> {

  static void  changeLanguage(String lang,BuildContext context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (lang == "en") {
      prefs.setString("lang", lang);
      context.locale = Locale('en', 'US');
    } else {
      context.locale=Locale('ar', 'EG');
      prefs.setString("lang", lang);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage(Res.splash),fit: BoxFit.cover)),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50,horizontal: 15),
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(image: ExactAssetImage(Res.logo),scale: 5)
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr("lang"),style: TextStyle(fontSize: 20,color: MyColors.primary),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(tr("selectLang"),style: TextStyle(fontSize: 16,color: MyColors.offPrimary),),
                  ),


                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CustomButton(
                        title: tr("langAr"),
                        onTap: (){
                          changeLanguage("ar", context);
                          Navigator.push(context, MaterialPageRoute(builder: (c)=>Register()));
                        },
                    ),
                  ),

                  CustomButton(
                    title: tr("langEn"),
                    textColor: MyColors.primary,
                    color: MyColors.secondary,
                    borderColor: MyColors.primary,
                    onTap: (){
                      changeLanguage("en", context);
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>Register()));
                    },
                  ),


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
