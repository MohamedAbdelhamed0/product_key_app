import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceIdHelper {
  static const _storageKey = 'device_unique_id';
  static final _storage = const FlutterSecureStorage();

  static Future<String> getDeviceId() async {
    String? deviceId = await _storage.read(key: _storageKey);
    if (deviceId == null) {
      // Generate a new UUID
      deviceId = const Uuid().v4();
      await _storage.write(key: _storageKey, value: deviceId);
    }
    return deviceId;
  }
}
