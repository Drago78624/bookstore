import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 150, // Adjust as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use a Flexible widget to ensure height adjusts to image size
          Flexible(
            child: Image.network(
              "https://media.zenfs.com/en/ap.org/8a518c03ba576979ada6af7fce4855aa",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "The hunger games",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "\$19.99",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
