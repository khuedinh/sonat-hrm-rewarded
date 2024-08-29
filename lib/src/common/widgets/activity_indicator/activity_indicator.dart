import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityIndicator extends StatelessWidget {
  final double? radius;

  const ActivityIndicator({
    super.key,
    this.radius,
  });

  buildAndroidWidget() {
    return SizedBox(
      height: radius,
      width: radius,
      child: const CircularProgressIndicator(),
    );
  }

  buildIOSWidget() {
    return CupertinoActivityIndicator(
      radius: radius ?? 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? buildAndroidWidget() : buildIOSWidget();
  }
}
