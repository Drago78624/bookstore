import 'package:bookstore/widgets/address_card.dart';
import 'package:flutter/material.dart';

class Addresses extends StatefulWidget {
  const Addresses(
      {super.key, required this.addresses, required this.addressId});

  final List<dynamic> addresses;
  final String addressId;

  @override
  State<Addresses> createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  @override
  Widget build(BuildContext context) {
    print(widget.addresses);
    return Scaffold(
      appBar: AppBar(
        title: Text("Addresses"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget.addresses.isEmpty
              ? [
                  Text(
                    "no address added yet",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(onPressed: () {}, child: Text("Add Address"))
                ]
              : widget.addresses.map((address) {
                  return AddressCard(
                      addressData: address, addressId: widget.addressId);
                }).toList(),
        ),
      ),
    );
  }
}
