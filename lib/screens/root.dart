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

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    }
    super.initState();
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
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Results(filter: filter, filterName: name),
        ));
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
      Shop(),
      if (checkUserAuth()) UserProfile(userId: userId!)
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 26, 5, 62),
        foregroundColor: Colors.white,
        title: const Text(
          "Book Store",
        ),
        actions: [
          if (!checkUserAuth())
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
              child: Text("Login"),
            )
          else
            IconButton(
              onPressed: () {
                Get.to(() => Cart());
              },
              icon: Icon(Icons.shopping_cart),
            ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor:
            Colors.deepPurple, // Explicitly set selectedItemColor
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
