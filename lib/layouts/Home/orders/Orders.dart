import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/Visitor.dart';
import 'package:nava/helpers/providers/visitor_provider.dart';
import 'package:nava/layouts/Home/orders/FinishedOrders.dart';
import 'package:nava/layouts/Home/orders/ProcessingOredrs.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:provider/provider.dart';

import '../../../res.dart';

class Orders extends StatefulWidget {

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with TickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    VisitorProvider visitorProvider = Provider.of<VisitorProvider>(context,listen: false);

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primary,
          title: Text(tr("orders"),style: TextStyle(fontSize: 20),),
          elevation: 0,
          actions: [
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (c)=>ContactUs()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image(image: ExactAssetImage(Res.contactus),width: 26,),
              ),
            ),
          ],
        ),

        body:

        visitorProvider.visitor?

        Visitor()

            :
        ListView(
          children: [
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: MyColors.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)
                )
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: TabBar(
                    isScrollable: true,
                    labelStyle: GoogleFonts.almarai(fontSize: 15,fontWeight: FontWeight.bold),
                    unselectedLabelStyle: GoogleFonts.almarai(fontSize: 15,fontWeight: FontWeight.w400,),
                    indicatorWeight: 3,
                    indicatorColor: MyColors.black,
                    indicatorSize: TabBarIndicatorSize.label,

                    tabs: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: Center(child: Text(tr("processingOrders"),style: TextStyle(fontSize: 15,color: MyColors.black),))),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: Center(child: Text(tr("finishedOrders"),style:TextStyle(fontSize: 15,color: MyColors.black)))),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height*.77,
              child:
              TabBarView(
                children: <Widget>[
                  ProcessingOrders(),
                  FinishedOrders(),
                ],
              ),
            )

          ],
        ),

      ),
    );
  }
}
