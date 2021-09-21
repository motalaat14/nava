import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/layouts/Home/orders/OrderDetails.dart';

class ProcessingOrders extends StatefulWidget {

  @override
  _ProcessingOrdersState createState() => _ProcessingOrdersState();
}

class _ProcessingOrdersState extends State<ProcessingOrders> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15),
          itemCount: 6,
          itemBuilder: (c,i){
            return orderItem(
                id: 1,
                title: "اناره",
                orderNum: "1266750",
                price: "245",
                status: "لديك فاتورة جدبدة"
            );
        }),
    );
  }


  Widget orderItem({int id , String title,status,price , orderNum}){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (c)=>OrderDetails()));
      },
      child: Container(
        margin: EdgeInsets.only(top: 5),
        child: Card(
          elevation: 6,
          color: MyColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: BorderSide(color: Colors.grey, width: 1),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(8),
                        width: 50,height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: MyColors.grey),
                          image: DecorationImage(image: NetworkImage("https://png.pngtree.com/element_our/20200702/ourlarge/pngtree-cartoon-light-bulb-image_2296728.jpg")),
                        ),
                      ),
                      Text(title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(status,style: TextStyle(fontSize: 12,color: MyColors.green)),
                  ),

                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr("totalPrice"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: MyColors.offPrimary)),

                    Row(
                      children: [
                        Text(price,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: MyColors.offPrimary),),
                        Text(tr("rs"),style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: MyColors.grey),),
                      ],
                    ),

                  ],
                ),
              ),

              Divider(thickness: 1,height: 2,color: MyColors.grey,indent: 8,endIndent: 8,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr("orderNum"),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: MyColors.offPrimary)),
                    Text(orderNum,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: MyColors.offPrimary),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
