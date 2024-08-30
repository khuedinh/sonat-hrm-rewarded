import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  const NoData({super.key, this.message = "No data found."});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.folder_off),
        Text(message),
      ]),
    );
  }
}
