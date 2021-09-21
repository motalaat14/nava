import 'package:flutter/material.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';

class DeptDetails extends StatefulWidget {
  final int id;
  final String name,img;

  const DeptDetails({Key key, this.id, this.name, this.img}) : super(key: key);

  @override
  _DeptDetailsState createState() => _DeptDetailsState();
}

class _DeptDetailsState extends State<DeptDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.name),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Image(image: ExactAssetImage(widget.img)),
          ),
        ],
      ),


      body: Column(
        children: [
          AppBarFoot(),


          Container(
            height: MediaQuery.of(context).size.height*.88,
            child: ListView.builder(
              itemCount: 6,
                itemBuilder: (c,i){
                  return Column(
                    children: [
                      deptItem(
                        img: "https://thumbs.dreamstime.com/z/cartoon-electrician-cable-man-front-switchboard-composition-professional-flat-male-character-173566076.jpg",
                        title: "لوحات الكهرباء الرئيسية"
                      ),
                      Divider(),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }


Widget deptItem ({img,title}){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70,height: 75,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: NetworkImage(img),fit: BoxFit.cover)
            ),
          ),
          Text(title,style: TextStyle(fontSize: 18),)
        ],
      ),
    );
}

}
