import 'package:flutter/material.dart';
import 'package:flutterfirestore/Components/RaisedBtn.dart';
import 'package:flutterfirestore/Screens/Home.dart';
import 'package:flutterfirestore/Screens/Login.dart';
import 'package:flutterfirestore/Screens/Payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Select extends StatefulWidget {
  static final String id = "Select";

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  SharedPreferences username;
  String uname;

  @override
  void initState() {
    initial();
    super.initState();
  }

  initial() async {
    username = await SharedPreferences.getInstance();
    uname = username.getString('username');
    return uname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Firestore"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              username?.setString('username', null);
              username?.setBool('login', true);
              Navigator.popAndPushNamed(context, Login.id);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          kRaisedButton(MediaQuery.of(context).size.width*0.3, "Buy Car", (){
            Navigator.of(context).pushNamed(Home.id);
          }),
          kRaisedButton(MediaQuery.of(context).size.width*0.5, "Pay Amount", (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Payment(name: uname)));
          }),
        ],
      ),
    );
  }
}