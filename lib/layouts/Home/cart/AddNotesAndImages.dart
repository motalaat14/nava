import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/LoadingDialog.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/AppBarFoot.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/LabelTextField.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res.dart';

class AddNotesAndImages extends StatefulWidget {
  final int id;

  const AddNotesAndImages({Key key, this.id}) : super(key: key);

  @override
  _AddNotesAndImagesState createState() => _AddNotesAndImagesState();
}

class _AddNotesAndImagesState extends State<AddNotesAndImages> {
  TextEditingController _notes = new TextEditingController();
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
              title: Text(tr("addNotesAndImages"), style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal)),
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

      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr("notes"),),
            LabelTextField(
              margin: EdgeInsets.only(top: 5),
              label: tr("enterNotes"),
              type: TextInputType.text,
              lines: 22,
              controller: _notes,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  addItem(
                    title: imageFile!=null ?tr("imageAdded") :tr("addImage"),
                    icon: Icons.camera_enhance,
                    onTap: (){
                      _openImagePicker(context);
                    }
                  ),
                  addItem(
                      title: audioPath !=null ? tr("voiceAdded"):tr("addVoice"),
                      icon: Icons.mic,
                    onTap: (){
                      getAudio();
                    }
                  ),
                  addItem(
                      title: videoFile!=null ?tr("videoAdded") :tr("addVid"),
                      icon: Icons.videocam,
                    onTap: (){
                      _openVideoPicker(context);
                    }
                  ),
                ],
              ),
            ),
            Spacer(),
            CustomButton(
              margin: EdgeInsets.symmetric(vertical: 20),
              title: tr("continueOrder"),
              onTap: () {
                if(_notes.text!=""){
                  addNotes();
                }else{
                  Fluttertoast.showToast(msg: tr("plzAddNotes"));
                }
              },
            ),
          ],
        ),
      ),

    );
  }

  Widget addItem({String title, IconData icon,Function onTap}){
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,height: 60,
            decoration: BoxDecoration(
              color: MyColors.primary,
              border: Border.all(),
              borderRadius: BorderRadius.circular(50)
            ),
            child: Icon(icon,size: 30,),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(title,style: TextStyle(fontSize: 13),),
          ),
        ],
      ),
    );
  }

  File imageFile;
  final picker = ImagePicker();
  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
  }
  void _openImagePicker(BuildContext context) {
    print("-------------_openImagePicker");
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(10.0),
          child: CupertinoActionSheet(
            cancelButton: CupertinoButton(
              child: Text(tr("cancel"),
                  style: TextStyle(
                    fontSize: 18,
                  )),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tr("selectImg"),
                      style: TextStyle(
                        fontSize: 18,
                        color: MyColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              FlatButton(
                child: Text(
                  tr("fromCam"),
                ),
                onPressed: () {
                  getImage(ImageSource.camera);
                },
              ),
              FlatButton(
                child: Text(tr("fromGallery")),
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  String audioPath;
  FilePickerResult filePickerResult;
  getAudio() async {
    filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    ).then((value) {
      setState(() {
        audioPath = value.names[0];
        // audioFile = value.files[0];
      });
      return value;
    });
    // String fileName = fil.path.split('/').last;
  }

  File videoFile;
  final videoPicker = ImagePicker();
  Future getVideo(ImageSource source) async {
    final pickedFile = await videoPicker.getVideo(source: source);
    setState(() {
      if (pickedFile != null) {
        videoFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
  }
  void _openVideoPicker(BuildContext context) {
    print("-------------_openVideoPicker");
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(10.0),
          child: CupertinoActionSheet(
            cancelButton: CupertinoButton(
              child: Text(tr("cancel"),
                  style: TextStyle(
                    fontSize: 18,
                  )),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tr("selectImg"),
                      style: TextStyle(
                        fontSize: 18,
                        color: MyColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              FlatButton(
                child: Text(
                  tr("fromCam"),
                ),
                onPressed: () {
                  getVideo(ImageSource.camera);
                },
              ),
              FlatButton(
                child: Text(tr("fromGallery")),
                onPressed: () {
                  getVideo(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  DioBase dioBase = DioBase();
  Future addNotes() async {
    LoadingDialog.showLoadingDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, String> headers = {"Authorization": "Bearer ${preferences.getString("token")}"};
    print("----------audio > $filePickerResult");
    print(" ----------image > $imageFile");
    print(" ----------video > $videoFile");
    FormData bodyData = FormData.fromMap({
      "lang": preferences.getString("lang"),
      "notes": _notes.text,
      "order_id": "${widget.id}",
      "image": imageFile == null ? null : MultipartFile.fromFileSync(imageFile.path,
          filename: "${imageFile.path.split('/').last}"),
      "audio": filePickerResult == null ? null : MultipartFile.fromFileSync(filePickerResult.paths[0],
          filename: "${filePickerResult.paths[0].split('/').last}"),
      "video": videoFile == null ? null : MultipartFile.fromFileSync(videoFile.path,
          filename: "${videoFile.path.split('/').last}"),
    });
    dioBase.post("addNotesAndImage", body: bodyData, headers: headers)
        .then((response) {
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        if (response.data["key"] == "success") {
          Fluttertoast.showToast(msg: response.data["msg"]);
          showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Icon(
                    CupertinoIcons.checkmark_seal,
                    color:MyColors.primary,
                    size: 50,
                  ),
                  content: Column(
                    children: [
                      Text(tr("cong"),),
                      Text(tr("notesAddedSuc"),),
                    ],
                  ),
                  actions: [
                    CustomButton(title: "continueOrder", onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    })
                  ],

                );
              });
          print("---------------------------------------successsuccess");
        } else {
          EasyLoading.dismiss();
          print("---------------------------------------else else");
          Fluttertoast.showToast(msg: response.data["msg"]);
        }
      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
          msg: response.data["msg"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    });
  }


}
