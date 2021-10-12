import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';

import '../../../res.dart';

class Notifications extends StatefulWidget {

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              title: Text(tr("noti"), style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
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

      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15),
          itemCount: 17,
          itemBuilder: (c,i){
            return notificationItem(title: "اشعار جديد جدا اشعار من الادارة", time: "منذ ١٥ دقيقة");
          }),
    );
  }

  Widget notificationItem({String title,time}){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: MyColors.offWhite,
          border: Border.all(color: MyColors.accent,width: 1),
          borderRadius: BorderRadius.circular(15)
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 1,color: MyColors.grey),
              image: DecorationImage(image: ExactAssetImage(Res.logo,scale: 15)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: TextStyle(fontSize: 16,color: MyColors.offPrimary,fontWeight: FontWeight.bold),),
              Text(time,style: TextStyle(fontSize: 12,color: MyColors.grey,fontWeight: FontWeight.bold),),
            ],
          ),
        ],
      ),
    );
  }
}
