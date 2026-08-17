import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';
import '../../features/lsa_verification/models/verification_request.dart';
import '../../features/lsa_verification/models/verification_response.dart';
import 'verification_api.dart';

class HttpVerificationApi implements VerificationApi {
  HttpVerificationApi({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConstants.defaultBaseUrl;

  final http.Client _client;
  final String _baseUrl;

  @override
  Future<VerificationResponse?> submit({
    required VerificationRequest request,
    required Map<String, String> headers,
  }) async {
    final uri = Uri.parse('$_baseUrl${AppConstants.apiPath}');

    final response = await _client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        ...headers,
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpVerificationException(
        'HTTP ${response.statusCode}: request rejected.',
      );
    }

    if (response.body.trim().isEmpty) {
      return null;
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map) {
      return null;
    }

    return VerificationResponse.fromJson(
      Map<String, dynamic>.from(decoded),
    );
  }
}

class HttpVerificationException implements Exception {
  const HttpVerificationException(this.message);

  final String message;

  @override
  String toString() => message;
}
