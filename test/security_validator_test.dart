import 'package:flutter_test/flutter_test.dart';
import 'package:lsa_profile_verification/core/security/security_validator.dart';
import 'package:lsa_profile_verification/features/lsa_verification/models/verification_response.dart';

void main() {
  final validator = SecurityValidator();

  test('blocks missing predecessor_id', () {
    final result = validator.validateOutboundPayload({
      'profile_id': 'LSA-1',
      'full_name': 'Test User',
      'email': 'test@example.com',
      'phone': '1234567890',
      'predecessor_id': null,
      'verification_type': 'identity_and_credentials',
    });

    expect(result.isValid, false);
    expect(result.reason, contains('predecessor_id'));
  });

  test('accepts a valid outbound payload', () {
    final result = validator.validateOutboundPayload({
      'profile_id': 'LSA-1',
      'full_name': 'Test User',
      'email': 'test@example.com',
      'phone': '1234567890',
      'predecessor_id': 'PRE-1',
      'verification_type': 'identity_and_credentials',
    });

    expect(result.isValid, true);
  });

  test('blocks malformed inbound response', () {
    final response = VerificationResponse(
      status: 'verified',
      verificationId: '',
      predecessorId: 'PRE-1',
      traceId: 'trace',
      logicHash: 'hash',
      message: 'bad',
    );

    final result = validator.validateInboundResponse(response);

    expect(result.isValid, false);
    expect(result.reason, contains('verification_id'));
  });
}
