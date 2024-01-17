import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _usersCollection => _firestore.collection('users');

  RxList<User> _users = RxList<User>([]);
  List<User> get users => _users;

  @override
  void onInit() {
    super.onInit();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final snapshot = await _usersCollection.get();
      final fetchedUsers =
          snapshot.docs.map((doc) => User.fromDocument(doc)).toList();
      _users.assignAll(fetchedUsers);
    } catch (error) {
      // Handle errors appropriately, e.g., display error messages
      print(error);
      rethrow; // Rethrow to allow top-level error handling
    }
  }

  Future<void> addUser(User user) async {
    try {
      await _usersCollection.add(user.toJson());
      _users.add(user);
      update();
    } catch (error) {
      // Handle errors appropriately
    }
  }

  Future<void> updateUser(User updatedUser) async {
    try {
      final docId = updatedUser.id;
      await _usersCollection.doc(docId).update(updatedUser.toJson());
      final index = _users.indexWhere((user) => user.id == docId);
      if (index != -1) {
        _users[index] = updatedUser;
        update();
      }
    } catch (error) {
      // Handle errors appropriately
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
      _users.removeWhere((user) => user.id == userId);
      update();
    } catch (error) {
      // Handle errors appropriately
    }
  }
}

class User {
  final String id;
  String email;
  String fullName;
  List<String> addresses;
  List<String> paymentMethods;
  String? password;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.addresses,
    required this.paymentMethods,
    this.password,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'fullName': fullName,
        'addresses': addresses,
        'paymentMethods': paymentMethods,
        'password': password,
      };

  static User fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      email: doc['email'],
      fullName: doc['fullName'],
      addresses: (doc['addresses'] as List<dynamic>).cast<String>(),
      paymentMethods: (doc['paymentMethods'] as List<dynamic>).cast<String>(),
      password: doc['password'],
    );
  }
}
