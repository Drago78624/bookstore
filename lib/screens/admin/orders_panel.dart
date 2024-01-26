import 'package:flutter/material.dart';

class OrdersPanel extends StatefulWidget {
  const OrdersPanel({super.key});

  @override
  State<OrdersPanel> createState() => _OrdersPanelState();
}

class _OrdersPanelState extends State<OrdersPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders Management"),
      ),
      body: Text("orders"),
    );
  }
}
