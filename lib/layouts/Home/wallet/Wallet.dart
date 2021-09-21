import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';

import '../../../res.dart';

class Wallet extends StatefulWidget {

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.greyWhite,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              title: Text(tr("wallet"), style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
              // leading: IconButton(
              //   icon: Icon(Icons.arrow_back_ios),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // ),
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
      
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 15),
        children: [
          Image(
            image: ExactAssetImage(Res.wallet3),
            height: 200,
          ),
          Center(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(tr("currentBalance"),style: TextStyle(fontSize: 18),),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("275",style: TextStyle(fontSize: 80,fontWeight: FontWeight.bold,color: MyColors.primary),),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr("r"),style: TextStyle(fontSize: 18),),
                      Text(tr("s"),style: TextStyle(fontSize: 18),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
              title: tr("chargeBalance"),
              margin: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              onTap: (){},
          )

        ],
      ),
    );
  }
}
