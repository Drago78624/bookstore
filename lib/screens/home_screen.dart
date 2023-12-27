import 'package:bookstore/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
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
        body: Text(
            "homepage") // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
