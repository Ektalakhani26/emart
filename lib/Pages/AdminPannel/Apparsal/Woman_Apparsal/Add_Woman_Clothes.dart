import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myntra/Pages/AdminPannel/Apparsal/Man_Apparsal/Man_Clothes.dart';

import '../../../../Widgets/button_view.dart';
import 'Woman_Clothes.dart';


class Add_Woman_Clothes extends StatefulWidget {
  const Add_Woman_Clothes({Key? key}) : super(key: key);

  @override
  State<Add_Woman_Clothes> createState() => _Add_Woman_ClothesState();
}

class _Add_Woman_ClothesState extends State<Add_Woman_Clothes> {
  var form1 = GlobalKey<FormState>();
  XFile? xfile;
  String? image;
  TextEditingController Name = TextEditingController();
  TextEditingController Description = TextEditingController();
  TextEditingController Price = TextEditingController();
  TextEditingController Discount = TextEditingController();

  Future<void> addProduct() async {

    String? url;
    if (image == null) {
      return;
    }
    String ext = image!.split(".").last;
    String imgpath =
    // ignore: prefer_interpolation_to_compose_strings
    DateTime.now().millisecondsSinceEpoch.toString() + "." + ext;
    if (!Uri.parse(imgpath).isAbsolute) {
      Reference reference = FirebaseStorage.instance.ref(imgpath);
      await reference.putFile(File(image!));
      url = await reference.getDownloadURL();
    }
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    String id = "Woman${DateTime.now().millisecondsSinceEpoch}";
    await firebaseFirestore.collection("womanclothes").doc(id).set({
      "image": url,
      "Name": Name.text,
      "Description": Description.text,
      "Price": Price.text,
      "Discount": Discount.text
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Woman_Clothes(),));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("Add Woman Product"),
        ),
        bottomNavigationBar: buttonView(
          title: "Save",
          onTap: () {
            if (form1.currentState!.validate()) {
              addProduct();
            }
          },
        ),
        body: ListView(physics: const BouncingScrollPhysics(), children: [
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              ImagePicker imagePicker = ImagePicker();
              xfile = await imagePicker.pickImage(source: ImageSource.gallery);
              image = xfile!.path;
              setState(() {});
            },
            child: image != null
                ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(image!),
                  fit: BoxFit.cover,
                ),
              ),
            )
                : Container(
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Add Image", style: TextStyle()),
                    const SizedBox(
                      height: 8,
                    ),
                    const Icon(Icons.add)
                  ]),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Name", style: TextStyle()),
              ),
              Expanded(
                child: TextFormField(
                  controller: Name,
                  decoration: InputDecoration(
                    hintText: "Name",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Description", style: TextStyle()),
              ),
              Expanded(
                child: TextFormField(
                  controller: Description,
                  decoration: InputDecoration(
                    hintText: "Description",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Price", style: TextStyle()),
              ),
              Expanded(
                child: TextFormField(
                  controller: Price,
                  decoration: InputDecoration(
                    hintText: "Price",
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Discount", style: TextStyle()),
              ),
              Expanded(
                child: TextFormField(
                  controller: Discount,
                  decoration: InputDecoration(
                    hintText: "Discount",
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
