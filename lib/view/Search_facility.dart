
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Pages/Product/model/productmodel.dart';

class SearchDelegate1 extends SearchDelegate<ProductModel>{

  List<ProductModel> product;

  SearchDelegate1(this.product);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(onPressed: () {
        query = '';
      }, icon: Icon(Icons.clear))
    ];

  }
  String formatAmount(int amount) {
    final formatter = NumberFormat('#,##,###');
    return formatter.format(amount);
  }

  //=======================================================
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  //================== build resullt =========================
  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  //======================= build suggestion ============================
  @override
  Widget buildSuggestions(BuildContext context ) {
    Size size = MediaQuery.of(context).size;
    final dateFormate = DateFormat('dd/MM/yyyy');
    List<ProductModel> suggestionList = query.isEmpty
        ? product
        : product
        .where((element) =>
        element.Name!.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    print('suggestion :${product}');
    return Container(
      height: size.height, // Set a fixed height or adjust as needed
      child: suggestionList.isNotEmpty
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0,top: 10),
                child: Text('Popular Search',style: TextStyle(fontSize: 25),),
              ),
              Expanded(
                child: ListView.builder(
                        itemCount: suggestionList.length,
                        itemBuilder: (context, index) {
                          //==========Name  nu soting kravyu==========================================
                          String title = suggestionList[index].Name ?? "";
                          String shortenedTitle = title.length >= 15 ? title.substring(0, 15) : title;
                          //===========================================================================
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0,right: 10,top: 15),
                            child: Container(
                              height: size.height*0.2 - 20,
                              width: size.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(color: Colors.white,blurStyle: BlurStyle.solid)],
                                  border: Border.all(width: 0.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Container(
                                        height: size.height*0.1 + 30,
                                        width: size.width*0.4,
                                        child: Image.network(suggestionList[index].image ?? "",fit: BoxFit.fill,)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10.0),
                                          child: Text('${shortenedTitle}' ?? "",style: TextStyle(fontSize: 20),),
                                        ),
                                        Text('₹${suggestionList[index].Price}' ?? "",style: TextStyle(color: Colors.green)
                                        ),
                                        Text('${suggestionList[index].Discount}% OFF' ?? "",style: TextStyle(color: Colors.orange)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          },
                ),
              ),
            ],
          ) :
      Center(
        child: const Text(
          'No results found',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

}