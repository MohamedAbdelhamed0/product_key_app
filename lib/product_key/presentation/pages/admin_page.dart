import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController newKeyController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPasswordDialog());
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String enteredPassword = '';
        return BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
          child: AlertDialog(
            title: const Text('Admin Login'),
            content: TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Enter Password'),
              onChanged: (value) {
                enteredPassword = value;
              },
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              TextButton(
                child: const Text('Submit'),
                onPressed: () {
                  _validatePassword(enteredPassword);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _validatePassword(String password) {
    const adminPassword =
        'YourSecurePassword'; // Replace with your actual password

    if (password == adminPassword) {
      Navigator.of(context).pop(); // Close the dialog
      // Access granted
    } else {
      Navigator.of(context).pop(); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect password')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> generateProductKey(BuildContext context) async {
    final key = newKeyController.text.trim();
    if (key.isNotEmpty) {
      firestore.collection('product_keys').doc(key).set({
        'key': key,
        'assignedTo': null,
        'phoneNumber': null,
        'deviceId': null,
      });
      newKeyController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product key generated')),
      );
    }
  }

  void deleteProductKey(String key) {
    firestore.collection('product_keys').doc(key).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('product_keys').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('An error occurred'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No product keys found'));
                }

                final keys = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: keys.length,
                  itemBuilder: (context, index) {
                    final data = keys[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text('Key: ${data['key']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'State: ${data['assignedTo'] != null ? 'Assigned' : 'Unassigned'}'),
                          if (data['assignedTo'] != null)
                            Text('Assigned To: ${data['assignedTo']}'),
                          if (data['phoneNumber'] != null)
                            Text('Phone Number: ${data['phoneNumber']}'),
                          // Include any other details here
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteProductKey(data['key']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newKeyController,
                    decoration:
                        const InputDecoration(labelText: 'New Product Key'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => generateProductKey(context),
                  child: const Text('Generate'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
