import 'dart:convert';

import 'package:crypto/crypto.dart';

class HashService {
  String sha256FromMap(Map<String, dynamic> data) {
    final normalized = _normalize(data);
    return sha256.convert(utf8.encode(normalized)).toString();
  }

  String _normalize(Map<String, dynamic> data) {
    final keys = data.keys.toList()..sort();
    final parts = <String>[];

    for (final key in keys) {
      final value = data[key];
      parts.add('$key=${_normalizeValue(value)}');
    }

    return parts.join('&');
  }

  String _normalizeValue(dynamic value) {
    if (value == null) return '<null>';

    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return '{${_normalize(map)}}';
    }

    if (value is List) {
      return '[${value.map(_normalizeValue).join(',')}]';
    }

    return value.toString().trim();
  }
}
