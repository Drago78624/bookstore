import 'package:bookstore/controllers/cart_controller.dart';
import 'package:bookstore/models/user.dart';
import 'package:bookstore/screens/addresses.dart';
import 'package:bookstore/screens/wishlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final db = FirebaseFirestore.instance;

class UserProfile extends StatefulWidget {
  const UserProfile(
      {super.key, required this.userId, required this.cartController});

  final String userId;
  final CartController cartController;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserModel? userData;

  getUser() async {
    db.collection("users").where("uid", isEqualTo: widget.userId).get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          final data = docSnapshot.data();
          userData = UserModel(
            userId: data["uid"],
            name: data["fullName"],
            email: data["email"],
            addresses: data["addresses"],
            paymentMethods: data["paymentMethods"],
          );
        }
        setState(() {});
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            Text(
              userData!.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              userData!.email,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Get.to(Wishlist(
                        userId: userData!.userId,
                      ));
                    },
                    child: const Row(
                      children: [
                        Text(
                          "Wishlist",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                  const Divider(),
                  TextButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Text(
                          "Order History",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                  const Divider(),
                  TextButton(
                    onPressed: () {
                      Get.to(Addresses(uid: widget.userId));
                    },
                    child: const Row(
                      children: [
                        Text(
                          "My Addresses",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                  const Divider(),
                  TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Get.offNamed('/root');
                      Get.delete<CartController>();
                    },
                    child: const Row(
                      children: [
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
