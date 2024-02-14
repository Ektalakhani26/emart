
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myntra/view/HomePage.dart';
import 'package:myntra/Pages/AdminPannel/Admin.dart';
import '../Bottom Navigationbar/bottomNavigation.dart';
import '../main.dart';
import 'RegistrationScreen.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  var username1;
  var password1;

  LoginPage.Mydata({required this.username1,required this.password1});

  @override
  State<LoginPage> createState() => LoginPageState(username1,password1);
}

class LoginPageState extends State<LoginPage> {

  //=================== variables ==========================================
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
    var form1 = GlobalKey<FormState>();
  var password = true;
  var username1;
  var password1;

  LoginPageState(this.username1, this.password1);
  //========================= init state ===========================================
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  //========================= login Method ==========================================
  void login() async {
    try {

      UserCredential userCredential1 = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _username.text,
          password: _password.text
      );
      if (userCredential1.user!.uid == "dUTFwrTdLkTuQ4sPXosNmkg6Zrg2") {

             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminBottom(),));
             return;
           }
      if (userCredential1.user != null) {

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar(),));
        return;
      }
    }  catch (e) {
      print(e);
    }
  }
  //========================= widget build =========================================================
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: form1,
      child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          height: size.height*0.4 + 20,
                          width: size.width,
                          child: Image(image: AssetImage('assets/login1.jpg'),fit: BoxFit.fill,)),
                      SizedBox(height: 10,),
                      Text('Log In Now',style: TextStyle(fontSize: 25),),
                      Text('Please login to continue using our app',style: TextStyle(color: Colors.grey),),
                      SizedBox(height: 20,),
                      Padding(
                        padding:  EdgeInsets.only(left: 20,right: 20),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter the value';
                            }
                            return null;
                          },
                          controller: _username,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                            border: OutlineInputBorder(borderSide: BorderSide(width: 4,color: Colors.transparent),borderRadius: BorderRadius.circular(200)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                        child: TextFormField(
                          controller: _password,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter the value';
                            }
                            return null;
                          },
                          obscureText: password,
                          decoration: InputDecoration(
                            fillColor: Colors.pinkAccent,
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {});
                                password = !password;
                              },
                              child: Icon(
                                  password
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility,
                                  color: Colors.grey),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(200)),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height*0.1 + 10,),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                        child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blueAccent)
                            ,fixedSize: MaterialStatePropertyAll(Size(double.maxFinite, double.infinity))),

                            onPressed: () async{
                              if (form1.currentState!.validate()) {
                                //================ Method called ===========================
                                login();
                              }
                            },
                            child: Text('Login',
                              style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),)),
                      ),

                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Dont't hve an account ?",style: TextStyle(color: Colors.grey,fontSize: 17),),
                          SizedBox(width: 5,),
                          TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.only(left: 0))),
                              onPressed: () {
                                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => RegistrationPage(),));
                              },
                              child: Text('Sign Up',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w500,fontSize: 17),)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
