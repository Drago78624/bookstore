import 'package:bookstore/controllers/payment_methods_controller.dart';
import 'package:bookstore/db.dart';
import 'package:bookstore/screens/add_payment_method.dart';
import 'package:bookstore/widgets/custom_heading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethods extends StatelessWidget {
  PaymentMethods({super.key});

  final PaymentMethodsController paymentMethodsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Methods")),
      body: Obx(
        () => paymentMethodsController.paymentMethods.length > 0
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: paymentMethodsController.paymentMethods.length,
                  itemBuilder: (context, index) => PaymentMethodCard(
                    paymentMethod:
                        paymentMethodsController.paymentMethods[index],
                    onRemove: (index) async {
                      await paymentMethodsController.removePaymentMethod(
                          // Get the ID of the payment method to be removed
                          paymentMethodsController.paymentMethods[index]['id']);
                    },
                    index: index,
                  ),
                ),
              )
            : Center(child: CustomHeading("No payment methods added yet")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.to(AddPaymentMethod());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Define PaymentMethodCard to display payment method details
class PaymentMethodCard extends StatelessWidget {
  final Map<String, dynamic> paymentMethod;
  final Function(int) onRemove;
  final int index;

  const PaymentMethodCard({
    required this.paymentMethod,
    required this.onRemove,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Display payment method details based on your model
    return Card(
      child: ListTile(
        title: Text(paymentMethod['cardType'] ?? 'Unknown Card'),
        subtitle: Text(paymentMethod['lastFourDigits'] ?? '****'),
        trailing: IconButton(
          onPressed: () => onRemove(index),
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
