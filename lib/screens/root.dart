import 'package:bookstore/helpers/check_auth_user.dart';
import 'package:bookstore/screens/cart.dart';
import 'package:bookstore/screens/categories.dart';
import 'package:bookstore/screens/home_screen.dart';
import 'package:bookstore/screens/shop.dart';
import 'package:bookstore/screens/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> bottomNavItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
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
      Shop(),
      if (checkUserAuth()) UserProfile()
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
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
              child: Text("Login"),
            )
          else
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                setState(() {});
              },
              child: Text("logout"),
            ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, "/cart");
          //   },
          //   icon: Icon(Icons.shopping_cart),
          // ),
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
