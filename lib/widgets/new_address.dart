import 'package:bookstore/db.dart';
import 'package:bookstore/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _formKey = GlobalKey<FormState>();

class NewAddress extends StatefulWidget {
  const NewAddress({super.key});

  @override
  State<NewAddress> createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  final TextEditingController addressController = TextEditingController();

  void addAddress() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "address": addressController.text
      };
      try {
        await db.collection("addresses").add(data);
      } catch (err) {
        print(err);
      }
    }
    _closeOverlay();
  }

  _closeOverlay() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Form(
              key: _formKey,
              child: CustomTextField(
                  fieldController: addressController,
                  fieldValidator: (value) => value!.length < 8
                      ? "Address should be atleast 12 characters"
                      : null,
                  label: "Address"),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: addAddress, child: Text("Add"))
          ],
        ),
      ),
    );
  }
}
