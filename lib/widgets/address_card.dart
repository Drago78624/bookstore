import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  const AddressCard(
      {super.key, required this.addressData, required this.addressId});

  final String addressData;
  final String addressId;

  removeAddress() async {
    final addressRef =
        FirebaseFirestore.instance.collection("addresses").doc(addressId);

    await addressRef.update({
      "addresses": FieldValue.arrayRemove([addressData]),
    });
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
      key: ValueKey(addressData),
      onDismissed: (direction) {
        removeAddress();
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                addressData,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Icon(Icons.edit)
            ],
          ),
        ),
      ),
    );
  }
}
