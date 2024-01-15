import 'package:bookstore/screens/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({super.key});

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
        // removeAddress();
      },
      child: TextButton(
        onPressed: () {
          Get.to(PaymentMethod());
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  "payment method 1",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
