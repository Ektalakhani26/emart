import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Order_Conform extends StatefulWidget {
  const Order_Conform({super.key});

  @override
  State<Order_Conform> createState() => _Order_ConformState();
}

class _Order_ConformState extends State<Order_Conform> {


  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getData() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> data =
    await firebaseFirestore.collection("order").get();
    if (data.docs.isEmpty) {
      return [];
    }
    print('data docs = ${data.docs}');
    return data.docs;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;


    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
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
              return const Center(child: Text("No Order"));
            }
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final productData = snapshot.data![index].data();
              return Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10),
                      child: Container(
                        width: size.width,
                        height: size.height*0.3,
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView.builder(
                            itemCount: productData["data"].length,
                            itemBuilder: (context, index) {
                             return Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //SizedBox(width: 10,),
                                     // Text(productData1[index]["time"]),
                                      Container(
                                        child: Image.network(productData["data"][index]["image"],fit: BoxFit.fill,),
                                        //Image(image: AssetImage('${addtocart![index]["image"]}'),fit: BoxFit.fill,),
                                        height: size.height * 0.2 - 30,
                                        width: size.width*0.49,
                                      ),
                                      Expanded(
                                        child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Text('${productData["data"][index]["Name"]}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10.0),
                                              child: Text('₹${productData["data"][index]["Price"]}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green)),
                                            ),
                                            SizedBox(width: 5,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10.0),
                                              child: Text('${productData["data"][index]["Discount"]}% OFF',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Text('Items :${productData["data"][index]["qty"]}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                   ),

                                 ],
                               ),
                             );
                          },),
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10),
                      child: Row(
                        children: [
                          Text('Order at E-com :',
                              style: TextStyle(fontSize: 15,color: Colors.black54)),
                          Spacer(),
                          Text('${DateFormat('MMMM dd, yyyy').format((productData["time"] as Timestamp).toDate())}',
                              style: TextStyle(fontSize: 15,color: Colors.black)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10),
                      child: Row(
                        children: [
                          Text('Order Status :',
                              style: TextStyle(fontSize: 15,color: Colors.black54)),
                          Spacer(),
                          Text('Shipping',
                              style: TextStyle(fontSize: 15,color: Colors.black)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10,bottom: 10),
                      child: Row(
                        children: [
                          Text('Price :',
                              style: TextStyle(fontSize: 15,color: Colors.black54)),
                          Spacer(),
                          Text('₹${productData["amount"]}',
                              style: TextStyle(fontSize: 15,color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
          },
          );
      },),
    );
  }
}
