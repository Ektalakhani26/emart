import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Product_Data/ProductDetail.dart';
import '../Product_Data/footware_data.dart';
import '../../view/favorite_screen.dart';

//==========================Man Footware===========================================

class Man_Footware extends StatefulWidget {
  const Man_Footware({super.key});

  @override
  State<Man_Footware> createState() => _Man_FootwareState();
}

class _Man_FootwareState extends State<Man_Footware> {

  //====================== retrive data from databases in footware man =====================================
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getData() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> data =
    await firebaseFirestore.collection("footwarem").get();

    if (data.docs.isEmpty) {
      return [];
    }
    return data.docs;
  }

  //========================= build widget =================================================
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context ),
          child: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        title: Text('ONLINE FASHION STORE',style: TextStyle(color: Colors.black)),
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(),));
              },
              child: const Icon(Icons.favorite,color: Colors.red,)),
          const SizedBox(width: 20,),
        ],
      ),
      body: Column(
        children: [
          const Image(image: AssetImage('assets/freeshipping.jpeg')),
          Expanded(
              child:FutureBuilder(
                  future: getData(),
                  builder: (context,
                      AsyncSnapshot<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
                      snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child:
                        CircularProgressIndicator(color: Colors.blueAccent),
                      );
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(child: Text("No Data Found"));
                      }
                    }
                    return GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 1.80 / 3,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext ctx, index) {
                          final productData = snapshot.data![index].data() as Map<String, dynamic>;

                          //  ==========description  nu soting kravyu==========================================
                          String title = productData['Description']?? "";
                          String shortenedTitle = title.length >= 40 ? title.substring(0, 40) : title;
                          //===========================================================================

                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Footware_Data(productdetail: snapshot.data![index].data() as Map<String, dynamic>,),));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: size.height*0.2 - 20,
                                width: size.width,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(color: Colors.white,blurStyle: BlurStyle.solid)],
                                    border: Border.all(width: 0.1),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: size.height/5,
                                      width: size.width*0.49,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.network(productData['image'],fit: BoxFit.fill,),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(productData['Name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text('${shortenedTitle}...',style: TextStyle(color: Colors.black54)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Text('₹${productData['Price']}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
                                          SizedBox(width: 10,),
                                          Text('${productData['Discount']}% OFF',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        });

                  })
          ),
        ],
      ),
    );
  }
}

//=====================Woman Footware Screen =====================================

class Woman_Footware extends StatefulWidget {
  const Woman_Footware({super.key});

  @override
  State<Woman_Footware> createState() => _Woman_FootwareState();
}

class _Woman_FootwareState extends State<Woman_Footware> {

  //=========================== retrive data from footware woman =========================================
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getData() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> data =
    await firebaseFirestore.collection("footwarew").get();

    if (data.docs.isEmpty) {
      return [];
    }
    return data.docs;
  }

  //========================== build widgets ==========================================================
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context ),
          child: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        title: Text('ONLINE FASHION STORE',style: TextStyle(color: Colors.black)),
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(),));
              },
              child: Icon(Icons.favorite,color: Colors.red,)),
          SizedBox(width: 20,),
        ],
      ),
      body: Column(
        children: [
          Image(image: AssetImage('assets/freeshipping.jpeg')),
          Expanded(
              child:FutureBuilder(
                  future: getData(),
                  builder: (context,
                      AsyncSnapshot<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
                      snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child:
                        CircularProgressIndicator(color: Colors.blueAccent),
                      );
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(child: Text("No Data Found"));
                      }
                    }
                    return GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 1.80 / 3,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext ctx, index) {
                          final productData = snapshot.data![index].data() as Map<String, dynamic>;

                          //  ==========description  nu soting kravyu==========================================
                          String title = productData['Description']?? "";
                          String shortenedTitle = title.length >= 40 ? title.substring(0, 40) : title;
                          //===========================================================================

                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Footware_Data(productdetail: snapshot.data![index].data() as Map<String, dynamic>,),));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: size.height*0.2 - 20,
                                width: size.width,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(color: Colors.white,blurStyle: BlurStyle.solid)],
                                    border: Border.all(width: 0.1),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: size.height/5,
                                      width: size.width*0.49,
                                      child: ClipRRect(
                                          child: Image.network(productData['image'],fit: BoxFit.fill,),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(productData['Name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text('${shortenedTitle}...',style: TextStyle(color: Colors.black54)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Text('₹${productData['Price']}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
                                          SizedBox(width: 10,),
                                          Text('${productData['Discount']}% OFF',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        });

                  })
          ),
        ],
      ),
    );
  }
}

