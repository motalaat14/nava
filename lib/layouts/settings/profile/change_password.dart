import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/Badge.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/RichTextFiled.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  GlobalKey<ScaffoldState> _scaffold=new GlobalKey();
  GlobalKey<FormState> _formKey=new GlobalKey();
  TextEditingController pass=new TextEditingController();
  TextEditingController pass2=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      backgroundColor: MyColors.secondary,
      appBar: AppBar(
        backgroundColor: MyColors.white,
        title: Text(tr("changePass"),
          style: TextStyle(color: MyColors.primary, fontSize: 16),
        ),
        iconTheme: IconThemeData(color: MyColors.primary),
        // actions: [InkWell(
        //     onTap: (){
        //       Navigator.push(context, MaterialPageRoute(builder: (c)=>Notifications()));
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 10),
        //       child: Badge(
        //           value: "3",
        //           color: MyColors.red,
        //           child: IconButton(
        //             icon: Icon(
        //               Icons.notifications,
        //               color: MyColors.offPrimary,
        //               size: 28,
        //             ),
        //             onPressed: () {
        //               Navigator.push(context, MaterialPageRoute(builder: (c)=>Notifications()));
        //             },
        //           )),
        //     ),
        //   ),],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr("oldPass"),style: TextStyle(fontSize: 15,color: MyColors.grey),),
              RichTextFiled(
                controller: pass,
                label: tr("oldPass"),
                type: TextInputType.emailAddress,
                margin: EdgeInsets.only(top: 8,bottom: 10),
                action: TextInputAction.next,
              ),
              Text(tr("newPass"),style: TextStyle(fontSize: 15,color: MyColors.grey),),
              RichTextFiled(
                controller: pass2,
                label: tr("newPass"),
                type: TextInputType.emailAddress,
                margin: EdgeInsets.only(top: 8,bottom: 10),
                action: TextInputAction.next,
              ),
              Text(tr("confirmPass"),style: TextStyle(fontSize: 15,color: MyColors.grey),),
              RichTextFiled(
                controller: pass2,
                label: tr("confirmPass"),
                type: TextInputType.emailAddress,
                margin: EdgeInsets.only(top: 8,bottom: 10),
                action: TextInputAction.next,
              ),

              Spacer(),
              CustomButton(
                title: tr("confirm"),
                margin: EdgeInsets.symmetric(vertical: 0),
                onTap: (){},
              ),

            ],
          ),
        ),
      ),
    );
  }
}
