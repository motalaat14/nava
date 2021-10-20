import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';

import '../../../res.dart';

class DetailedBill extends StatefulWidget {
  @override
  _DetailedBillState createState() => _DetailedBillState();
}

class _DetailedBillState extends State<DetailedBill> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              title: Text(tr("detailedBill"), style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("رقم الطلب",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Text("1237550",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          Divider(thickness: .5,color: MyColors.black,),

          Divider(thickness: .5,color: MyColors.black,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("كهرباء",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Image(image: ExactAssetImage(Res.energy),height: 30,color: MyColors.black,)
              ],
            ),
          ),
          Divider(thickness: .5,color: MyColors.black,),
          InkWell(
            onTap: (){
              MapsLauncher.launchCoordinates(24.69, 46.75);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tr("address"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  Text("عرض الخريطة",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*.3,
            decoration: BoxDecoration(
                border: Border.all(color: MyColors.offPrimary,width: 1)
            ),
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(24.69, 46.75),
                zoom: 11,
              ),
              markers: Set<Marker>.of(markers.values),
            ),
          ),
          Divider(thickness: .5,color: MyColors.black,),
          Padding(
            padding: const EdgeInsets.only(bottom: 15,top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(tr("address"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: MyColors.offPrimary),),
                ),
                Row(
                  children: [
                    Text("الحي : ",style: TextStyle(fontSize: 15),),
                    Text("المروة",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Text("الشارع : ",style: TextStyle(fontSize: 15),),
                      Text("عبد العزيز",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text("المنزل : ",style: TextStyle(fontSize: 15),),
                    Text("23",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Text("الدور : ",style: TextStyle(fontSize: 15),),
                      Text("4",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text("ملاحظات إضافية : ",style: TextStyle(fontSize: 15),),
                    Text("بجوار البيك",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  ],
                ),
              ],
            ),
          ),
          Divider(thickness: .5,color: MyColors.black,),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text("تفاصيل الخدمة",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: MyColors.offPrimary),),
          ),
          Container(
            height: 140*2.0,
            child: ListView.builder(
                itemCount: 2,
                itemBuilder: (c,i){
                  return serviceItem(
                    img: "https://www.ctrmcloud.com/wp-content/uploads/2021/07/Blog-Image.jpg",
                    title: "اسم الخدمة",
                    subTitle: "اسم الخدمة طلب معاينة",
                    price: "120",
                  );
                }),
          ),
          Divider(thickness: .5,color: MyColors.black,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tr("vat"),style: TextStyle(fontSize: 16),),
                Row(
                  children: [
                    Text("85",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    Text(tr("rs"),style: TextStyle(fontSize: 14,color: MyColors.grey),),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tr("total"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                Row(
                  children: [
                    Text("1025",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    Text(tr("rs"),style: TextStyle(fontSize: 14,color: MyColors.grey),),
                  ],
                ),
              ],
            ),
          ),
          Divider(thickness: .5,color: MyColors.black,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tr("payWay"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                Text("فيزا",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              ],
            ),
          ),

          CustomButton(
            margin: EdgeInsets.symmetric(vertical: 25),
            title: tr("payBell"),
            onTap: (){
              // Navigator.of(context).push(MaterialPageRoute(builder: (c)=>Pay()));
            },
          ),
        ],
      ),
    );
  }


  Widget serviceItem({String img,title,subTitle,price}){
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      width: MediaQuery.of(context).size.width,
      // height: 150,
      decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all()
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 55,height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(),
                    image: DecorationImage(image: NetworkImage(img),fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(subTitle,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: MyColors.primary),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tr("price"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                Row(
                  children: [
                    Text(price,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    Text(tr("rs"),style: TextStyle(fontSize: 14,color: MyColors.grey),),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  void _add() {
    var markerIdVal = "1";
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(24.69, 46.75),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {},
    );
    setState(() {
      markers[markerId] = marker;
    });
  }
}
