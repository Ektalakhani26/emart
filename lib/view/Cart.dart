import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:myntra/Pages/checkout/CashPayment.dart';
import '../DBHelper/DB_Helper.dart';


class AddToCart extends StatefulWidget {
  const AddToCart({Key? key}) : super(key: key);

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {

  //=============================== variable ====================================
  List<Map>? addtocart = [];

  //===================== retrive data from sqlite =======================
  void _Addtocart() async {
    final data = await SQLHelper.getItems();
    setState(() {
      addtocart = data.map((map) => Map.from(map)).toList();
      print(addtocart);
    });
  }

  // ========================== delete product from cart screen ============================
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted Product'),
    ));
    _Addtocart();
  }

  //============================== init state =======================================
  @override
  void initState() {
    _Addtocart();
    // TODO: implement initState
    super.initState();
  }

  //=========================== build widget ======================================
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //========================== calculate total  amount ==============================
    double totalamount() {
      double sum = 0;
      int tmp = 0, tmp2 = 0;
      for (var i = 0; i < addtocart!.length; i++) {
        tmp = int.parse(addtocart![i]['Price']);
        tmp2 = addtocart![i]['qty'];
        sum = sum + tmp * tmp2;
      }
      return sum;
    }

    //===================== calculate discount =========================================
    double totaldiscount() {
      double sum1 = 0;
      for (var i = 0; i < addtocart!.length; i++) {
        sum1 += double.parse(addtocart![i]['Price']) * addtocart![i]['qty'] * (double.parse(addtocart![i]['Discount']) / 100);
      }
      return sum1;
    }

    //===================== calculate Gst ==================================================
    double totalGst() {
      double sum1 = 0;
      for (var i = 0; i < addtocart!.length; i++) {
        sum1 += double.parse(addtocart![i]['Price']) * addtocart![i]['qty'] * (2.5 / 100);
      }
      return sum1;
    }

    //==================== calculate final total ==============================================
    var finaltotal = totalamount() - totaldiscount() + totalGst();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.add_shopping_cart_rounded,color: Colors.black,size: 30,),
        title: Text('Add To Cart',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          if (!addtocart!.isEmpty) Expanded(
              child: ListView.builder(
                itemCount: addtocart?.length,
                itemBuilder: (context, index) {
                  print('size is ${addtocart![index]["size"]}');
                  var size1 = addtocart![index]["size"];
                  //  ==========description  nu soting kravyu==========================================
                  String title = addtocart![index]["Description"] ?? "";
                  String shortenedTitle = title.length >= 30 ? title.substring(0, 30) : title;
                  //===========================================================================
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: size.width,
                    height: size.height*0.3 - 20,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.white,blurStyle: BlurStyle.solid)],
                        border: Border.all(width: 0.1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Container(
                          child: ClipRRect(
                              child: Image.network(addtocart![index]['image'],fit: BoxFit.fill,),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: size.height,
                          width: size.width*0.49,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text('${addtocart![index]["Name"]}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: size1.isEmpty ? Container() :
                                Text(
                                  'Size: ${addtocart![index]["size"]}',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text('₹${addtocart![index]["Price"]}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text('${addtocart![index]["Discount"]}% OFF',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange)),
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: InkWell(
                                    child: Container(
                                        decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
                                        child: Text('Remove',style: TextStyle(color: Colors.black),),
                                      width: size.width*0.2,
                                      height: size.height/25,
                                      alignment: Alignment.center,
                                    ),
                                  onTap: () {
                                      _deleteItem(addtocart![index]["id"]);
                                  },
                                ),
                              ),
                              Expanded(
                                child: InputQty(
                                  btnColor1: Colors.black,
                                  minusBtn: Icon(Icons.remove_circle),
                                  plusBtn: Icon(Icons.add_circle),
                                  textFieldDecoration: InputDecoration(border: InputBorder.none),
                                  initVal: addtocart![index]['qty'],
                                  borderShape: BorderShapeBtn.circle,
                                  boxDecoration: BoxDecoration(),
                                  // steps: 10,
                                  onQtyChanged: (val) {
                                    addtocart?[index]['qty']= val;
                                    setState(() {
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },),
          )
            //========================= cart empty hoi to image =================================
          else Expanded(
            child: Container(
              //height: size.height*0.7+20,
              child: Image(image: AssetImage('assets/cartempty.png')),),
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20),
                child: ElevatedButton(
                  style: ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(double.maxFinite,double.infinity)),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue.shade800,),)
                  ,child: const Text('Next',style: TextStyle(fontSize: 20,color: Colors.white),),
                  onPressed: () {

                    //========================= show bottom sheet ================================================
                    showModalBottomSheet<void>(
                      isDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: size.height*0.4 + 10,
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children:[
                                SizedBox(height: 10,),
                                Text('Product detail'),
                                SizedBox(height: 10,),
                                Expanded(
                                  child: Container(
                                    height: size.height/3,
                                    width: size.width*0.90,
                                    decoration: BoxDecoration(border: Border.all(color: Colors.black54),borderRadius: BorderRadius.circular(20)),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 30),
                                              child: Text('Total Price'),
                                            ),
                                            Text('₹${totalamount().toStringAsFixed(2)}'),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Total Discount'),
                                            Text('- ₹${totaldiscount().toStringAsFixed(2)}'),
                                          ],
                                        ),
                                         SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Total GST'),
                                            Text('+ ₹${totalGst().toStringAsFixed(2)}'),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 40),
                                              child: Text('Delivery'),
                                            ),
                                            Text('FREE',style: TextStyle(color: Colors.blue.shade600)),
                                          ],
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          height: 3,
                                          width: size.width*0.8,
                                          color: Colors.black26,
                                        ),
                                        SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Total Payable',style: TextStyle(fontWeight: FontWeight.bold)),
                                            Text('₹${finaltotal.toStringAsFixed(2)}',style: TextStyle(fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0,right: 20),
                                  child: ElevatedButton(
                                      style: ButtonStyle(fixedSize: MaterialStatePropertyAll(Size(double.maxFinite,double.infinity)),
                                        backgroundColor: MaterialStatePropertyAll(Colors.blue.shade800,),
                                      ),
                                    child:  Text('Continue',style: TextStyle(fontSize: 20,color: Colors.white),),
                                    onPressed: () {
                                    Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                    CashPaymentScreen(cartdata : addtocart,totalMRP : totalamount().toStringAsFixed(2),
                                    discount : totaldiscount().toStringAsFixed(2),totalamount : finaltotal.toStringAsFixed(2)),));
                                    }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

