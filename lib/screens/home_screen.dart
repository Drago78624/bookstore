import 'package:bookstore/widgets/custom_heading.dart';
import 'package:bookstore/widgets/home/carousel.dart';
import 'package:bookstore/widgets/home/latest_books.dart';
import 'package:bookstore/widgets/home/popular_books.dart';
import 'package:bookstore/widgets/see_all_btn.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.onTap});

  final void Function(int index) onTap;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Carousel(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const CustomHeading("Latest Books"),
                  const Spacer(),
                  SeeAllBtn(onTap: widget.onTap),
                ],
              ),
            ),
            SizedBox(height: 200, child: LatestBooks(onTap: widget.onTap)),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const CustomHeading("Popular Books"),
                  const Spacer(),
                  SeeAllBtn(onTap: widget.onTap),
                ],
              ),
            ),
            SizedBox(height: 200, child: PopularBooks(onTap: widget.onTap)),
          ],
        ),
      ),
    );
  }
}
