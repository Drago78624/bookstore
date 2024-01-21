import 'package:bookstore/controllers/admin/users_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final UserController userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: userController.users.length,
          itemBuilder: (context, index) {
            final user = userController.users[index];
            return UserCard(user: user);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

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
              TextFormField(
                initialValue: _newUser.email, // Use initialValue for editing
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@')) {
                    return 'Invalid email address';
                  }
                  return null;
                },
                onSaved: (value) => _newUser.email = value!,
              ),
              TextFormField(
                initialValue: _newUser.fullName,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Full name is required';
                  }
                  return null;
                },
                onSaved: (value) => _newUser.fullName = value!,
              ),
              // Addresses (consider using a list builder for multiple fields)
              TextFormField(
                initialValue: _newUser.addresses
                    .join(', '), // Combine addresses for display
                decoration: InputDecoration(labelText: 'Addresses'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'At least one address is required';
                  }
                  return null;
                },
                onSaved: (value) =>
                    _newUser.addresses = value!.split(', '), // Split into list
              ),
              // Payment Methods (consider using a list builder or dropdown)
              TextFormField(
                initialValue:
                    _newUser.paymentMethods.join(', '), // Combine for display
                decoration: InputDecoration(labelText: 'Payment Methods'),
                validator: (value) {
                  // Add validation if needed, e.g., ensuring specific formats
                  return null;
                },
                onSaved: (value) => _newUser.paymentMethods =
                    value!.split(', '), // Split into list
              ),
              // Password (consider using a secure input widget)
              TextFormField(
                initialValue: _newUser.password,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  // Add additional password strength validation if needed
                  return null;
                },
                onSaved: (value) => _newUser.password = value!,
              ),
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
                _formKey.currentState!.save();
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
}

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({required this.user});

  Future<void> _showUpdateUserDialog(User userToUpdate) async {
    final _formKey = GlobalKey<FormState>();
    final userController = Get.find<UserController>();

    User _updatedUser = userToUpdate; // Copy to avoid modifying original

    return Get.dialog(
      AlertDialog(
        title: Text('Update User'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Email (allow editing for potential changes)
              TextFormField(
                initialValue: _updatedUser.email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@')) {
                    return 'Invalid email address';
                  }
                  return null;
                },
                onSaved: (value) => _updatedUser.email = value!,
              ),
              // Full Name (allow editing)
              TextFormField(
                initialValue: _updatedUser.fullName,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Full name is required';
                  }
                  return null;
                },
                onSaved: (value) => _updatedUser.fullName = value!,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _updatedUser.addresses.length,
                  itemBuilder: (context, index) {
                    final address = _updatedUser.addresses[index];
                    return TextFormField(
                      initialValue: address,
                      decoration:
                          InputDecoration(labelText: 'Address ${index + 1}'),
                      validator: (value) {
                        // Add address validation if needed
                        return null;
                      },
                      onSaved: (value) =>
                          _updatedUser.addresses[index] = value!,
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _updatedUser.paymentMethods.length,
                  itemBuilder: (context, index) {
                    final paymentMethod = _updatedUser.paymentMethods[index];
                    return TextFormField(
                      initialValue: paymentMethod,
                      decoration: InputDecoration(
                          labelText: 'Payment Method ${index + 1}'),
                      validator: (value) {
                        // Add payment method validation if needed
                        return null;
                      },
                      onSaved: (value) =>
                          _updatedUser.paymentMethods[index] = value!,
                    );
                  },
                ),
              ),
              // Password (allow optional editing for password changes)
              TextFormField(
                initialValue: _updatedUser.password,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password (optional)'),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    // Add password strength validation if needed
                  }
                  return null;
                },
                onSaved: (value) => _updatedUser.password = value!,
              ),
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
                _formKey.currentState!.save();
                try {
                  await userController.updateUser(_updatedUser);
                  Get.back(); // Close dialog on success
                  Get.snackbar('User Updated', 'User updated successfully');
                } catch (error) {
                  // Handle errors
                  Get.snackbar('Error', 'Failed to update user: $error');
                }
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user.fullName),
        subtitle: Text(user.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit button
            IconButton(
              onPressed: () => _showUpdateUserDialog(user),
              icon: Icon(Icons.edit),
            ),
            // Delete button (with admin-specific logic)
            IconButton(
              onPressed: () => _confirmDeleteUser(user),
              icon: Icon(Icons.delete),
            ),
          ],
        ),
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
}
