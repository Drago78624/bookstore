import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.addressData,
  });

  final Map addressData;

  removeAddress() async {
    final addressRef = FirebaseFirestore.instance
        .collection("addresses")
        .doc(addressData["addressId"]);

    await addressRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: Theme.of(context).colorScheme.error.withOpacity(0.75),
        margin: EdgeInsets.symmetric(
          horizontal: 20,
        ),
      ),
      key: UniqueKey(),
      onDismissed: (direction) {
        removeAddress();
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                addressData["address"].toString(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
