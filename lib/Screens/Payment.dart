import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirestore/Components/RaisedBtn.dart';
import 'package:flutterfirestore/Components/TextField.dart';
import 'package:flutterfirestore/Screens/Success.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget {
  final String name;
  Payment({@required this.name});
  static final String id = "Payment";
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int amount, dueAmount, amountToPay;
  FocusNode paymentFN = FocusNode();
  Razorpay _razorpay;
  CollectionReference collectionReference;

  @override
  void initState() {
    collectionReference = FirebaseFirestore.instance.collection(widget.name);
    getDueAmount();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  getDueAmount() async {
    collectionReference.doc("Payment").get().then((value) {
      setState(() {
        dueAmount = value.data()["dueAmount"];
      });
    });
    return dueAmount;
  }

  @override
  Widget build(BuildContext context) {
    if(dueAmount == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Payment"),),
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("Payment"),),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Due amount is: $dueAmount"),
                SizedBox(height: 20,),
                kTextField("Enter Amount", Icon(Icons.payment), paymentFN, TextInputType.number, (value){amount = int.parse(value);}),
                SizedBox(height: 20,),
                kRaisedButton(MediaQuery.of(context).size.width*0.3, "Pay Now", (){proceedPayment();}),
              ],
            ),
          ),
        ),
      );
    }
  }

  void proceedPayment() async {
    amountToPay = amount ?? dueAmount;
    var options = {
      'key': 'rzp_test_KmWY8V0p2QgPJQ',
      'amount': amountToPay * 100,
      'name': 'Tanha Patel',
      'description': 'Test App',
      'prefill': {'contact': '0000000000', 'email': 'testapp@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    int newDueAmount = dueAmount - amountToPay;
    await updateDueAmount(newDueAmount);
    Navigator.popAndPushNamed(context, Success.id);
    Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
  }

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