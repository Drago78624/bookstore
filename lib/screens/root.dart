import 'package:bookstore/controllers/cart_controller.dart';
import 'package:bookstore/helpers/check_auth_user.dart';
import 'package:bookstore/screens/authors.dart';
import 'package:bookstore/screens/cart.dart';
import 'package:bookstore/screens/categories.dart';
import 'package:bookstore/screens/home_screen.dart';
import 'package:bookstore/screens/results.dart';
import 'package:bookstore/screens/shop.dart';
import 'package:bookstore/screens/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

enum BookFilter { category, author }

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;
  String? userId;
  BookFilter? filter;
  String? name;
  final cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
      cartController.fetchCartItems();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void setFilter(BookFilter? enteredFilter, String? enteredName) {
    setState(() {
      filter = enteredFilter;
      name = enteredName;
    });
    Get.to(Results(filter: filter, filterName: name));
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> bottomNavItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.category),
        label: 'Categories',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.group),
        label: 'Authors',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.shopping_bag),
        label: 'Shop',
      ),
      if (checkUserAuth())
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'User',
        ),
    ];

    final List<Widget> _widgetOptions = [
      Home(onTap: _onItemTapped),
      Categories(setFilter: setFilter),
      Authors(setFilter: setFilter),
      const Shop(),
      if (checkUserAuth())
        UserProfile(
            userId: userId!,
            cartController: Get.find(),
            changeScreen: _onItemTapped)
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Book Store",
        ),
        actions: [
          if (!checkUserAuth())
            IconButton(
              // style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () {
                Get.toNamed("/login");
              },
              icon: const Icon(Icons.login),
            )
          else
            Obx(
              () => badges.Badge(
                position: badges.BadgePosition.topStart(),
                badgeContent: Text(
                    cartController.books.values.toList().length.toString()),
                child: IconButton(
                  onPressed: () {
                    Get.to(() => Cart());
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
              ),
            )
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor:
            Color(0xff06283D), // Explicitly set selectedItemColor
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
