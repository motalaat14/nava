import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/Badge.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/layouts/auth/splash/Splash.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../../res.dart';

class LangScreen extends StatefulWidget {
  @override
  _LangScreenState createState() => _LangScreenState();
}

class _LangScreenState extends State<LangScreen> {
  @override
  void initState() {
    initLang();
    super.initState();
  }

  String lang;
  bool ar = true;
  initLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(preferences.getString("lang"));
    print(preferences.getString("lang"));
    setState(() {
      lang = preferences.getString("lang");
    });
    if(preferences.getString("lang")=="ar"){
      setState(() {
        ar=true;
      });
    }else{
      setState(() {
        ar=false;
      });
    }
  }

  changeLangPref({@required String newLang}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("lang", newLang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        elevation: 0,
        title: Text(tr("appLang"), style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
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
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage(Res.splash),fit: BoxFit.cover)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Text(
                  tr("appLang"),
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: MyColors.offPrimary),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    tr("plzSelectLang"),
                    style: TextStyle(fontSize: 16,color: MyColors.primary),
                  ),
                ),
                InkWell(
                    onTap: () {
                      if (!ar) {
                        setState(() {
                          ar = true;
                          lang="ar";
                        });
                      }
                      print(lang);
                    },
                    child: langItem(
                      lang: "?????????? ??????????????",
                      img: Res.saudiarabia,
                      selected: ar,
                    )),
                InkWell(
                    onTap: () {
                      if (ar) {
                        setState(() {
                          ar = false;
                          lang="en";
                        });
                      }
                      print(lang);
                    },
                    child: langItem(
                      lang: "English",
                      img: Res.usa,
                      selected: !ar,
                    ),
                ),
                Spacer(),
                CustomButton(
                  margin: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                    title: tr("confirm"),
                    onTap: (){
                    changeLangPref(newLang: lang);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Splash()),
                            (route) => false);
                    Fluttertoast.showToast(
                      msg: tr("langChanged"),
                    );
                    },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget langItem({String lang, img, bool selected}) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width * .8,
      height: 110,
      decoration: BoxDecoration(
        color: selected?MyColors.accent.withOpacity(.2):MyColors.grey.withOpacity(.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? MyColors.accent : MyColors.grey.withOpacity(.2), width: 2)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage(img),
            width: 40,
          ),
          Text(lang,
            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
