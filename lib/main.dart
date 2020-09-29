import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfirestore/Screens/Home.dart';
import 'package:flutterfirestore/Screens/Login.dart';
import 'package:flutterfirestore/Screens/Select.dart';
import 'package:flutterfirestore/Screens/Success.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String uname;
  SharedPreferences username;
  
  @override
  void initState() {
    checkIfAlreadyLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Login.id,
      routes: {
        Login.id: (context) => Login(),
        Select.id: (context) => Select(),
        Home.id: (context) => Home(),
        Success.id: (context) => Success(),
      }
    );
  }

  void checkIfAlreadyLogin() async {
    username = await SharedPreferences.getInstance();
    bool newuser = (username.getBool('login') ?? true);
    uname = username?.getString('uname');
    if(newuser == false) {
      Navigator.pushReplacementNamed(context, Select.id);
    } else {
      Navigator.pushReplacementNamed(context, Login.id);
    }
  }
}