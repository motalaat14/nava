import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdi/mdi.dart';
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/LoadingDialog.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/InkWellTextField.dart';
import 'package:nava/helpers/customs/LabelTextField.dart';
import 'package:nava/helpers/models/RegionsModel.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../res.dart';
import 'DetailedBill.dart';
import 'MapScreen.dart';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava/helpers/constants/base.dart';
import 'package:http/http.dart' as http;

class Address extends StatefulWidget {
  final int orderId;

  const Address({Key key, this.orderId}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  GlobalKey<FormState> _formKey=new GlobalKey();
  TextEditingController date=new TextEditingController();
  TextEditingController time=new TextEditingController();
  TextEditingController mapAddress=new TextEditingController();
  TextEditingController neighbor=new TextEditingController();
  TextEditingController street=new TextEditingController();
  TextEditingController house=new TextEditingController();
  TextEditingController floor=new TextEditingController();
  TextEditingController notes=new TextEditingController();

  @override
  void initState() {
    getRegions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              title: Text(tr("address"), style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
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
            AppBarFoot(),
          ],
        ),
      ),

      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(tr("date"),),
                ),
                InkWellTextField(
                  controller: date,
                  label: myDate??tr("selectDate"),
                  icon: Icon(CupertinoIcons.calendar,color: MyColors.accent,size: 26,),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  onTab: (){
                    showDatePicker();
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(tr("time"),),
                ),
                InkWellTextField(
                  controller: time,
                  label: myTime??tr("selectTime"),
                  icon: Icon(CupertinoIcons.time,color: MyColors.accent,size: 26,),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  onTab: (){
                    openTimePicker();
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(tr("mapAddress"),),
                ),
                InkWellTextField(
                  controller: mapAddress,
                  label: address ?? tr("mapAddress"),
                  icon: Icon(Mdi.mapMarkerRadiusOutline,color: MyColors.accent,size: 26,),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  onTab: (){
                    goToLocationScreen();
                    print("-----> Receipt Address");
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(tr("neighbor"),),
                ),
                InkWellTextField(
                  controller: neighbor,
                  label: selectedNeighbor ?? tr("neighbor"),
                  icon: Icon(Icons.expand_more,color: MyColors.accent,size: 30,),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  onTab: (){
                    openNeighbors();
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(tr("street"),),
                ),
                LabelTextField(
                  controller: street,
                  label: tr("street"),
                  action: TextInputAction.next,
                  margin: EdgeInsets.symmetric(vertical: 8),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(tr("house"),),
                ),
                LabelTextField(
                  controller: house,
                  label: tr("house"),
                  action: TextInputAction.next,
                  margin: EdgeInsets.symmetric(vertical: 8),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(tr("floor"),),
                ),
                LabelTextField(
                  controller: floor,
                  label: tr("floor"),
                  action: TextInputAction.next,
                  type: TextInputType.number,
                  margin: EdgeInsets.symmetric(vertical: 8),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(tr("notes"),),
                ),
                LabelTextField(
                  controller: notes,
                  label: tr("notes"),
                  action: TextInputAction.done,
                  lines: 5,
                  margin: EdgeInsets.symmetric(vertical: 8),
                ),
                CustomButton(
                  title: tr("continue"),
                  margin: EdgeInsets.symmetric(vertical: 15),
                  onTap: (){
                    addAddressNotes();
                  },
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }

  List<dynamic> result = List();
  String address ;
  double lat, lng ;

  Future goToLocationScreen() async {
    result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => MapScreen()));
    setState(() {
      address = result[0];
      lat = result[1];
      lng = result[2];
    });
  }

  DateTime selectedDate;
  String myDate;
  final f = new DateFormat('yyyy-MM-dd');
  showDatePicker() {
    return showDialog(
      context: context,
      builder: (c) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primary,
              onPrimary: MyColors.white,
              surface: MyColors.black,
              onSurface: MyColors.black,
            ),
            dialogBackgroundColor:MyColors.white,
          ),
          child: DatePickerDialog(
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year +1),
          ),
        );
      },
    ).then((pickedDate) {
      setState(() {
        selectedDate = pickedDate;
        myDate = f.format(pickedDate);
      });
    });
  }

  TimeOfDay lateTime;
  String myTime;
  openTimePicker() {
    return showDialog(
      context: context,
      barrierColor: MyColors.offPrimary.withOpacity(.1),
      builder: (c) {
        return TimePickerTheme(
            data: TimePickerThemeData(
                backgroundColor: MyColors.white,
                dayPeriodTextColor: MyColors.black,
                helpTextStyle: TextStyle(color: MyColors.primary),
                dialTextColor: MyColors.primary,
                dialBackgroundColor: MyColors.accent,
                dialHandColor: MyColors.white
            ),
            child: TimePickerDialog(
              initialTime: TimeOfDay.now(),
              initialEntryMode: TimePickerEntryMode.dial,
            )
        );
      },
    ).then((pickedTime) {
      setState(() {
        lateTime = pickedTime;
        myTime = pickedTime.format(context);
      });
    });
  }

  String selectedNeighbor;
  String selectedRegionId;
  openNeighbors(){
    return showCupertinoModalPopup(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Center(
              child: Text(tr("selectRegion"),style: GoogleFonts.almarai(fontSize: 18,color: MyColors.offPrimary,fontWeight: FontWeight.bold),)),
          actions: <Widget>[
            Container(
              height: 300,
              child: regionsModel.data == null
                  ? Center(
                child: Text(tr("noCites"),),
              )
                  : ListView.builder(
                itemCount:
                regionsModel.data.length,
                itemBuilder: (c, i) {
                  return Column(
                    children: [
                      FlatButton(
                        child: Text(regionsModel.data[i].title),
                        onPressed: () {
                          setState(() {
                            selectedNeighbor = regionsModel.data[i].title;
                            selectedRegionId = regionsModel.data[i].id.toString();
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      Divider(
                        height: 0,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  RegionsModel regionsModel = RegionsModel();
  Future getRegions() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.https(URL, "api/regions");
    print(preferences.getString("lang"));

    try {
      final response = await http.post(url,
        body: {
          "lang": preferences.getString("lang"),
          "city_id": preferences.getInt("cityId").toString(),
        },
      ).timeout(Duration(seconds: 10), onTimeout: () =>throw 'no internet please connect to internet');
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseData);
        if (responseData["key"] == "success") {
          regionsModel = RegionsModel.fromJson(responseData);
        } else {
          Fluttertoast.showToast(msg: responseData["msg"]);
        }
      }
    } catch (e, t) {
      print("error $e" + " ==>> track $t");
    }
  }

  DioBase dioBase = DioBase();
  Future addAddressNotes() async {
    LoadingDialog.showLoadingDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, String> headers = {"Authorization": "Bearer ${preferences.getString("token")}"};
    FormData bodyData = FormData.fromMap({
      "lang": preferences.getString("lang"),
      "order_id": widget.orderId.toString(),
      "date":myDate,
      "time":lateTime!=null?"${lateTime.hour}:${lateTime.minute}:00":null,
      "lat":lat.toString(),
      "lng":lng.toString(),
      "address":address,
      "region_id":selectedRegionId,
      "floor":floor.text,
      "residence":house.text,
      "street":street.text,
      "address_notes":notes.text==""?null:notes.text,
    });
    dioBase.post("addDateAndAddress", body: bodyData, headers: headers)
        .then((response) {
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        if (response.data["key"] == "success") {
          Navigator.of(context).push(MaterialPageRoute(builder: (c)=>DetailedBill(orderId: widget.orderId,)));
          Fluttertoast.showToast(msg: response.data["msg"]);
          print("---------------------------------------successsuccess");
        } else {
          EasyLoading.dismiss();
          print("---------------------------------------else else");
          Fluttertoast.showToast(msg: response.data["msg"]);
        }
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
          msg: response.data["msg"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    });
  }

}