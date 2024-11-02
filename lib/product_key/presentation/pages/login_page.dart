import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/product_key_cubit.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController keyController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Product Key'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/admin'),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: BlocListener<ProductKeyCubit, ProductKeyState>(
        listener: (context, state) {
          if (state is ProductKeyValid) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is ProductKeyInvalid) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product key not valid')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: keyController,
                decoration: const InputDecoration(labelText: 'Product Key'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final key = keyController.text.trim();
                  final name = nameController.text.trim();
                  final phone = phoneController.text.trim();
                  context
                      .read<ProductKeyCubit>()
                      .validateAndAssignKey(key, name, phone);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
