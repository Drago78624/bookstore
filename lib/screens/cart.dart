import 'package:bookstore/controllers/cart_controller.dart';
import 'package:bookstore/screens/checkout.dart';
import 'package:bookstore/widgets/cart_book_card.dart';
import 'package:bookstore/widgets/custom_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cart extends StatefulWidget {
  Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Obx(
        () => cartController.length > 0
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: cartController.books.length,
                          itemBuilder: (context, index) => CartBookCard(
                              cartController: cartController,
                              quantity:
                                  cartController.books.values.toList()[index],
                              book: cartController.books.keys.toList()[index],
                              index: index)),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(children: [
                              const CustomHeading("Total"),
                              const Spacer(),
                              Text(
                                "\$${cartController.total}",
                                style: const TextStyle(fontSize: 18),
                              )
                            ]),
                            ElevatedButton(
                                onPressed: () {
                                  Get.to(CheckoutPage());
                                },
                                child: Text("Checkout"))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Center(child: CustomHeading("Cart is empty")),
      ),
    );
  }
}
