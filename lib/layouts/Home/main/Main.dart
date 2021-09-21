import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/RichTextFiled.dart';
import 'package:nava/layouts/Home/main/DeptDetails.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import '../../../res.dart';


class Main extends StatefulWidget {

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  TextEditingController search = TextEditingController();
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
                  padding: const EdgeInsets.symmetric(vertical:8),
                  child: Row(
                    children: [
                      Text("${tr("welcome")} , ",style: TextStyle(fontSize: 16),),
                      Text("طلعت",style: TextStyle(fontSize: 16),),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text("الرياض",style: TextStyle(fontSize: 12),),
                    Icon(Icons.expand_more),
                  ],
                ),
              ],
            ),
          ),
          centerTitle: false,
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
      ),

      body: NestedScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        controller: ScrollController(keepScrollOffset: true),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                  [
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
                              Container(
                                height: 140,
                                child: Swiper(
                                  duration: 1000,
                                  autoplay: true,
                                  itemCount: 3,
                                  fade: .6,
                                  viewportFraction: .86,

                                  scrollDirection: Axis.horizontal,
                                  pagination: SwiperPagination(alignment: Alignment.bottomCenter,),
                                  scale: .95,
                                  itemBuilder: (c,i) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(width: .2,color: MyColors.accent),
                                        color: MyColors.accent.withOpacity(.1),
                                        image: DecorationImage(
                                            image: NetworkImage("https://image.freepik.com/free-vector/service-team-flat-illustration_159757-46.jpg"),
                                            fit: BoxFit.cover
                                        ),
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
                  ]
              ),
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
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                  ),
                ),
                RichTextFiled(
                  margin: EdgeInsets.symmetric(horizontal: 30,vertical: 8),
                  height: 45,
                  icon: Icon(Icons.search),
                  controller: search,
                  label: tr("searchWord"),
                  labelColor: MyColors.grey,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top:2),
              height: MediaQuery.of(context).size.height-245,
              color: MyColors.secondary,
              child: GridView.builder(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.symmetric(horizontal: 15),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 8/9,
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: 10,
                itemBuilder: (c,i){
                  return serviceItem(
                    id: 1,
                    img: Res.electric,
                    backImg: Res.energy,
                    title: "كهرباء",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceItem({int id,String img,backImg,title}){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (c)=>DeptDetails(id: id,name: title,img:img)));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
        child: Container(

          child: Stack(
            children: [

              Container(
                // width: 100,
                // height: 100,
                margin: EdgeInsets.all(50),
                decoration: BoxDecoration(
                    image: DecorationImage(image: ExactAssetImage(backImg))
                ),
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
                            child: Image(image: ExactAssetImage(img),width: 50,),
                          ),
                          Container(),
                        ],
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(title,style: TextStyle(fontSize: 19),),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}
