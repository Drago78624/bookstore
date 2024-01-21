class BookCardModel {
  BookCardModel({
    required this.title,
    required this.id,
    required this.price,
    required this.coverImageUrl,
    this.docId,
  });

  final String id;
  final String title;
  final String? coverImageUrl;
  final int price;
  final String? docId;
}
