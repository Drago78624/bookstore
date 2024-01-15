import 'package:bookstore/widgets/payment_method_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  List paymentMethods = [1, 2, 3, 34];

  getPaymentMethods() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Methods"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
            children: paymentMethods.map((e) => PaymentMethodCard()).toList()),
        // child: StreamBuilder(
        //   stream: getPaymentMethods(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasError) {
        //       return const Text("something went wrong");
        //     } else if (snapshot.hasData) {
        //       final paymentMethodsData = snapshot.data!;
        //       return ListView(
        //         children: paymentMethods.map((address) {
        //           return PaymentMethodCard();
        //         }).toList(),
        //       );
        //     } else {
        //       return const Center(child: CircularProgressIndicator());
        //     }
        //   },
        // ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Get.toNamed("/add-payment-method");
        },
        icon: const Icon(Icons.add),
      ),
    );
    ;
  }
}
