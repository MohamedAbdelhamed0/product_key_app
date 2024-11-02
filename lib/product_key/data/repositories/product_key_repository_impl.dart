import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../device_id_helper.dart';
import '../../domain/entities/product_key.dart';
import '../../domain/repositories/product_key_repository.dart';
import '../models/product_key_model.dart';

class ProductKeyRepositoryImpl implements ProductKeyRepository {
  final FirebaseFirestore firestore;

  ProductKeyRepositoryImpl(this.firestore);

  @override
  Future<bool> validateProductKey(String key, String deviceId) async {
    final doc = await firestore.collection('product_keys').doc(key).get();

    if (!doc.exists) {
      return false; // Product key does not exist
    }

    final data = doc.data() as Map<String, dynamic>;

    if (data['assignedTo'] == null) {
      // Product key is unassigned, allow assignment
      return true;
    } else if (data['deviceId'] == deviceId) {
      // Product key is assigned to this device
      return true;
    } else {
      // Product key is assigned to another device
      return false;
    }
  }

  @override
  Future<void> assignProductKey(String key, String name, String phone) async {
    String deviceId = await DeviceIdHelper.getDeviceId();

    return firestore.collection('product_keys').doc(key).update({
      'assignedTo': name,
      'phoneNumber': phone,
      'deviceId': deviceId, // Store the device ID
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
