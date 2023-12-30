class LatestBook {
  LatestBook({
    required this.title,
    required this.id,
    required this.price,
    required this.coverImageUrl,
    this.docId,
  });

  final String id;
  final String title;
  final String? coverImageUrl;
  final double price;
  final String? docId;
}
