import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/loginScreen.dart';
import '../Auth/model.dart';
import '../Bottom Navigationbar/bottomNavigation.dart';

class SpalshScreen extends StatefulWidget {
  SpalshScreen({Key? key}) : super(key: key);

  @override
  State<SpalshScreen> createState() => SpalshScreenState();
}

class SpalshScreenState extends State<SpalshScreen> {

  //======================== variable ========================================
  static const String spalc = "Spalc";
  static const String login = "Login";

  //================================ init state =======================================
  @override
  void initState() {
    setState(() {

    });
    // TODO: implement initState
    super.initState();
    saved();

  }

  //======================== build widget ============================================
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(child: Image(image: AssetImage('assets/applogo.png'),fit: BoxFit.fill,)),
    );
  }

  //========================= method to store credential in sharprefrence ================================
  void saved() async {
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var Spalc = pref.getBool(spalc);
    var LogIn = pref1.getBool(login);
    if(Spalc != null && LogIn != null){
      if(Spalc && LogIn){
        Timer(Duration(seconds: 1), () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomBar())),);
      }
      else if(Spalc){
        Timer(Duration(seconds: 1), () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage())),);
      }
      else{
        Timer(Duration(seconds: 1), () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CrovsolScreen())),);
      }
    }
    else{
      Timer(Duration(seconds: 1), () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CrovsolScreen())),);
    }
  }
}

//========================================================================================
//========================Onboarding======================================================
//========================================================================================

class CrovsolScreen extends StatefulWidget {
  const CrovsolScreen({Key? key}) : super(key: key);

  @override
  State<CrovsolScreen> createState() => _CrovsolScreenState();
}

class _CrovsolScreenState extends State<CrovsolScreen> {
  List<model> listdata = [];
  int current =0;
  PageController _pagecontrol = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listdata.add(model('assets/app/choseproduct.png','Chosse Products',
        "In ecommerce, specifically, they're the blurbs of text on product "
            "pages that tell customers about your product. A good product description "
            "describes your product's features and benefits, acknowledges the problem it solves, "
            "and declares why it's the best product for the job.yhshjshjs"));
    listdata.add(model('assets/app/makepayment.png','Make Payment',
        'Electronic payment systems enable cashless transactions, '
            'saving time and reducing costs. Different types of electronic payments cater to various needs, '
            'from card payments to digital wallets. The process involves entering payment information, '
            'validation, security, and transaction processing.'));
    listdata.add(model('assets/app/getorder.png','Get Your Order',
        'In a nutshell, e-commerce order management is the process of '
            'tracking an order from the initial purchase transaction, '
            'through the entire fulfillment process, to the point a customer receives their goods.'));
  }
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet:Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for(int i=0;i<listdata.length;i++)...[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: (current==i)? 12 : 6,
                    height: (current==i) ? 12 : 6,
                    decoration: BoxDecoration(color: (current==i)?Colors.blueAccent : Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () async{
                setState(() {

                });
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setBool(SpalshScreenState.spalc, true);
                current==listdata.length-1 ? Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),)) : 'skip<<' ;

                _pagecontrol.animateToPage(current+1, duration: Duration(seconds: 1), curve: Curves.linear);

              }, child: Text((current!=listdata.length-1) ? 'skip<<' : 'Get Started'),),
            ],
          ),
        ],
      ),

      body: Center(
        child:  PageView.builder(
          itemCount: listdata.length,
          controller: _pagecontrol,
          onPageChanged: (value) {
            current = value ;
            setState(() {

            });
          },
          itemBuilder: (context, index) {
            return OtherScreen.pera(listdata[index]);
          },),
      ),
    );
  }
}

class OtherScreen extends StatefulWidget {
  OtherScreen(model listdata, {Key? key}) : super(key: key);
  model? obj;
  OtherScreen.pera(this.obj);

  @override

  State<OtherScreen> createState() => _OtherScreenState(obj!);
}

class _OtherScreenState extends State<OtherScreen> {
  model? obj;
  _OtherScreenState(this.obj);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20,),
          Image(image: AssetImage('${obj!.img}')),
          SizedBox(height: 15),
          Text('${obj!.title}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20,top: 10),
            child: Text('${obj!.desc}'),
          ),
        ],
      ),
    );
  }
}