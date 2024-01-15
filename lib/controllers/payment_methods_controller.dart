import 'package:bookstore/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PaymentMethodsController extends GetxController {
  final _paymentMethods = [].obs;
  final collection = db.collection("payment_methods");
  final user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    fetchPaymentMethods();
  }

  Future<void> fetchPaymentMethods() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      final paymentMethodsDocs =
          await collection.doc(user.uid).collection('methods').get();
      final paymentMethods =
          paymentMethodsDocs.docs.map((doc) => doc.data()).toList();
      _paymentMethods.assignAll(paymentMethods);
    } catch (error) {
      print("Error fetching payment methods: $error");
    }
  }

  Future<void> addPaymentMethod(Map<String, dynamic> paymentMethodData) async {
    print(paymentMethodData);
    try {
      final docRef = collection
          .doc(user!.uid)
          .collection('methods')
          .doc(paymentMethodData["id"]);
      print(docRef);
      await docRef.set(paymentMethodData);
      _paymentMethods.add(paymentMethodData);
      Get.snackbar(
        "Payment Method Added",
        "You have added a new payment method",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (error) {
      print("Error adding payment method: $error");
    }
  }

  Future<void> removePaymentMethod(String paymentMethodId) async {
    try {
      final docRef =
          collection.doc(user!.uid).collection('methods').doc(paymentMethodId);
      await docRef.delete();
      _paymentMethods.removeWhere((method) => method['id'] == paymentMethodId);
      Get.snackbar(
        "Payment Method Removed",
        "You have removed a payment method",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (error) {
      print("Error removing payment method: $error");
    }
  }

  get paymentMethods => _paymentMethods;
}
