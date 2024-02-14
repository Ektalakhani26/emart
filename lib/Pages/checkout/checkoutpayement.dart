import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../Bottom Navigationbar/bottomNavigation.dart';
import '../../Widgets/button_view.dart';

class CheckOut extends StatefulWidget {
  var totalMRP;
  var discount;
  var totalamount;
  var name;
  var Number;
   CheckOut({Key? key, this.totalMRP, this.discount, this.totalamount, required this.name, required this.Number});

  @override
  State<CheckOut> createState() => _CheckOutState(totalMRP,discount,totalamount,name,Number);
}

class _CheckOutState extends State<CheckOut> {
  var totalamount;
  var totalMRP;
  var discount;
  var name;
  var Number;
  Razorpay? _razorpay = Razorpay();
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getData() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> data =
    await firebaseFirestore.collection("user").get();
    if (data.docs.isEmpty) {
      return [];
    }
    return data.docs;
  }

  _CheckOutState(this.totalMRP, this.discount, this.totalamount, this.name, this.Number);


  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(
        msg: "SUCCESS PAYMENT: ${response.paymentId}", timeInSecForIosWeb: 4);
    Navigator.push(context, MaterialPageRoute(builder: (context) => BottomBar(),));

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR HERE: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET IS : ${response.walletName}",
        timeInSecForIosWeb: 4);
  }
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  void openPaymentPortal() async {
    var options = {
      'key': 'rzp_test_0LcakF9UELi9WL',
      'amount': '${(double.parse(totalamount) * 100).toInt()}',
      'name': '${name}',
      'description': 'Payment',
      'prefill': {'contact': '${Number}', 'email': 'jhon@razorpay.com'},
      'external': {
        'wallets': ['paytm','UPI']
      }

    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: buttonView(
        title: "Pay Now",
        onTap: () {
          openPaymentPortal();
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Product Bill',style: TextStyle(fontSize: 20),),
          Padding(
            padding: const EdgeInsets.only(top: 15,left: 20,right: 20),
            child: Container(
              height: size.height*0.3,
              width: size.width ,
              decoration: BoxDecoration(border: Border.all(width: 2),borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Text('Total Price'),
                      ),
                      Text('₹${totalMRP}'),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Total Discount'),
                      Text('- ₹${discount}'),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Text('Delivery'),
                      ),
                      Text('FREE',style: TextStyle(color: Colors.blue.shade600)),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 3,
                    width: size.width*0.8,
                    color: Colors.black26,
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Total Payable',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('₹${totalamount}',style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
