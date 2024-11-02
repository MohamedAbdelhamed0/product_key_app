import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/product_key.dart';
import '../../domain/repositories/product_key_repository.dart';
import '../models/product_key_model.dart';

class ProductKeyRepositoryImpl implements ProductKeyRepository {
  final FirebaseFirestore firestore;

  ProductKeyRepositoryImpl(this.firestore);

  @override
  Future<bool> validateProductKey(String key) async {
    final doc = await firestore.collection('product_keys').doc(key).get();
    return doc.exists && doc['assignedTo'] == null;
  }

  @override
  Future<void> assignProductKey(String key, String name, String phone) {
    return firestore.collection('product_keys').doc(key).update({
      'assignedTo': name,
      'phoneNumber': phone,
    });
  }

  @override
  Future<List<ProductKey>> getAllProductKeys() async {
    final querySnapshot = await firestore.collection('product_keys').get();
    return querySnapshot.docs
        .map((doc) => ProductKeyModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<void> generateProductKey(String key) {
    return firestore.collection('product_keys').doc(key).set({
      'key': key,
      'assignedTo': null,
      'phoneNumber': null,
    });
  }

  @override
  Future<void> deleteProductKey(String key) {
    return firestore.collection('product_keys').doc(key).delete();
  }
}
