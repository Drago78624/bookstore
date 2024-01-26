import 'package:bookstore/screens/root.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatefulWidget {
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order summary section
              Text(
                'Order Summary',
                style: Theme.of(context).textTheme.headline6,
              ),
              Divider(thickness: 2.0),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('Your products'),
                subtitle: Text('x3 Widgets, x2 Gadgets'),
                trailing: Text(
                  '\$199.99',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Divider(thickness: 2.0),
              // Shipping address section
              Text(
                'Shipping Address',
                style: Theme.of(context).textTheme.headline6,
              ),
              Divider(thickness: 2.0),
              Text(
                'John Doe\n123 Main Street\nAnytown, USA 12345',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              // Payment methods section
              Text(
                'Payment Method',
                style: Theme.of(context).textTheme.headline6,
              ),
              Divider(thickness: 2.0),
              Row(
                children: [
                  Radio(
                    value: 'credit_card',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) =>
                        setState(() => _selectedPaymentMethod = value!),
                  ),
                  Text('Credit Card'),
                  Spacer(),
                  Radio(
                    value: 'paypal',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) =>
                        setState(() => _selectedPaymentMethod = value!),
                  ),
                  Text('PayPal'),
                ],
              ),
              // Order confirmation button
              ElevatedButton(
                onPressed: () {
                  Get.snackbar("Order Recived",
                      "Your order has successfully been recieved !",
                      snackPosition: SnackPosition.BOTTOM);
                  Get.to(Root());
                },
                child: Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _selectedPaymentMethod = 'credit_card';
}