//================================Kids Footware===============================================

class Kids_Footware extends StatefulWidget {
  const Kids_Footware({super.key});

  @override
  State<Kids_Footware> createState() => _Kids_FootwareState();
}

class _Kids_FootwareState extends State<Kids_Footware> {

  //======================= retrive data from footwarekids ====================================
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getData() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> data =
    await firebaseFirestore.collection("footwarek").get();

    if (data.docs.isEmpty) {
      return [];
    }
    return data.docs;
  }

  //================== widget build ====================================================
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context ),
          child: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        title: Text('ONLINE FASHION STORE',style: TextStyle(color: Colors.black)),
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(),));
              },
              child: Icon(Icons.favorite,color: Colors.red,)),
          SizedBox(width: 20,),
        ],
      ),
      body: Column(
        children: [
          Image(image: AssetImage('assets/freeshipping.jpeg')),
          Expanded(
              child:FutureBuilder(
                  future: getData(),
                  builder: (context,
                      AsyncSnapshot<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
                      snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child:
                        CircularProgressIndicator(color: Colors.blueAccent),
                      );
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(child: Text("No Data Found"));
                      }
                    }
                    return GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 1.80 / 3,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext ctx, index) {
                          final productData = snapshot.data![index].data() as Map<String, dynamic>;

                          //  ==========description  nu soting kravyu==========================================
                          String title = productData['Description']?? "";
                          String shortenedTitle = title.length >= 40 ? title.substring(0, 40) : title;
                          //===========================================================================

                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Footware_Data(productdetail: snapshot.data![index].data() as Map<String, dynamic>,),));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: size.height*0.2 - 20,
                                width: size.width,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(color: Colors.white,blurStyle: BlurStyle.solid)],
                                    border: Border.all(width: 0.1),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: size.height/5,
                                      width: size.width*0.49,
                                      child: ClipRRect(
                                          child: Image.network(productData['image'],fit: BoxFit.fill,),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(productData['Name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text('${shortenedTitle}...',style: TextStyle(color: Colors.black54)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Text('₹${productData['Price']}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
                                          SizedBox(width: 10,),
                                          Text('${productData['Discount']}% OFF',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });

                  })
          ),
        ],
      ),
    );
  }
}

//====================== Footware Main Screen =========================================

class FootwareScreen extends StatefulWidget {
  const FootwareScreen({super.key});

  @override
  State<FootwareScreen> createState() => _FootwareScreenState();
}

class _FootwareScreenState extends State<FootwareScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context ),
          child: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        title: Text('ONLINE FASHION STORE',style: TextStyle(color: Colors.black)),
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(),));
              },
              child: Icon(Icons.favorite,color: Colors.red,)),
          SizedBox(width: 20,),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(image: AssetImage('assets/freeshipping.jpeg')),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 20.0,right: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => Man_Footware(),));
                },
                child: Container(
                  width: size.width,
                  height: size.height*0.1,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(50)),
                  child: Text("Man's Footware",style: TextStyle(fontSize: 20),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 20.0,right: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => Woman_Footware(),));
                },
                child: Container(
                  width: size.width,
                  height: size.height*0.1,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(50)),
                  child: Text("Woman's Footware",style: TextStyle(fontSize: 20),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 20.0,right: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => Kids_Footware(),));
                },
                child: Container(
                  width: size.width,
                  height: size.height*0.1,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(50)),
                  child: Text("Kid's Footware",style: TextStyle(fontSize: 20),),
                ),
              ),
            ),
           SizedBox(height: 30,),
            Container(
              height: size.height*0.3 +20,
                child: Image(image: AssetImage('assets/footwarebanner.jpg'),fit: BoxFit.fill,)),
          ],
        ),
      ),
    );
  }
}
