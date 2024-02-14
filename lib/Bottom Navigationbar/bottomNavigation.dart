import 'dart:async';

import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myntra/view/Brands.dart';
import 'package:myntra/view/Cart.dart';
import 'package:myntra/view/HomePage.dart';
import 'package:myntra/view/Profile.dart';

import '../Pages/AdminPannel/Admin.dart';
import '../Pages/AdminPannel/analytics.dart';
import '../Pages/AdminPannel/orderPlaced/confirm_order.dart';
import '../view/favorite_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int selectIndex = 0;
  List list = [
    const HomePage(),
    const BrandScreen(),
    const AddToCart(),
    FavoriteScreen(),
     YouScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: list[selectIndex],
        bottomNavigationBar: BottomBarBubble(
          selectedIndex: selectIndex,
          height: 60,
          bubbleSize: 2,
          color: Colors.blue,
          items: [
            BottomBarItem(iconData: Icons.home_rounded, iconSize: 27),
            BottomBarItem(iconData: Icons.discount, iconSize: 27),
            BottomBarItem(iconData: Icons.add_shopping_cart, iconSize: 27),
            BottomBarItem(iconData: Icons.favorite_border, iconSize: 27),
            BottomBarItem(iconData: Icons.manage_accounts, iconSize: 27),
          ],
          onSelect: (index) {
            selectIndex = index;
            setState(() {

            });
          },
        ),
      ),
    );
  }
}

//====================================== admin bottom bar =====================================

class AdminBottom extends StatefulWidget {
  const AdminBottom({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdminBottomState createState() => _AdminBottomState();
}

class _AdminBottomState extends State<AdminBottom> {

  int selectIndex = 0;
  List list = [
    AdminPanel(),
    Analytics(),
    Order_Conform(),
  ];
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: list[selectIndex],
        bottomNavigationBar: BottomBarBubble(
          selectedIndex: selectIndex,
          height: 60,
          bubbleSize: 2,
          color: Colors.blue,
          items: [
            BottomBarItem(iconData: Icons.home_rounded, iconSize: 27),
            BottomBarItem(iconData: Icons.analytics_outlined, iconSize: 27),
            BottomBarItem(iconData: Icons.local_shipping_outlined, iconSize: 27),
          ],
          onSelect: (index) {
            selectIndex = index;
            setState(() {});
          },
        ),
      ),
    );
  }
}

