import 'package:bookstore/widgets/home/carousel.dart';
import 'package:bookstore/widgets/home/latest_books.dart';
import 'package:bookstore/widgets/home/popular_books.dart';
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
      body: Column(children: [
        Carousel(),
        LatestBooks(),
        PopularBooks(),
      ]),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.category), label: "Categories"),
        // BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.account_circle), label: "User"),
      ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
