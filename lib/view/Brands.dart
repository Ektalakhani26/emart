
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Pages/Product_Data/brand_data.dart';
import 'Store.dart';

class BrandScreen extends StatefulWidget {
  const BrandScreen({Key? key}) : super(key: key);

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {

  //====================================== variables =============================
  late Jsontodart postmodel;

  //===================== get api from http method =====================================
  Future<Jsontodart> getPostApi() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      postmodel = Jsontodart.fromJson(jsonDecode(response.body));
      return postmodel;
    } else {
      throw Exception('Failed to load data');
    }
  }

  //==================== build widget ========================================================
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Icon(Icons.diamond_sharp, color: Colors.black, size: 30),
        ),
        title: Text('Top Brands', style: TextStyle(color: Colors.black, fontSize: 25)),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getPostApi(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 1.80 / 3,
                      ),
                      itemCount: postmodel.products!.length,
                      itemBuilder: (BuildContext ctx, index) {

                      //  ==========description  nu soting kravyu==========================================
                            String title = postmodel.products![index].title.toString() ?? "";
                            String shortenedTitle = title.length >= 15 ? title.substring(0, 15) : title;
                            //===========================================================================

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Brand_Data(productdetail: postmodel.products![index]),
                              ),
                            );
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
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(postmodel.products![index].thumbnail.toString(),
                                                    fit: BoxFit.fill,),
                                    ),
                                    height: size.height/5,
                                    width: size.width*0.49,
                                  ),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text('${shortenedTitle}..',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(postmodel.products![index].category.toString(), style: TextStyle(color: Colors.black54)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(postmodel.products![index].brand.toString(), style: TextStyle(color: Colors.black54)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Text('₹${postmodel.products![index].price.toString()}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green)),
                                        SizedBox(width: 10,),
                                        Text('${postmodel.products![index].discountPercentage.toString()}% OFF',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
