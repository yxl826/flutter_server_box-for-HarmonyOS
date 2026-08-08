/// In-memory no-op stub of flutter_secure_storage for HarmonyOS port.
///
/// Values are kept in a process-local map so that the hive encryption key
/// stays stable within a session (see fl_lib HiveStore._initCipher).

/// Platform option classes (API-compatible placeholders).
class AndroidOptions {
  const AndroidOptions({this.resetOnError = false});
  final bool resetOnError;
}

class IOSOptions {
  const IOSOptions({this.accessibility, this.accountName, this.synchronizable, this.groupId});
  final Object? accessibility;
  final String? accountName;
  final bool? synchronizable;
  final String? groupId;
}

class MacOsOptions {
  const MacOsOptions({this.accountName, this.synchronizable, this.accessibility, this.groupId});
  final String? accountName;
  final bool? synchronizable;
  final Object? accessibility;
  final String? groupId;
}

enum KeychainAccessibility {
  first_unlock,
  first_unlock_this_device,
  always,
  always_this_device,
  after_restart,
  when_unlocked,
  when_unlocked_this_device,
  when_passcode_set_this_device,
}

class FlutterSecureStorage {
  const FlutterSecureStorage({this.aOptions, this.iOptions, this.mOptions, this.wOptions, this.lOptions});

  final AndroidOptions? aOptions;
  final IOSOptions? iOptions;
  final MacOsOptions? mOptions;
  final Object? wOptions;
  final Object? lOptions;

  static final Map<String, String> _store = {};

  Future<String?> read({required String key, Map<String, String>? options}) async =>
      _store[key];

  Future<void> write({
    required String key,
    required String? value,
    Map<String, String>? options,
  }) async {
    if (value == null) {
      _store.remove(key);
    } else {
      _store[key] = value;
    }
  }

  Future<void> delete({required String key, Map<String, String>? options}) async =>
      _store.remove(key);

  Future<bool> containsKey({
    required String key,
    Map<String, String>? options,
  }) async =>
      _store.containsKey(key);

  Future<Map<String, String>> readAll({Map<String, String>? options}) async =>
      Map.of(_store);

  Future<void> deleteAll({Map<String, String>? options}) async => _store.clear();
}
