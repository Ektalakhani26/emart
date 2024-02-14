
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/HomePage.dart';
import 'model.dart';
import 'loginScreen.dart';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  //============================= variables =====================================
  var _user = TextEditingController();
  var _passwo = TextEditingController();
  var _reset = TextEditingController();
  var _mobileno = TextEditingController();
  var _email = TextEditingController();
  var passwo = true;
  var reset = true;
  var formKey = GlobalKey<FormState>();

//===================== registration Method =============================================
  void Registration() async {
    try {
      //  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text,
          password: _passwo.text
      );
      if (userCredential.user != null) {
        // await LocalStorage.instance.setBool(LocalStorage.isAdmin, true);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
        return;
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }

    } catch (e) {
      print(e);
    }
  }

  //============================ widget build =======================================
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Form(
      key: formKey,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            height: size.height*0.3 + 20,
                            width: size.width,
                            child: Image(image: AssetImage('assets/login1.jpg'),fit: BoxFit.fill,)),
                        Text('Sign Up Now',style: TextStyle(fontSize: 25),),
                        Text('Please fill the detail and create account',style: TextStyle(color: Colors.grey),),
                        SizedBox(height: 20,),
                        Padding(
                          padding: EdgeInsets.only(left: 20,right: 20),
                          child: TextFormField(
                            controller: _user,
                            validator: (value) {
                              if(value==null || value.isEmpty){
                                return  'enter the value';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'username',
                              prefixIcon: Icon(Icons.person_outline_rounded),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: EdgeInsets.only(left: 20,right: 20),
                          child: TextFormField(
                            controller: _email,
                            validator: (value) {
                              if(value==null || value.isEmpty){
                                return 'enter the value';
                              }
                              else if(RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                                return null;
                              } else
                              {
                                return 'enter valid email';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: EdgeInsets.only(left: 20,right: 20),
                          child: TextFormField(
                            controller: _mobileno,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              var mno=value;
                              if(mno==null || mno.isEmpty){
                                return 'enter the value';
                              }
                              else if(mno.length != 10){
                                return 'please enter 10 digit';
                              }
                              return null;
                            },
                            maxLength: 10,
                            decoration: InputDecoration(
                              hintText: 'Mobile No',
                              prefixIcon: Icon(Icons.call),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20,right: 20),
                          child: TextFormField(
                            controller: _passwo,
                            validator: (value) {
                              RegExp re=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!#?$*@~]).{8,}$');
                              var ps=value;
                              if(ps==null || ps.isEmpty){
                                return 'enter the number';
                              }
                              else if(ps.length <7){
                                return 'enter minimum 7 charater';
                              }
                              else if(!re.hasMatch(ps)){
                                return 'password contain uper case';
                              }
                              return null;
                            },
                            obscureText: passwo,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.vpn_key_outlined),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {

                                  });
                                  passwo = !passwo;
                                },
                                child: Icon(passwo ? Icons.visibility_off_outlined : Icons.visibility, color: Colors.grey),
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: EdgeInsets.only(left: 20,right: 20),
                          child: TextFormField(
                            controller: _reset,
                            validator: (value) {
                              if(value==null || value.isEmpty){
                                return 'enter the value';
                              }
                              else if(value != _passwo.text){
                                return 'password are not same';
                              }
                              return null;
                            },
                            obscureText: reset,
                            decoration: InputDecoration(
                              hintText: 'Conform Password',
                              prefixIcon: Icon(Icons.vpn_key_outlined),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {

                                  });
                                  reset = !reset;
                                },
                                child: Icon(reset ? Icons.visibility_off_outlined : Icons.visibility , color: Colors.grey),
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(200)),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height*0.1 - 40,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0,right: 20),
                          child: ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blueAccent),
                                  fixedSize: MaterialStatePropertyAll(Size(double.maxFinite, double.infinity))),
                              onPressed: () async {

                                if(formKey.currentState!.validate()){
                                  //================= Method called ====================================

                                  Registration();

                                  //=================== data save in firebase ==============================
                                  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
                                  String id = "User${DateTime.now().millisecondsSinceEpoch}";
                                  await firebaseFirestore.collection("user").doc(id).set({
                                    "Userame": _user.text,
                                    "Email": _email.text,
                                    "Mobile No": _mobileno.text,
                                    "password": _passwo.text
                                  });
                                  //====================== snack bar ==============================
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Registration complete')),
                                  );
                                }
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => Login1(),));
                              }, child: Text('Sign Up',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already hve an account ?",style: TextStyle(color: Colors.grey,fontSize: 17),),
                            SizedBox(width: 5,),
                            TextButton(
                                style: ButtonStyle(
                                    padding: MaterialStatePropertyAll(
                                        EdgeInsets.only(left: 0))),
                                onPressed: () {
                                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginPage(),));
                                },
                                child: Text('Log in',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w500,fontSize: 17),)),
                          ],
                        ),
                      ],
                    ),
                  ),

            ),
          ],
        ),
      ),
    );
  }
}
