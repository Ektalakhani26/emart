import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myntra/Auth/loginScreen.dart';
import 'package:myntra/Pages/AdminPannel/Apparsal/Kids_Apparsal/Kids_Clothes.dart';
import 'package:myntra/Pages/AdminPannel/Apparsal/Man_Apparsal/Man_Clothes.dart';
import 'package:myntra/Pages/AdminPannel/FootWare/Kids_Footware/Kids_Footware.dart';
import 'package:myntra/Pages/AdminPannel/FootWare/Man_Footware/Man_Footware.dart';
import 'package:myntra/Pages/AdminPannel/FootWare/Woman_Footware/Woman_Footware.dart';
import 'package:myntra/Pages/AdminPannel/Skin%20care/Skincare.dart';
import 'package:myntra/Pages/AdminPannel/orderPlaced/confirm_order.dart';

import 'Apparsal/Woman_Apparsal/Woman_Clothes.dart';
import 'Luxury/Luxury.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {

  //=================== show dialog to confom user logout or not ========================================
  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Perform the logout logic here
                FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                await firebaseAuth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
              child: Text('Logout',style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/admin.jpg',),
          ),
        ),
        title: Text('Admin Dashboard'),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              // your logic
              if (value == '/logout') {
                _showLogoutConfirmationDialog();
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  child: Text("Log out"),
                  value: '/logout',
                ),
              ];
            },)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Image(image: AssetImage('assets/admin/adminbanner.jpg')),
            SizedBox(height: 20,),
            Card(
              child: ExpansionTile(
                maintainState: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                collapsedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                title: Text("Footware ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                children: [
                  InkWell(
                      child: Text("Man",style: TextStyle(fontSize: 25),
                      ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Man_Footware(),));
                    },
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Woman_Footware(),));
                      },
                      child: Text("Woman",style: TextStyle(fontSize: 25),)),
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Kids_Footware(),));
                      },
                      child: Text("Kids",style: TextStyle(fontSize: 25),)),
                ],
              ),
            ),
            Card(
              child: ExpansionTile(
                maintainState: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                collapsedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                title: Text("Apparsal",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                children: [
                  InkWell(
                      child: Text("Man",style: TextStyle(fontSize: 25),),
                    onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Man_Clothes(),));
                    },
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Woman_Clothes(),));
                      },
                      child: Text("Woman",style: TextStyle(fontSize: 25),)),
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Kids_Clothes(),));
                      },
                      child: Text("Kids",style: TextStyle(fontSize: 25),)),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Luxury(),));
              },
              child: Card(
                child: Container(
                  height: size.height*0.1 - 20,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0,top: 10),
                    child: Text("Luxury",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                  ),
                )
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Skin_care(),));
              },
              child: Card(
                  child: Container(
                    height: size.height*0.1 - 20,
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0,top: 10),
                      child: Text("Skin care",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                    ),
                  )
              ),
            ),

          ],
        ),
      ),
    );
  }
}
