import '../entities/product_key.dart';

abstract class ProductKeyRepository {
  Future<bool> validateProductKey(String key);
  Future<void> assignProductKey(String key, String name, String phone);
  Future<List<ProductKey>> getAllProductKeys();
  Future<void> generateProductKey(String key);
  Future<void> deleteProductKey(String key);
}
