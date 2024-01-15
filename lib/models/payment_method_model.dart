class PaymentMethodModel {
  final String id; // Unique identifier (optional for local storage)
  final String cardNumber; // Store securely (e.g., encrypted)
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode; // Store securely (e.g., encrypted)
  final String? lastFourDigits; // For display purposes

  // Optional fields:
  final String? billingAddress;

  PaymentMethodModel({
    required this.id,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    this.lastFourDigits,
    this.billingAddress,
  });

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      id: map['id'],
      cardNumber: map['cardNumber'],
      expiryDate: map['expiryDate'],
      cardHolderName: map['cardHolderName'],
      cvvCode: map['cvvCode'],
      lastFourDigits: map['lastFourDigits'],
      billingAddress: map['billingAddress'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardHolderName': cardHolderName,
      'cvvCode': cvvCode,
      'lastFourDigits': lastFourDigits,
      'billingAddress': billingAddress,
    };
  }
}
