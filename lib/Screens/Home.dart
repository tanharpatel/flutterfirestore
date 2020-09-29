import 'package:flutter/material.dart';
import 'package:flutterfirestore/Screens/Login.dart';
import 'package:flutterfirestore/Services/CarDB.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  static final String id = "Home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String ownerName, enteredName, uname;
  bool hasOwner, isOwner;
  CarDB db = CarDB();
  SharedPreferences username;
  TextEditingController ownerNameCtrl = TextEditingController();

  @override
  void initState() {
    initial();
    getOwner();
    getAvailability();
    super.initState();
  }

  initial() async {
    username = await SharedPreferences.getInstance();
    uname = username.getString('username');
    return uname;
  }

  getOwner() async {
    db.collectionReference.doc("Ferrari").get().then((value) {
      setState(() {
        ownerName = value.data()["OwnerName"];
      });
    });
    return ownerName;
  }

  getAvailability() async {
    db.collectionReference.doc("Ferrari").get().then((value) {
      setState(() {
        hasOwner = value.data()["HasOwner"];
      });
    });
    return hasOwner;
  }

  @override
  Widget build(BuildContext context) {
    if(hasOwner == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Buy Car"),),
        body: SafeArea(
          child: Center(child: Container(child: CircularProgressIndicator(),)),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("Buy Car"),),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hasOwner ? Container() : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: ownerNameCtrl,
                    onChanged: (value) {enteredName = value;},
                    decoration: InputDecoration(
                      hintText: "Enter New Owner Name",
                    ),
                  ),
                  RaisedButton(
                    child: Text("Submit"),
                    onPressed: () {
                      db.updateOwner(enteredName);
                      ownerNameCtrl.clear();
                    }
                  ),
                ],
              ),
              hasOwner && uname == ownerName ? Text("You are the Owner.") : hasOwner ? Text("The car is sold.") : Text(""),
            ],
          ),
        ),
      );
    }
  }
}