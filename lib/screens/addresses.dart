import 'package:bookstore/db.dart';
import 'package:bookstore/widgets/address_card.dart';
import 'package:bookstore/widgets/new_address.dart';
import 'package:flutter/material.dart';

class Addresses extends StatefulWidget {
  const Addresses({
    super.key,
    required this.uid,
  });

  final String? uid;

  @override
  State<Addresses> createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  void _openAddAddressOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => const NewAddress(),
    );
  }

  List<Map<String, String>> userAddresses = [];

  Stream<List> getAllAddresses() {
    return db
        .collection("addresses")
        .where("uid", isEqualTo: widget.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {"addressId": doc.id, ...doc.data()})
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Addresses"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder(
            stream: getAllAddresses(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("something went wrong");
              } else if (snapshot.hasData) {
                final addresses = snapshot.data!;
                return ListView(
                  children: addresses.map((address) {
                    return AddressCard(addressData: address);
                  }).toList(),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddAddressOverlay,
        child: const Icon(Icons.add),
      ),
    );
  }
}
