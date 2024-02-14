
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myntra/view/favorite_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../../DBHelper/DB_Helper.dart';
import '../../view/dynamic_link.dart';
import '../checkout/CashPayment.dart';

class Footware_Data extends StatefulWidget {
  var productdetail;

  Footware_Data({Key? key, required  this.productdetail}) : super(key: key);

  @override
  State<Footware_Data> createState() => _Footware_DataState(productdetail);
}

class _Footware_DataState extends State<Footware_Data> {

  //================================ variable ===================================
  var qty = 1;
  List<Size1> clothsize = [];
  List<Map<String, dynamic>> _journals = [];
  var defaultsize = '6';
  var index = 2;
  var productdetail;
  _Footware_DataState(this.productdetail);
  get ab => clothsize[index].size1;
  int selectedindex = 0;
  bool like = false;
  bool isButtonTapped = false;

  //=================== retrive data from sqlite =================================
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      print('data : $data');
    });
  }

  //================ init state =================================================
  @override
  void initState() {

    //===================== cloth size add ==========================================
    clothsize.add(Size1('6'));
    clothsize.add(Size1('7'));
    clothsize.add(Size1('8'));
    clothsize.add(Size1('9'));
    clothsize.add(Size1('10'));
    _refreshJournals();
    // TODO: implement initState
    super.initState();
  }

  //========================== add to cart ==============================================
  Future<void> _addcartItem() async {
    await SQLHelper.createItem(
        productdetail['Name'],productdetail['Description'],
        productdetail['Price'],productdetail['Discount'],defaultsize,qty,productdetail['image']);
    print('product name is ${productdetail['Name']}');
    _refreshJournals();
  }

  //========================= add to favorite =========================================
  Future<void> _favorite() async {
    await SQLHelper.favoriteItem(
        productdetail['Name'],productdetail['Description'],
        productdetail['Price'],productdetail['Discount'],productdetail['image']);
    _refreshJournals();
  }

  //========================= build widget =============================================
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
                  //================ add to favorite =============================================
                  await _favorite();
                  setState(() {
                    like = !like;
                  });
                },
                child: Icon(Icons.favorite,color: like ? Colors.red : Colors.grey,)),
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
              height: size.height/17,
              child: Padding(
                padding:  EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Icon(Icons.recycling),
                    Text('Find Your Size',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),)
                  ],
                ),
              ),
              color: Colors.black12,
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text('Size:',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                  SizedBox(width: 10,),
                  Text('${defaultsize}',style: TextStyle(fontSize: 20),),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Wrap(
                direction: Axis.horizontal,
                children: List.generate(5, (index){
                  return Container(
                    height: size.height*0.1 -20,
                    margin: EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(selectedindex == index ? Colors.blue : Colors.white)),
                      onPressed: () {
                        setState(() {
                          selectedindex=index;
                          if(selectedindex==0){defaultsize="6";}
                          if(selectedindex==1){defaultsize="7";}
                          if(selectedindex==2){defaultsize="8";}
                          if(selectedindex==3){defaultsize="9";}
                          if(selectedindex==4){defaultsize="10";}
                        });
                      }, child: Text('${clothsize[index].size1}',style: TextStyle(color: Colors.black)),

                    ),
                  );
                }),
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

                  //============================= add to cart ================================
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

class Size1{
  var size1;

  Size1(this.size1);
}