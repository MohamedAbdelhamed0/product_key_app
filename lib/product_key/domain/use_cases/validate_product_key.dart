import '../repositories/product_key_repository.dart';

class ValidateProductKey {
  final ProductKeyRepository repository;

  ValidateProductKey(this.repository);

  Future<bool> call(String key) {
    return repository.validateProductKey(key);
  }
}
