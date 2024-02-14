import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myntra/Pages/AdminPannel/Apparsal/Man_Apparsal/Add_Man_Clothes.dart';
import 'package:myntra/Pages/AdminPannel/FootWare/Man_Footware/Add_Man_Footware.dart';

import '../../../Product_Data/ProductDetail.dart';


class Man_Footware extends StatefulWidget {
  const Man_Footware({super.key});

  @override
  State<Man_Footware> createState() => _Man_FootwareState();
}

class _Man_FootwareState extends State<Man_Footware> {

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getData() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> data =
    await firebaseFirestore.collection("footwarem").get();
    if (data.docs.isEmpty) {
      return [];
    }
    return data.docs;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("Man Footware"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => Add_Man_Footware(),));
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
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

                    return Padding(
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
                    );
                  });

            })
    );
  }
}
