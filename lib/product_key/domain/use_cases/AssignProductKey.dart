import '../repositories/product_key_repository.dart';

class AssignProductKey {
  final ProductKeyRepository repository;

  AssignProductKey(this.repository);

  Future<void> call(String key, String name, String phone) {
    return repository.assignProductKey(key, name, phone);
  }
}
