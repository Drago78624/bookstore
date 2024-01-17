import 'package:bookstore/controllers/admin/users_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> _showAddUserDialog() async {
  final _formKey = GlobalKey<FormState>();
  final userController = Get.find<UserController>();

  User _newUser = User(
    id: '',
    email: '',
    fullName: '',
    addresses: [],
    paymentMethods: [],
    password: '',
  );

  return Get.dialog(
    AlertDialog(
      title: Text('Add User'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Form fields for user data (email, fullName, etc.)
            // ...
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                await userController.addUser(_newUser);
                Get.back(); // Close dialog on success
                Get.snackbar('User Added', 'User added successfully');
              } catch (error) {
                // Handle errors
                Get.snackbar('Error', 'Failed to add user: $error');
              }
            }
          },
          child: Text('Add'),
        ),
      ],
    ),
  );
}

Future<void> _confirmDeleteUser(User user) async {
  final userController = Get.find<UserController>();
  return Get.dialog(
    AlertDialog(
      title: Text('Delete User'),
      content: Text('Are you sure you want to delete ${user.fullName}?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              await userController.deleteUser(user.id);
              Get.back(); // Close dialog on success
              Get.snackbar('User Deleted', 'User deleted successfully');
            } catch (error) {
              Get.snackbar('Error', 'Failed to delete user: $error');
            }
          },
          child: Text('Delete'),
        ),
      ],
    ),
  );
}
