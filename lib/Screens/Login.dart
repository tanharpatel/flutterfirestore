import 'package:flutter/material.dart';
import 'package:flutterfirestore/Screens/Select.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static final String id = "Login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String name, uname;
  SharedPreferences username;

  @override
  void initState() {
    checkIfAlreadyLogin();
    super.initState();
  }

  void checkIfAlreadyLogin() async {
    username = await SharedPreferences.getInstance();
    bool newuser = (username.getBool('login') ?? true);
    uname = username?.getString('uname');
    if(newuser == false) {
      Navigator.pushReplacementNamed(context, Select.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buy Car"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {name = value;},
              decoration: InputDecoration(
                hintText: "Enter Your Name"
              ),
            ),
            RaisedButton(
              child: Text("Login"),
              onPressed: () {
                setUname();
                Navigator.popAndPushNamed(context, Select.id);
              }
            ),
          ],
        ),
      ),
    );
  }

  setUname() async {
    SharedPreferences username = await SharedPreferences.getInstance();
    username.setString('username', name);
    username.setBool('login', false);
  }
}