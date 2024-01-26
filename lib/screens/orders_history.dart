import 'package:flutter/material.dart';

class OrderHistory extends StatelessWidget {
  final List<Map<String, dynamic>> _dummyOrders = [
    {
      'orderId': '12345',
      'date': '2024-01-20',
      'total': 49.99,
      'items': [
        {'name': 'Book 1', 'quantity': 2, 'price': 19.99},
        {'name': 'Book 2', 'quantity': 1, 'price': 30.00},
      ],
      'status': 'Delivered',
    },
    {
      'orderId': '67890',
      'date': '2024-01-15',
      'total': 25.50,
      'items': [
        {'name': 'Book 3', 'quantity': 1, 'price': 12.50},
        {'name': 'Book 4', 'quantity': 1, 'price': 13.00},
      ],
      'status': 'Shipped',
    },
    // Add more dummy orders here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: ListView.builder(
        itemCount: _dummyOrders.length,
        itemBuilder: (context, index) {
          final order = _dummyOrders[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${order['orderId']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Date: ${order['date']}'),
                  SizedBox(height: 4),
                  Text('Total: \$${order['total'].toStringAsFixed(2)}'),
                  SizedBox(height: 8),
                  Text('Status: ${order['status']}'),
                  SizedBox(height: 8),
                  Text('Items:'),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: order['items'].length,
                    itemBuilder: (context, itemIndex) {
                      final item = order['items'][itemIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text('${item['quantity']}x '),
                            Expanded(child: Text(item['name'])),
                            Text('\$${item['price'].toStringAsFixed(2)}'),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
