import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/RichTextFiled.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';

import '../../../res.dart';
import '../Home.dart';

class RejectReason extends StatefulWidget {

  @override
  _RejectReasonState createState() => _RejectReasonState();
}

class _RejectReasonState extends State<RejectReason> {
  GlobalKey<FormState> _formKey = new GlobalKey();
  TextEditingController _reason = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.greyWhite,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              backgroundColor: MyColors.primary,
              elevation: 0,
              title: Text(tr("rejectReason"), style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            RichTextFiled(
              height: MediaQuery.of(context).size.height*.6,
              max: 500,
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              controller: _reason,
              label: tr("writeRejectReason"),
              labelColor: MyColors.grey,
              type: TextInputType.text,
            ),

            CustomButton(
              margin: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
              title: tr("send"),
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false);
              },
            ),

          ],
        ),
      ),

    );
  }
}
