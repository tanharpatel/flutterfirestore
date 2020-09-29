import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentDB {

  String uname;
  SharedPreferences username;
  
  initial() async {
    username = await SharedPreferences.getInstance();
    uname = username.getString('username');
    return uname;
  }
  
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection("Username");
  updateDueAmount(int newDueAmount) async {
    await FirebaseFirestore.instance.runTransaction((transaction) {
      return transaction.get(collectionReference.doc("Payment")).then((value) {
        transaction.update(collectionReference.doc("Payment"), {
          'dueAmount': newDueAmount,
        });
      });
    });
  }
}