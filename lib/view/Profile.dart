
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../Auth/loginScreen.dart';
import '../DBHelper/DB_Helper.dart';


class YouScreen extends StatefulWidget {
  YouScreen({Key? key});

  @override
  State<YouScreen> createState() => _YouScreenState();
}

class _YouScreenState extends State<YouScreen> {

  //================================= variable ===================================
  List<Map<String, dynamic>> _journals = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  File? _image;
  final _picker = ImagePicker();
  var formKey = GlobalKey<FormState>();

  //======================= retrive user data from databases =========================
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getData() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> data =
    await firebaseFirestore.collection("user").get();
    if (data.docs.isEmpty) {
      return [];
    }
    return data.docs;
  }

  //========================= retrive data to sqlite =============================
  void _refreshJournals() async {
    final data = await SQLHelper.getprofileItems();
    setState(() {
      _journals = List<Map<String, dynamic>>.from(data);
      print(_journals);
    });
  }

  //==================== image picker =====================================
  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  //============================= add item to sqlite ======================================
  Future<void> _addItem() async {
    File imageFile = File(_image!.path);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String imagePath = '${appDocDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    await imageFile.copy(imagePath);

    await SQLHelper.profileItem(
      _nameController.text,
      _contactController.text,
      _emailController.text,
      _pincodeController.text,
      _cityController.text,
      _stateController.text,
      imagePath,  // Save the image path instead of _image!.path
    );

    _refreshJournals();
  }

  //===================== init state ===========================================
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshJournals();

  }

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

  //====================== build widget ========================================
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.person_add_alt_1_sharp),
        title: Text('Edit Profile Info',style:TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),
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

            //========================= data show in firrestore =================================
            var userData = snapshot.data!.last.data() as Map<String, dynamic>;
            _nameController.text = userData['Userame'] ?? '';
            _contactController.text = userData['Mobile No'] ?? '';
            _emailController.text = userData['Email'] ?? '';

            //========================= data shown in sqlite =========================================
            if(_journals.isNotEmpty) {
              var a = _journals.length - 1;
              _nameController.text = _journals[a]['name'] ?? '';
              _contactController.text = _journals[a]['contact'] ?? '';
              _emailController.text = _journals[a]['email'] ?? '';
              _pincodeController.text = _journals[a]['pincode'] ?? '';
              _cityController.text = _journals[a]['city'] ?? '';
              _stateController.text = _journals[a]['state'] ?? '';
            }

          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              maxRadius: 50,
                              //  child: Txt('MB',fontSize: 35,color: Colors.white,),
                              backgroundImage: (_image != null)
                                  ? FileImage(_image!)
                                  : (_journals.isNotEmpty && _journals.last['image'] != null)
                                  ? FileImage(File(_journals.last['image']))  // Use the stored image path
                                  : AssetImage('assets/profile1.jpg') as ImageProvider<Object>,
                            ),
                            CircleAvatar(
                              maxRadius: 15,
                              child: InkWell(
                                  onTap: () async {
                                    await _openImagePicker();
                                    setState(() {
                                    });
                                  },
                                  child: Icon(Icons.camera_enhance)),
                              backgroundColor: Colors.white,
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
                Center(child: Text('Upload Photo')),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0,top: 20),
                  child: Text('Your Name*',style:TextStyle(fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20,top: 5),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: 'Name',
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,top: 10),
                  child: Text('Mobile No*',style:TextStyle(fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20,top: 5),
                  child: TextFormField(
                    controller: _contactController,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                        hintText: 'Mobile Number',
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,top: 10),
                  child: Text('Email*',style:TextStyle(fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20,top: 5),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,top: 10),
                  child: Text('Pincode*',style:TextStyle(fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20,top: 5),
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    controller: _pincodeController,
                    decoration: InputDecoration(
                        hintText: 'Pincode Number',
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,top: 10),
                  child: Text('City*',style:TextStyle(fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20,top: 5),
                  child: TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                        hintText: 'city',
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,top: 10),
                  child: Text('State*',style:TextStyle(fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20,top: 5),
                  child: TextFormField(
                    controller: _stateController,
                    decoration: InputDecoration(
                        hintText: 'state',
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20),
                  child: ElevatedButton(style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(Size(double.maxFinite,double.infinity)),
                      backgroundColor: MaterialStatePropertyAll(Colors.blue.shade800,),),
                      onPressed: () async {
                    //========================= add item ===========================
                    await _addItem();
                    //========================== snack bar ======================================
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                      backgroundColor: Colors.green,
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          Expanded(child: Text('Profile information has been added Successfully',
                              style: TextStyle(color: Colors.white))),],
                      ),
                    ));
                    setState(() {

                    });
                  }, child: Text("SAVE",style: TextStyle(color: Colors.white,fontSize: 20),)),
                ),
              ],
            ),
          );
        },

      ),

    );
  }
}