import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/lsa_verification/models/quarantine_event.dart';
import '../constants/app_constants.dart';

class QuarantineStorage {
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<void> save(QuarantineEvent event) async {
    final current =
        await _preferences.getStringList(AppConstants.storageQuarantineKey) ??
        <String>[];

    current.add(jsonEncode(event.toJson()));

    // Keep the demo bounded.
    final bounded = current.length > 50
        ? current.sublist(current.length - 50)
        : current;

    await _preferences.setStringList(
      AppConstants.storageQuarantineKey,
      bounded,
    );
  }

  Future<List<QuarantineEvent>> readAll() async {
    final current =
        await _preferences.getStringList(AppConstants.storageQuarantineKey) ??
        <String>[];

    return current
        .map(
          (item) => QuarantineEvent.fromJson(
            Map<String, dynamic>.from(jsonDecode(item) as Map),
          ),
        )
        .toList()
        .reversed
        .toList();
  }
}
