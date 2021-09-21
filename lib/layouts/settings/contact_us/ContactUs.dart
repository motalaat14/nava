import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mdi/mdi.dart';
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/LoadingDialog.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/Badge.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/Loading.dart';
import 'package:nava/helpers/customs/RichTextFiled.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../../../res.dart';
import 'package:nava/helpers/constants/base.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey();
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController _name = new TextEditingController();
  TextEditingController _mail = new TextEditingController();
  TextEditingController _msg = new TextEditingController();

  @override
  void initState() {
    // getContact();
    super.initState();
  }



  Future contactUs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("------------ contactUs ------------");
    LoadingDialog.showLoadingDialog();
    final url = Uri.https(URL, "api/sendComplain");
    try {
      final response = await http.post(url, headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "name": _name.text,
          "email": _mail.text,
          "message": _msg.text,
        },
      ).timeout(Duration(seconds: 7), onTimeout: () {throw 'no internet please connect to internet';});
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(responseData);
        if (responseData["key"] == "success") {
          print("------------ success ------------");
          Fluttertoast.showToast(msg: responseData["msg"]);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {print("fail 222222222   $e}");
    Fluttertoast.showToast(msg: tr("netError"));}
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        backgroundColor: MyColors.white,
        title: Text(
          tr("contactUs"),
          style: TextStyle(color: MyColors.primary, fontSize: 16),
        ),
        iconTheme: IconThemeData(color: MyColors.primary),
        actions: [
          InkWell(
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

      body:SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 110,
              height: 120,
              margin: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Res.logo), fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${tr("name")}",
                    ),
                    RichTextFiled(
                      margin: EdgeInsets.only(top: 5),
                      label: tr("enterName"),
                      type: TextInputType.text,
                      controller: _name,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "${tr("mail")}",
                      ),
                    ),
                    RichTextFiled(
                      margin: EdgeInsets.only(top: 5),
                      label: tr("enterEmail"),
                      type: TextInputType.emailAddress,
                      controller: _mail,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        tr("yourMsg"),
                      ),
                    ),
                    RichTextFiled(
                      margin: EdgeInsets.only(top: 5),
                      label: tr("enterYourMsg"),
                      type: TextInputType.emailAddress,
                      height: 130,
                      max: 8,
                      min: 6,
                      controller: _msg,
                    ),
                    CustomButton(
                      title: tr("send"),
                      onTap: () {
                        if(_name.text==""||_mail.text==""||_msg.text==""){
                          Fluttertoast.showToast(msg: tr("plzFillData"));
                        }else{
                          contactUs();
                        }
                      },
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    ),
                    Center(
                            child: Column(
                              children: [
                                Text(
                                  tr("viaSocial"),
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: MyColors.primary),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    tr("contactViaSocial"),
                                    style: TextStyle(fontSize: 13,color: MyColors.offPrimary),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                // loading ? Padding(
                                //   padding: const EdgeInsets.symmetric(vertical: 15),
                                //   child: SpinKitThreeBounce(color: MyColors.accent, size: 30.0),
                                // ) :
                                Container(
                                  height: 70,
                                  width: MediaQuery.of(context).size.width * .5,
                                  margin: EdgeInsets.only(
                                    bottom: 30,
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          launchURL(url: "contactModel.data.contactUs.facebook");},
                                        child: Icon(Mdi.facebook, size: 50, color: Colors.indigoAccent),
                                      ),

                                      InkWell(
                                        onTap: () {
                                          launchURL(url: "contactModel.data.contactUs.instagram");},
                                        child: Icon(Mdi.instagram, size: 50, color: Colors.redAccent),
                                      ),

                                      InkWell(
                                        onTap: () {
                                          launchURL(url: "contactModel.data.contactUs.linkedIn");},
                                        child: Icon(Mdi.linkedin, size: 50, color: Colors.lightBlueAccent),
                                      ),

                                      InkWell(
                                        onTap: () {
                                          launchURL(url: "contactModel.data.contactUs.twitter");},
                                        child: Icon(Mdi.twitter, size: 50, color: Colors.blue),
                                      ),

                                    ],
                                  ),





                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void launchURL({String url}) async {
    if (!url.toString().startsWith("https")) {
      url = "https://" + url;
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
        msg: "checkLink",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }








  // bool loading =true;
  // ContactModel contactModel = ContactModel();
  // DioBase dioBase = DioBase();
  // Future getContact() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   Map<String, String> headers = {
  //     "Authorization": "Bearer ${preferences.getString("token")}"
  //   };
  //   dioBase.get("sidePages?type=contactUs", headers: headers).then((response) {
  //     if (response.data["key"] == "success") {
  //       setState(() {loading=false;});
  //       contactModel = ContactModel.fromJson(response.data);
  //     } else {
  //       EasyLoading.dismiss();
  //       print("------------------------else");
  //       Fluttertoast.showToast(msg: response.data["msg"]);
  //     }
  //   });
  // }




}
