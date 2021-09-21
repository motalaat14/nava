import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/Loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

class RepeatedQuestions extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _RepeatedQuestionsState();
  }
}
class _RepeatedQuestionsState extends State<RepeatedQuestions>{


  @override
  void initState(){
    // getFQs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.white,
        title: Text(
          tr("popQuestions"),
          style: TextStyle(color: MyColors.primary, fontSize: 16),
        ),
        iconTheme: IconThemeData(color: MyColors.primary),
        actions: [
          // InkWell(
          //   onTap: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (c) => Notifications()));
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 10),
          //     child: Badge(
          //         value: "3",
          //         color: MyColors.red,
          //         child: IconButton(
          //           icon: Icon(
          //             Icons.notifications,
          //             color: MyColors.offPrimary,
          //             size: 28,
          //           ),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (c) => Notifications()));
          //           },
          //         )),
          //   ),
          // ),
        ],
      ),


      body: Column(
        children: [
          // loading ? Expanded(child: MyLoading()) :
          Container(
            height: MediaQuery.of(context).size.height-115,
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 6,
                itemBuilder: (c,i){
                  return InkWell(
                    onTap: (){
                      setState(() {
                        // fQsModel.data.fqs[i].open = !fQsModel.data.fqs[i].open;
                      });
                    },
                    child: questionItem(
                      question: "fQsModel.data.fqs[i].question",
                      answer: "fQsModel.data.fqs[i].answer",
                      open: true,
                    ),
                  );
                },
            ),
          ),
        ],
      ),
    );
  }

  Widget questionItem ({String question, answer, bool open}){
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: open ? MyColors.primary : MyColors.primary.withOpacity(.2),
              borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5)),
              border: Border.all(width: 1.5,color: MyColors.grey.withOpacity(.4))
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(question,style: TextStyle(color:open ? MyColors.white : MyColors.primary,fontSize: 15,fontWeight: FontWeight.bold),),
                  Icon(open ? Icons.expand_less : Icons.expand_more,color:open ? MyColors.white : MyColors.primary,),
                ],
              ),
            ),
          ),

          open ?
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
            // height: 80,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: MyColors.offWhite,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                border: Border.all(width: 1.5,color: MyColors.grey.withOpacity(.4))
            ),
            child: Text(answer,style: TextStyle(fontSize: 15,),),
          ):Container()



        ],
      ),
    );
  }




  // bool loading =true;
  // FQsModel fQsModel = FQsModel();
  // DioBase dioBase = DioBase();
  // Future getFQs() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   Map<String, String> headers = {
  //     "Authorization": "Bearer ${preferences.getString("token")}"
  //   };
  //   dioBase.get("sidePages?type=fqs", headers: headers).then((response) {
  //     if (response.data["key"] == "success") {
  //       setState(() {loading=false;});
  //       // fQsModel = FQsModel.fromJson(response.data);
  //     } else {
  //       EasyLoading.dismiss();
  //       print("------------------------else");
  //       Fluttertoast.showToast(msg: response.data["msg"]);
  //     }
  //   });
  // }



}