import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../device_id_helper.dart';
import '../../domain/use_cases/AssignProductKey.dart';
import '../../domain/use_cases/validate_product_key.dart';
import '../pages/CacheHelper.dart';

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
    String deviceId = await DeviceIdHelper.getDeviceId();

    final isValid = await validateProductKey(key, deviceId);
    if (isValid) {
      await assignProductKey(key, name, phone);

      // Cache the authentication data
      await CacheHelper.cacheAuthData(
        phone: phone,
        userId: key, // Using product key as userId for this example
        name: name, // Assuming 'name' can act as an identifier
      );

      emit(ProductKeyValid());
    } else {
      emit(ProductKeyInvalid());
    }
  }
}
