import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/layouts/Home/Home.dart';
import 'package:http/http.dart' as http;

class VisaWebView extends StatefulWidget {
  final int orderId;

  const VisaWebView({Key key, this.orderId}) : super(key: key);

  @override
  _VisaWebViewState createState() => _VisaWebViewState();
}

class _VisaWebViewState extends State<VisaWebView> {

  GlobalKey<ScaffoldState> _scafold = new GlobalKey<ScaffoldState>();
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  DioBase dioBase = DioBase();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("----------------initState------------");
    flutterWebViewPlugin.close();
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      print("----------------on destroy------------");
    });
    // _onStateChanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
    //   print("----------------_onStateChanged------------");
    // });
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) async{
      if (mounted) {
        await getListenData(url);
        setState(() {visaUrl = url;});
        print("------------------------ onUrlChanged --------------------------");
        print("url: $url");
      }
    });
  }

  String visaUrl;
  Response payResponse;
  Future getListenData(String url) async {
    await dioBase.get(url).then((response) {
      print("test: $url");
      print("test: $response");
      // Fluttertoast.showToast(msg: tr("Something Went Wrong"));
      setState(() {
        payResponse = response;
      });
    }).then((value) {
      return payResponse.data["key"]=="success"?
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false)
          :payResponse.data["key"]=="fail"?
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false)
          :(){};
    });

    // payResponse.data["key"]=="success"?
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false)
    //     :payResponse.data["key"]=="fail"?
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false)
    //     :(){};
  }

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      WebviewScaffold(
      key: _scafold,
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        elevation: 0,
        title: Text(tr("visa"), style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false);
          },
        ),
      ),

        url: "https://navaservices.net/api/pay-visa?lang=ar&order_id=${widget.orderId}",

    );
  }
}
