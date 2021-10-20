import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:nava/helpers/customs/RichTextFiled.dart';
import 'package:nava/helpers/models/CitiesModel.dart';
import 'package:nava/helpers/models/HomeModel.dart';
import 'package:nava/layouts/Home/main/SubCaregories.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../res.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  TextEditingController search = TextEditingController();

  String city = tr("selectCity");
  String name = "";
  initData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name");
      city = preferences.getString("cityName") ?? tr("selectCity");
    });
  }

  @override
  void initState() {
    initData();
    getCities();
    getHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        "${tr("welcome")} , ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        name,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (citiesModel.data != null) {
                      selectCity(context);
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        city,
                        style: TextStyle(fontSize: 12),
                      ),
                      Icon(Icons.expand_more),
                    ],
                  ),
                ),
              ],
            ),
          ),
          centerTitle: false,
          elevation: 0,
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (c) => ContactUs()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image(
                  image: ExactAssetImage(Res.contactus),
                  width: 26,
                ),
              ),
            ),
          ],
        ),
      ),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        controller: ScrollController(keepScrollOffset: true),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 140,
                        decoration: BoxDecoration(
                          color: MyColors.primary,
                          // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                        ),
                      ),
                      Column(
                        children: [
                          loading
                              ? Container(
                                  height: 140,
                                  child: SpinKitDoubleBounce(
                                      color: MyColors.white, size: 30.0),
                                )
                              : Container(
                                  height: 140,
                                  child: Swiper(
                                    duration: 1000,
                                    autoplay: true,
                                    itemCount: homeModel.data.sliders.length,
                                    fade: .6,
                                    viewportFraction: .86,
                                    scrollDirection: Axis.horizontal,
                                    pagination: SwiperPagination(
                                      alignment: Alignment.bottomCenter,
                                    ),
                                    scale: .95,
                                    itemBuilder: (c, i) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: .2,
                                              color: MyColors.accent),
                                          color:
                                              MyColors.accent.withOpacity(.1),
                                          image: DecorationImage(
                                              image: NetworkImage(homeModel
                                                  .data.sliders[i].image),
                                              fit: BoxFit.cover),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ];
        },
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      color: MyColors.primary,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                ),
                RichTextFiled(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  height: 45,
                  icon: Icon(Icons.search),
                  controller: search,
                  label: tr("searchWord"),
                  labelColor: MyColors.grey,
                ),
              ],
            ),
            loading
                ? Container(
                    height: MediaQuery.of(context).size.height*.5,
                    child: SpinKitDoubleBounce(
                        color: MyColors.primary, size: 30.0))
                : Container(
                    padding: EdgeInsets.only(top: 2),
                    height: MediaQuery.of(context).size.height - 245,
                    color: MyColors.secondary,
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 8 / 9,
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: homeModel.data.categories.length,
                      itemBuilder: (c, i) {
                        return categoryItem(
                          id: homeModel.data.categories[i].id,
                          img: homeModel.data.categories[i].image,
                          title: homeModel.data.categories[i].title,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget categoryItem({int id, String img, title}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (c) => SubCategories(id: id, name: title, img: img)));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          child: Stack(
            children: [
              Container(
                // width: 100,
                // height: 100,
                margin: EdgeInsets.all(50),
                decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(img))),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: CircleAvatar(
                              child: Image(
                                image: NetworkImage(img),
                                width: 20,
                                color: MyColors.black,
                              ),
                              foregroundColor: MyColors.black,
                              backgroundColor: MyColors.primary.withOpacity(.2),
                            ),

                            // child: Container(
                            //   width: 40,
                            //   height: 40,
                            //   decoration: BoxDecoration(
                            //     image: DecorationImage(image: NetworkImage(img)),
                            //     color: MyColors.grey,
                            //     borderRadius: BorderRadius.circular(50)
                            //   ),
                            //     // child: Image(image: NetworkImage(img),width: 50,)
                            //   ),
                          ),
                          Container(),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 19),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectCity(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: CupertinoActionSheet(
              // cancelButton: CupertinoButton(
              //   child: Text(
              //     tr("confirm"),
              //     style: TextStyle(
              //         fontFamily: GoogleFonts.almarai().fontFamily,
              //         color: MyColors.red),
              //   ),
              //   onPressed: () => Navigator.of(context).pop(),
              // ),
              actions: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tr("selectCity"),
                      style: TextStyle(
                        fontSize: 18,
                        color: MyColors.primary,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.almarai().fontFamily,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .6,
                  child: ListView.builder(
                      itemCount: citiesModel.data.length,
                      itemBuilder: (c, i) {
                        return FlatButton(
                          child: Text(citiesModel.data[i].title,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            SharedPreferences preferences = await SharedPreferences.getInstance();
                            Navigator.of(context).pop();
                            setState(() {
                              city = citiesModel.data[i].title;
                              preferences.setString("cityName", citiesModel.data[i].title);
                              preferences.setInt("cityId", citiesModel.data[i].id);
                            });
                            getHome();
                            print(preferences.getInt("cityId"));
                            print(preferences.getInt("cityId"));
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  CitiesModel citiesModel = CitiesModel();
  Future getCities() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/cities");
    try {
      final response = await http.post(
        url,
        body: {"lang": preferences.getString("lang")},
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseData);
        if (responseData["key"] == "success") {
          citiesModel = CitiesModel.fromJson(responseData);
          print("0000000000100100100101010010100101010");
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e) {
      print("fail 222222222   $e}");
    }
  }

  bool loading = true;
  HomeModel homeModel = HomeModel();
  Future getHome({int cityId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      loading = true;
    });
    final url = Uri.https(URL, "api/home");
    try {
      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${preferences.getString("token")}"},
        body: {
          "lang": preferences.getString("lang"),
          "city_id": cityId ==null ? preferences.getInt("cityId").toString():cityId.toString(),
          "device_type": Platform.isIOS ? "ios" : "android",
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw 'no internet please connect to internet';
      });
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() => loading = false);
        print(responseData);
        if (responseData["key"] == "success") {
          homeModel = HomeModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e");
      print("track $t");
    }
  }
}
