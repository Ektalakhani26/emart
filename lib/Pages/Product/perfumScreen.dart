import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myntra/Pages/Product_Data/ProductDetail1.dart';

import '../../view/favorite_screen.dart';
import '../../Auth/model.dart';
import '../Product_Data/ProductDetail.dart';

class PerfumScreen extends StatefulWidget {
  const PerfumScreen({Key? key}) : super(key: key);

  @override
  State<PerfumScreen> createState() => _PerfumScreenState();
}

class _PerfumScreenState extends State<PerfumScreen> {

  //======================= retrive data from luxury ===================================
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getData() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> data =
    await firebaseFirestore.collection("luxury").get();
    if (data.docs.isEmpty) {
      return [];
    }
    return data.docs;
  }

  //====================== build widget ===================================================
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
            child: FutureBuilder(
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail1(productdetail: snapshot.data![index].data() as Map<String, dynamic>,),));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: size.height*0.2 - 20,
                              width: size.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(color: Colors.white,blurStyle: BlurStyle.solid)],
                                  border: Border.all(width: 0.1),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: ClipRRect(
                                        child: Image.network(productData['image'],fit: BoxFit.fill,),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: size.height/5,
                                    width: size.width*0.49,
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

                }),
          )
        ],
      ),
    );
  }
}
