import 'package:bookstore/controllers/cart_controller.dart';
import 'package:bookstore/widgets/cart_book_card.dart';
import 'package:bookstore/widgets/custom_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cart extends StatelessWidget {
  Cart({super.key});
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: cartController.books.length,
                    itemBuilder: (context, index) => CartBookCard(
                        cartController: cartController,
                        quantity: cartController.books.values.toList()[index],
                        book: cartController.books.keys.toList()[index],
                        index: index)),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(children: [
                    const CustomHeading("Total"),
                    const Spacer(),
                    Text(
                      "\$${cartController.total}",
                      style: const TextStyle(fontSize: 18),
                    )
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
