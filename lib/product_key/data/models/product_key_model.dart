import '../../domain/entities/product_key.dart';

class ProductKeyModel extends ProductKey {
  const ProductKeyModel({
    required String key,
    String? assignedTo,
    String? phoneNumber,
  }) : super(key: key, assignedTo: assignedTo, phoneNumber: phoneNumber);

  factory ProductKeyModel.fromMap(Map<String, dynamic> map) {
    return ProductKeyModel(
      key: map['key'],
      assignedTo: map['assignedTo'],
      phoneNumber: map['phoneNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'assignedTo': assignedTo,
      'phoneNumber': phoneNumber,
    };
  }
}
