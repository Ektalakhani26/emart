import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myntra/view/On%20boarding.dart';
import 'package:myntra/view/dynamic_link.dart';


Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
  showFlutterNotification(message);
}
void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );
  DynamicLinkProider().initDynamicLink();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  registerNotification() async {
    print("Here .. Hello ");
    final TK = await _messaging.getToken().then((token) {
      print("TOken");
      print(token);
      return token; // Print the Token in Console
      // debugger();
    });
    print(TK);
    print("Here Fb Token");
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(message.data);
        print("Notification show onMessage");
        print(message.notification);
      });
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        print("Notification show onMessageOpenedApp");
        print(message.notification);
      });
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerNotification();

  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        // theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: SpalshScreen(),
      );
  }
}
