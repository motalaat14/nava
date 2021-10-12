import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/Badge.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/RichTextFiled.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';

import '../../../res.dart';
import 'change_password.dart';

class Profile extends StatefulWidget {
  final String name,phone,email,img;

  const Profile({Key key, this.name, this.phone, this.email, this.img}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  GlobalKey<ScaffoldState> _scaffold=new GlobalKey();
  GlobalKey<FormState> _formKey=new GlobalKey();
  TextEditingController name=new TextEditingController();
  TextEditingController phone=new TextEditingController();
  TextEditingController mail=new TextEditingController();
  String img;

  initInfo(){
    name.text= widget.name;
    phone.text= widget.phone;
    mail.text= widget.email;
    img= widget.img;
  }

  @override
  void initState() {
    initInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      backgroundColor: MyColors.secondary,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              title: Text(tr("profile"), style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
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
      body: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                            color: MyColors.primary.withOpacity(.2),
                            borderRadius: BorderRadius.circular(100),
                            border:Border.all(width: 2,color: MyColors.primary),
                            image: DecorationImage(image: NetworkImage(img))
                        ),
                      ),
                      Container(
                        width: 30,
                        height:30,
                        decoration: BoxDecoration(
                            color: MyColors.primary,
                            borderRadius: BorderRadius.circular(50),
                            border:Border.all(width: 1,color: MyColors.primary)
                        ),
                        child: Icon(Icons.camera_alt_outlined,size: 20,color: MyColors.white,),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr("name"),style: TextStyle(fontSize: 15,color: MyColors.grey),),
                        RichTextFiled(
                          controller: name,
                          label: tr("name"),
                          type: TextInputType.emailAddress,
                          margin: EdgeInsets.only(top: 8,bottom: 10),
                          action: TextInputAction.next,
                        ),
                        Text(tr("mail"),style: TextStyle(fontSize: 15,color: MyColors.grey),),
                        RichTextFiled(
                          controller: mail,
                          label: tr("mail"),
                          type: TextInputType.emailAddress,
                          margin: EdgeInsets.only(top: 8,bottom: 10),
                          action: TextInputAction.next,
                        ),
                        Text(tr("phone"),style: TextStyle(fontSize: 15,color: MyColors.grey),),
                        RichTextFiled(
                          controller: phone,
                          label: tr("phone"),
                          type: TextInputType.emailAddress,
                          margin: EdgeInsets.only(top: 8,bottom: 10),
                          action: TextInputAction.next,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Column(
                children: [
                  CustomButton(
                    title: tr("changePass"),
                    textColor: MyColors.primary,
                    margin: EdgeInsets.symmetric(vertical: 0),
                    color: MyColors.white,
                    borderColor: MyColors.primary,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>ChangePassword()));
                    },
                  ),
                  CustomButton(
                    title: tr("saveChanges"),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
