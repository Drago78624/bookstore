import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Book Store"),
        actions: [
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((value) {
                  return Navigator.pushNamed(
                    context,
                    "/login",
                  );
                });
              },
              child: Text("Logout"))
        ],
      ),
      body: Column(
        children: [
          Text("Popular"),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        // BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.account_circle), label: "User"),
      ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
