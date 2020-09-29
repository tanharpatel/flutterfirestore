import 'package:flutter/material.dart';

class Success extends StatelessWidget {
  static final String id = "Success";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buy Car"),),
      body: Center(child: Text("Payment Successful!!!"),),
    );
  }
}