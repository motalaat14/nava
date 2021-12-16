import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nava/helpers/constants/DioBase.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/layouts/Home/Home.dart';

class MadaWebView extends StatefulWidget {
  final int orderId;

  const MadaWebView({Key key, this.orderId}) : super(key: key);

  @override
  _MadaWebViewState createState() => _MadaWebViewState();
}

class _MadaWebViewState extends State<MadaWebView> {

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
    flutterWebViewPlugin.close();
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {});
    _onStateChanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {});
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) async{
      if (mounted) {
        await getListenData(url);
        // payResponse.data["key"]=="success"?
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false)
        //     :payResponse.data["key"]=="fail"?
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false)
        //     :(){};
        print("✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔77");
        print("url: $url");
      }
    });
  }

  Response payResponse ;
  Future getListenData(String url) async {
    await dioBase.get(url).then((response) {
      print("test: $url");
      print("test: $response");
      Fluttertoast.showToast(msg: response.data["msg"]);
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
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      key: _scafold,
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        elevation: 0,
        title: Text(tr("mada"), style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false);
          },
        ),
      ),

      url: "https://navaservices.net/api/pay-mada?lang=ar&order_id=${widget.orderId}",

    );
  }
}
