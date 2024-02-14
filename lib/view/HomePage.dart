import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myntra/Pages/Product/GirlsScreen.dart';
import 'package:myntra/Pages/Product/beautyScreen.dart';
import 'package:myntra/Pages/Product/footwareScreen.dart';
import 'package:myntra/Pages/Product/kidsScreen.dart';
import 'package:myntra/Pages/Product/mensScreen.dart';
import 'package:myntra/Pages/Product/perfumScreen.dart';
import 'package:myntra/view/favorite_screen.dart';

import '../Pages/Product/model/productmodel.dart';
import 'Search_facility.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //========================= variable ==========================================
  File? _image;
  List<ProductModel> product = [];
  final _picker = ImagePicker();

  //======================== open image picker =========================================
  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

// ======= retrive data from firestore database and store in model class==========================

  Future<List<ProductModel>> _searchFirestore() async {

    // ======= retrive data from skincare product ==========================
    final CollectionReference skincareCollection = FirebaseFirestore.instance.collection("skincare");
    QuerySnapshot querySnapshot = await skincareCollection.get();

    querySnapshot.docs.forEach((doc) {
      // Use the factory method to create an instance of ProductModel from Firestore document
      ProductModel skincareProduct = ProductModel.fromFirestore(doc.data() as Map<String, dynamic>);
      product.add(skincareProduct);

      print(product.length);

    });

    // ======= retrive data from luxury product ==========================
    final CollectionReference luxury = FirebaseFirestore.instance.collection("luxury");
    QuerySnapshot querySnapshot1 = await luxury.get();
    querySnapshot1.docs.forEach((doc) {
      // Use the factory method to create an instance of ProductModel from Firestore document
      ProductModel luxury = ProductModel.fromFirestore(doc.data() as Map<String, dynamic>);
      product.add(luxury);
    });

    // ======= retrive data from man clothes product ==========================
    final CollectionReference manclothes = FirebaseFirestore.instance.collection("manclothes");
    QuerySnapshot querySnapshot2 = await manclothes.get();
    querySnapshot2.docs.forEach((doc) {
      // Use the factory method to create an instance of ProductModel from Firestore document
      ProductModel Manclothes = ProductModel.fromFirestore(doc.data() as Map<String, dynamic>);
      product.add(Manclothes);
    });

    // ======= retrive data from woman clothes product ==========================
    final CollectionReference womanclothes = FirebaseFirestore.instance.collection("womanclothes");
    QuerySnapshot querySnapshot3 = await womanclothes.get();
    querySnapshot3.docs.forEach((doc) {
      // Use the factory method to create an instance of ProductModel from Firestore document
      ProductModel Womanclothes = ProductModel.fromFirestore(doc.data() as Map<String, dynamic>);
      product.add(Womanclothes);
    });

    // ======= retrive data from kids clothes product ==========================
    final CollectionReference kidsclothes = FirebaseFirestore.instance.collection("kidsclothes");
    QuerySnapshot querySnapshot4 = await kidsclothes.get();
    querySnapshot4.docs.forEach((doc) {
      // Use the factory method to create an instance of ProductModel from Firestore document
      ProductModel Kidsclothes = ProductModel.fromFirestore(doc.data() as Map<String, dynamic>);
      product.add(Kidsclothes);
    });

    // ======= retrive data from man footware product ==========================
    final CollectionReference footwareman = FirebaseFirestore.instance.collection("footwarem");
    QuerySnapshot querySnapshot5 = await footwareman.get();
    querySnapshot5.docs.forEach((doc) {
      // Use the factory method to create an instance of ProductModel from Firestore document
      ProductModel footwareman = ProductModel.fromFirestore(doc.data() as Map<String, dynamic>);
      product.add(footwareman);
    });

    // ======= retrive data from woman footware product ==========================
    final CollectionReference footwarewoman = FirebaseFirestore.instance.collection("footwarew");
    QuerySnapshot querySnapshot6 = await footwarewoman.get();
    querySnapshot6.docs.forEach((doc) {
      // Use the factory method to create an instance of ProductModel from Firestore document
      ProductModel Womanfootware = ProductModel.fromFirestore(doc.data() as Map<String, dynamic>);
      product.add(Womanfootware);
    });

    // ======= retrive data from kids footware product ==========================
    final CollectionReference footwarekids = FirebaseFirestore.instance.collection("footwarek");
    QuerySnapshot querySnapshot7 = await footwarekids.get();
    querySnapshot7.docs.forEach((doc) {
      // Use the factory method to create an instance of ProductModel from Firestore document
      ProductModel Kidsfootware = ProductModel.fromFirestore(doc.data() as Map<String, dynamic>);
      product.add(Kidsfootware);
    });

    return product;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //============================== search method called =====================================
    _searchFirestore();
  }

  //================================== build widget ================================================
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading:Container(
          height: size.height*0.1,
          width: size.width*0.1,
         // color: Colors.blue,
          child: Image(image: AssetImage('assets/applogo.png')),
        ),
        title: Text('Shopping Mart',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(),));
              },
              child: Icon(Icons.favorite_border_sharp,size: 30)),
          SizedBox(width: 30,)
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10),
            child: InkWell(
              onTap: () {
                //============================= show search bar form filteration =================================
                showSearch(context: context, delegate: SearchDelegate1(product));
              },
              child: Container(
                //alignment: Alignment.centerLeft,
                height: size.height/19,
                width: size.width,
                decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                   // SizedBox(width: 10,),
                    Icon(Icons.search,color: Colors.black38),
                    Text('Search For Product',style: TextStyle(color: Colors.black38)),

                    InkWell(
                        onTap: () => _openImagePicker(),
                        child: Icon(Icons.camera_alt_outlined,color: Colors.black87)),
                   // SizedBox(width: 20,),
                  ],
                ),
                // color: Colors.blue.shade50,
              ),
            ),
          ),
          SizedBox(height: 5,),
          Expanded(
            child : SingleChildScrollView(
             // scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Image(image: AssetImage('assets/banner.jpeg')),
                  CarouselSlider(
                    items: [
                      Image(image: AssetImage('assets/banner1.jpg')),
                      Image(image: AssetImage('assets/banner2.jpg')),
                      Image(image: AssetImage('assets/banner3.jpg')),
                      Image(image: AssetImage('assets/banner4.jpg')),
                      Image(image: AssetImage('assets/banner5.jpg')),
                    ],
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 900),
                      // viewportFraction: 0.8,
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: size.height/7,
                    color: Colors.pink.shade50,
                    child: Center(
                      child: Stack(
                        children: [
                          Container(
                            width: size.width*0.9,
                            height: size.height/9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Text('New User?',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w300))),
                                Expanded(child: Text('Flat ₹200 Off',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('ALL-TIME FAVOURITES',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w900),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Container(
                          height: size.height*0.2 + 20,
                          width: size.width*0.5-10,
                          decoration: BoxDecoration(color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.black54,blurStyle: BlurStyle.outer)],
                             border: Border.all(width: 0.1),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: size.width*0.5,
                                height: size.height/6,
                                child:ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(image: AssetImage('assets/cloth1.jpg'),fit: BoxFit.fill,)),
                              ),
                              SizedBox(height: 5,),
                              Text('Under ₹350'),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => GirlsScreen(),));
                        },
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => KidsScreen(),));
                        },
                        child: Container(
                          height: size.height*0.2 + 20,
                          width: size.width*0.5-10,
                          decoration: BoxDecoration(color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.black54,blurStyle: BlurStyle.outer)],
                              border: Border.all(width: 0.1),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: size.width*0.5,
                                height: size.height/6,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(image: AssetImage('assets/cloth3.jpeg'),fit: BoxFit.fill)),
                              ),
                              SizedBox(height: 5,),
                              Text('Under ₹200'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MensScreen(),));
                        },
                        child: Container(
                          height: size.height*0.2 + 20,
                          width: size.width*0.5-10,
                          decoration: BoxDecoration(color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.black54,blurStyle: BlurStyle.outer)],
                              border: Border.all(width: 0.1),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: size.width*0.5,
                                height: size.height/6,
                                child:ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(image: AssetImage('assets/cloth2.jpeg'),fit: BoxFit.fill,)),
                              ),
                              SizedBox(height: 5,),
                              Text('Under ₹400'),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FootwareScreen(),));
                        },
                        child: Container(
                          height: size.height*0.2 + 20,
                          width: size.width*0.5-10,
                          decoration: BoxDecoration(color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.black54,blurStyle: BlurStyle.outer)],
                              border: Border.all(width: 0.1),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: size.width*0.5,
                                height: size.height/6,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(image: AssetImage('assets/cloth4.jpeg'),fit: BoxFit.fill)),
                              ),
                              SizedBox(height: 5,),
                              Text('Under ₹500'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BeautyScreen(),));
                        },
                        child: Container(
                          height: size.height*0.2 + 20,
                          width: size.width*0.5-10,
                          decoration: BoxDecoration(color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.black54,blurStyle: BlurStyle.outer)],
                              border: Border.all(width: 0.1),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: size.width*0.5,
                                height: size.height/6,
                                child:ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(image: AssetImage('assets/cloth5.jpeg'),fit: BoxFit.fill,)),
                              ),
                              SizedBox(height: 5,),
                              Text('Under ₹300'),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PerfumScreen(),));
                        },
                        child: Container(
                          height: size.height*0.2 + 20,
                          width: size.width*0.5-10,
                          decoration: BoxDecoration(color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.black54,blurStyle: BlurStyle.outer)],
                              border: Border.all(width: 0.1),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: size.width*0.5,
                                height: size.height/6,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(image: AssetImage('assets/cloth6.jpeg'),fit: BoxFit.fill)),
                              ),
                              SizedBox(height: 5,),
                              Text('Under ₹650'),
                            ],
                          ),
                        ),
                      ),
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
