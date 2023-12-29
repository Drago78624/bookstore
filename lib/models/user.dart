class UserModel {
  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.addresses,
    required this.paymentMethods,
  });

  final String userId;
  final String name;
  final String email;
  final List<dynamic> addresses;
  final List<dynamic> paymentMethods;
}
