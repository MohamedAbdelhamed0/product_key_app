import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/use_cases/AssignProductKey.dart';
import '../../domain/use_cases/validate_product_key.dart';

part 'product_key_state.dart';

class ProductKeyCubit extends Cubit<ProductKeyState> {
  final ValidateProductKey validateProductKey;
  final AssignProductKey assignProductKey;

  ProductKeyCubit({
    required this.validateProductKey,
    required this.assignProductKey,
  }) : super(ProductKeyInitial());

  Future<void> validateAndAssignKey(
      String key, String name, String phone) async {
    emit(ProductKeyLoading());
    final isValid = await validateProductKey(key);
    if (isValid) {
      await assignProductKey(key, name, phone);
      emit(ProductKeyValid());
    } else {
      emit(ProductKeyInvalid());
    }
  }
}
