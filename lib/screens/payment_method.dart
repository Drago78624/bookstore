import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class PaymentMethod extends StatelessWidget {
  PaymentMethod({super.key});

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Method"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CreditCardWidget(
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cvvCode: cvvCode,
          showBackView:
              isCvvFocused, //true when you want to show cvv(back) view
          onCreditCardWidgetChange: (CreditCardBrand
              brand) {}, // Callback for anytime credit card brand is changed
        ),
      ),
    );
  }
}
