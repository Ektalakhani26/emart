import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myntra/DBHelper/DB_Helper.dart';
import 'package:myntra/Pages/checkout/checkoutpayement.dart';

class CashPaymentScreen extends StatefulWidget {
  var cartdata;
  var totalMRP;
  var discount;
  var totalamount;
   CashPaymentScreen({Key? key,this.cartdata, this.totalMRP, this.discount, this.totalamount}) : super(key: key);

  @override
  State<CashPaymentScreen> createState() => _CashPaymentScreenState(cartdata,totalMRP,discount,totalamount);
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {

  //====================== variables ========================================
  var formKey = GlobalKey<FormState>();
  var cartdata;
  var totalMRP;
  var discount;
  var totalamount;
  _CashPaymentScreenState(this.cartdata, this.totalMRP, this.discount, this.totalamount);
  bool isChecked = false;
  bool isButtonTapped = false;

  TextEditingController mobileNumber = TextEditingController();
  TextEditingController Name = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController town = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();

  //===================== delete cart data =================================================
  _deleteItem(int id) async{
    await SQLHelper.deleteItem(id);
    setState(() {

    });
  }

  //============================= add product in firestore databases ===========================================
  Future<void> addProduct() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    String id = "order${DateTime.now().millisecondsSinceEpoch}";

    try {
      await firebaseFirestore.collection("order").doc(id).set({
        "data": cartdata,
        "time": DateTime.now(),
        "amount": totalamount,
      });

      // Delete items from the local cart after successfully adding to Firestore
      for (int i = 0; i < cartdata.length; i++) {
        await _deleteItem(cartdata[i]['id']);
      }
    } catch (e) {
      print("Error adding product to Firestore: $e");
      // Handle the error as needed (e.g., show an error message to the user).
    }
  }

  //======================= build widgets ============================================================
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Icon(Icons.delivery_dining,color: Colors.black,size: 30),
          title: Text('Cash On Delivery',style: TextStyle(color: Colors.black)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Image(image: AssetImage('assets/freedelivery.jpg')),
              SizedBox(height: 20,),
              Container(
                height: size.height*0.1 - 30,
                width: size.width,
                color: Colors.grey.shade400,
                alignment: Alignment.center,
                child: Text('CONTACT DETAILS'),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if(value==null || value.isEmpty){
                      return  'enter the value';
                    }
                    return null;
                  },
                  controller: Name,
                  decoration: InputDecoration(
                    label: Text('Name'),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if(value==null || value.isEmpty){
                      return  'enter the value';
                    }
                  },
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: mobileNumber,
                  decoration: InputDecoration(
                    label: Text('Mobile No'),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              Container(
                height: size.height*0.1 - 30,
                width: size.width,
                color: Colors.grey.shade400,
                alignment: Alignment.center,
                child: Text('ADDRESS'),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if(value==null || value.isEmpty){
                      return  'enter the value';
                    }
                    return null;
                  },
                  maxLength: 6,
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: pincode,
                  decoration: InputDecoration(
                    label: Text('Pincode'),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if(value==null || value.isEmpty){
                      return  'enter the value';
                    }
                    return null;
                  },
                  controller: address,
                  decoration: InputDecoration(
                    label: Text('Address'),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if(value==null || value.isEmpty){
                      return  'enter the value';
                    }
                    return null;
                  },
                  controller: town,
                  decoration: InputDecoration(
                    label: Text('Town'),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if(value==null || value.isEmpty){
                      return  'enter the value';
                    }
                    return null;
                  },
                  controller: city,
                  decoration: InputDecoration(
                    label: Text('City'),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if(value==null || value.isEmpty){
                      return  'enter the value';
                    }
                    return null;
                  },
                  controller: state,
                  decoration: InputDecoration(
                    label: Text('State'),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  Text('Make this my default address'),
                ],
              ),

              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20),
                child: ElevatedButton(
                    style: ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(double.maxFinite,double.infinity)),
                      backgroundColor: MaterialStatePropertyAll(Colors.blue.shade800,),),
                    onPressed: () async {
                      //======================= add cart product in databases ==========================
                      await addProduct();
                  if(formKey.currentState!.validate()){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckOut(
                      name: Name.text,
                      Number: mobileNumber.text,
                      totalMRP: totalMRP,
                      discount: discount,
                      totalamount: totalamount,
                    ),));
                    //
                  }
                }, child: Text('Add Address',style: TextStyle(fontSize: 20,color: Colors.white),)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
