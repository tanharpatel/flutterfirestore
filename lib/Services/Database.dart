import 'package:cloud_firestore/cloud_firestore.dart';

class CarDatabase {
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection("Cars");
  bool hasOwner;
  String isOwner, ownerName;

  void updateOwner(String name) async {
    FirebaseFirestore.instance.runTransaction((transaction) {
      return transaction.get(collectionReference.doc("Ferrari")).then((value) {
        transaction.update(collectionReference.doc("Ferrari"), {
          'HasOwner': true,
          'OwnerName': name,
        });
      });
    });
  }

  // Future updateOwner(String name) async {
  //   return await collectionReference.doc("Ferrari").set({
  //     'HasOwner': true,
  //     'OwnerName': name,
  //   });
  // }
}