import 'package:cloud_firestore/cloud_firestore.dart';

class CarDB {
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection("Cars");
  updateOwner(String name) async {
    await FirebaseFirestore.instance.runTransaction((transaction) {
      return transaction.get(collectionReference.doc("Ferrari")).then((value) {
        transaction.update(collectionReference.doc("Ferrari"), {
          'HasOwner': true,
          'OwnerName': name,
        });
      });
    });
  }
}