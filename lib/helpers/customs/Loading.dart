import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nava/helpers/constants/MyColors.dart';

class MyLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: SpinKitDualRing(color: MyColors.accent, size: 30.0)),
          Text(tr("loading")),
        ],
      ),
    );
  }
}
