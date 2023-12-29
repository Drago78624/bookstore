// ignore_for_file: public_member_api_docs, sort_constructors_first
class Book {
  Book({
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
    required this.coverImageUrl,
    required this.price,
    required this.rating,
  });

  final String title;
  final String author;
  final List<dynamic> genre;
  final String description;
  final String coverImageUrl;
  final double price;
  final int rating;
}
