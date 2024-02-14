import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myntra/Pages/checkout/CashPayment.dart';
import 'package:myntra/Auth/model.dart';
import 'package:share_plus/share_plus.dart';

import '../../DBHelper/DB_Helper.dart';
import '../../view/dynamic_link.dart';
import '../../view/favorite_screen.dart';

class ProductDetail1  extends StatefulWidget {
  var productdetail;

  ProductDetail1 ({Key? key, required  this.productdetail}) : super(key: key);

  @override
  State<ProductDetail1> createState() => _ProductDetail1State(productdetail);
}

class _ProductDetail1State extends State<ProductDetail1 > {

  //=============variables==============

  var productdetail;
  _ProductDetail1State(this.productdetail);
  bool like = false;
  bool fav = false;
  var qty = 1;
  bool isButtonTapped = false;
  List<Map<String, dynamic>> _journals = [];

//==============fetch data from databases=====================

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      print('data : $data');
    });
  }

  //==========init state===========================

  @override
  void initState() {
    _refreshJournals();
    // TODO: implement initState
    super.initState();
  }

  //================== add to cart data==================

  Future<void> _addcartItem() async {
    await SQLHelper.createItem(
        productdetail['Name'],productdetail['Description'],
        productdetail['Price'],productdetail['Discount'],'',qty,productdetail['image']);
    print('product name is ${productdetail['Name']}');
    _refreshJournals();
  }

  //============= add to whishlist ======================

  Future<void> _favorite() async {
    await SQLHelper.favoriteItem(
        productdetail['Name'],productdetail['Description'],
        productdetail['Price'],productdetail['Discount'],productdetail['image']);
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back,color: Colors.black,)),
        title: Text('${productdetail['Name']}',style: TextStyle(color: Colors.black,fontSize: 25)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
                onTap: ()  {
                  DynamicLinkProider().createlink("dkfkdfkg33444").then((value) {
                    Share.share(value);
                  });
                },
                child: Icon(Icons.ios_share_outlined)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
                onTap: () async {
                  //==================== add to favorite ============================================
                  await _favorite();
                  setState(() {
                    like = !like;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(),));
                },
                child: Icon(Icons.favorite,color:like ? Colors.red : Colors.grey,)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Center(
              child: Container(
                height: size.height*0.3,
                width: size.width * 0.9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Same border radius for the child widget
                  child: Image.network(
                    productdetail['image'],
                    fit: BoxFit.fill, // Use BoxFit.cover for better fitting within the container
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('${productdetail['Name']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            ),
            SizedBox(width: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('${productdetail['Description']}',style: TextStyle(fontSize: 14,color: Colors.grey)),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text('₹${productdetail['Price']}',style: TextStyle(color: Colors.orange,fontSize: 15,fontWeight: FontWeight.bold)),
                 SizedBox(width: 10,),
                  Text('${productdetail['Discount']}% OFF',style: TextStyle(color: Colors.orange,fontSize: 15,fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 3,
              color: Colors.black38,
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: size.height/20,
                    width: size.width*0.3,
                    color: Colors.grey,
                    alignment: Alignment.center,
                    child: Text('Top Brands',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white)),
                  ),
                  SizedBox(width: 10,),
                  Text('${productdetail['Name']}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding:  EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline,color: Colors.green,),
                  SizedBox(width: 10,),
                  Expanded(child: Text('75% positive rating from 10K+ customers',style: TextStyle(fontSize: 15))),
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 20,top: 10),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline,color: Colors.green,),
                  SizedBox(width: 10,),
                  Expanded(child: Text('10K+ recent orders from this brand',style: TextStyle(fontSize: 15))),
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 20,top: 10),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline,color: Colors.green,),
                  SizedBox(width: 10,),
                  Expanded(child: Text('7+ years on myntra',style: TextStyle(fontSize: 15))),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 3,
              color: Colors.black38,
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 15),
              child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.teal),
                      fixedSize: MaterialStatePropertyAll(Size(double.maxFinite,double.infinity)),
                  elevation: MaterialStatePropertyAll(10),foregroundColor: MaterialStatePropertyAll(Colors.black)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CashPaymentScreen(),));
                  }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/app/touch.png'),color: Colors.white,height: 25),
                      SizedBox(width: 10,),
                      Text('Buy Now',style: TextStyle(fontSize: 18,color: Colors.white)),
                    ],
                  )),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 15),
              child: ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(Size(double.maxFinite,double.infinity)),
                  backgroundColor: MaterialStatePropertyAll(isButtonTapped ? Colors.grey : Colors.blue.shade800,),
                  // Disable the button if it's tapped
                  overlayColor: MaterialStatePropertyAll(Colors.transparent),
                    elevation: MaterialStatePropertyAll(10)
                  // Remove the ripple effect
                ),
                onPressed: isButtonTapped ? null : () {

                  //=============================== add to cart =================================
                  _addcartItem();
                  setState(() {
                    isButtonTapped = true; // Mark the button as tapped
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('assets/app/addtocart.png'),color: Colors.white,height: 25),
                    SizedBox(width: 10,),
                    Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding:  EdgeInsets.only(left: 20),
              child: Text('Style Note : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding:  EdgeInsets.only(left: 20),
              child: Text('Give Yourself a Fashion makeover with this classy three-quarter top from ${productdetail['Name']}.'
                  ' Pair this navy blue piece with slim jens and a sling bag for a casual day look',
                style: TextStyle(fontSize: 15),),
            ),
          ],
        ),
      ),
    );
  }
}
