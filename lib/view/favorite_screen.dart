import 'package:flutter/material.dart';
import 'package:myntra/Bottom%20Navigationbar/bottomNavigation.dart';

import '../DBHelper/DB_Helper.dart';

class FavoriteScreen extends StatefulWidget {

   FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  //====================== variable ==================================
  List<Map<String, dynamic>>? listfavorite = [];

  //=================== retrive data from sqlite ================================
  void _refreshJournals() async {
    final data = await SQLHelper.favoritegetItems();
    setState(() {
      listfavorite = data;
    });
  }

  //========================== remove product from whishlist ==================================
  void _deleteItem(int id) async {
    await SQLHelper.favoritedeleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Color(0XFF1565C0),
      content: Text('Successfully remove product!',style: TextStyle(color: Colors.white)),
    ));
    _refreshJournals();
  }

  //===================== init state ===========================================================
  @override
  void initState() {
    _refreshJournals();
    // TODO: implement initState
    super.initState();
  }

  //============================ build widget =====================================================
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back,color: Colors.black,)),
        title: Text('Favorite Profile',style: TextStyle(color: Colors.black)),
      ),
        body: Column(
          children: [
            !listfavorite!.isEmpty ?
            Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1.80 / 3,
                  ),
                  itemCount: listfavorite?.length,
                  itemBuilder: (BuildContext ctx, index) {

                    //  ==========description  nu soting kravyu==========================================
                    String title = listfavorite![index]["subtitle"] ?? "";
                    String shortenedTitle = title.length >= 30 ? title.substring(0, 30) : title;
                    //===========================================================================

                    return Padding(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: size.height/5,
                                  width: size.width*0.49,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(listfavorite![index]['image'],fit: BoxFit.fill,),),
                              ),
                                  Positioned(
                                    left: size.width*0.3 + 30,
                                    child: InkWell(
                                        onTap: () {
                                          _deleteItem(listfavorite![index]["id"]);
                                        },
                                        child: CircleAvatar(
                                          minRadius: 15,
                                            backgroundColor: Colors.white,
                                            child: Icon(Icons.close_outlined,color: Colors.green.shade800,))),
                                  ),
                              ]
                            ),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('${listfavorite![index]["title"]}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text('${shortenedTitle}',style: TextStyle(color: Colors.black54)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text('₹${listfavorite![index]["price"]}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text('${listfavorite![index]["description"]}% OFF',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ) :
            Expanded(
              child: Center(
                child: Stack(
                    children: [
                      Image(image: AssetImage('assets/whishlist.jpg')),
                      Positioned(
                       top: size.height*0.3,
                        left: size.width*0.3,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar(),));
                          },
                          child: Container(
                            height: size.height*0.1 - 20,
                            width: size.width*0.4,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.blue.shade800,width: 2)),
                            child: Text('SHOP NOW',style: TextStyle(color: Colors.blue.shade800),),
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            ),
          ],
        )
    );
  }
}
