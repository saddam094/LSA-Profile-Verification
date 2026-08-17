import '../../features/lsa_verification/models/verification_response.dart';

class SecurityValidationResult {
  const SecurityValidationResult.valid() : isValid = true, reason = null;

  const SecurityValidationResult.invalid(this.reason) : isValid = false;

  final bool isValid;
  final String? reason;
}

class SecurityValidator {
  SecurityValidationResult validateOutboundPayload(
    Map<String, dynamic> payload,
  ) {
    final predecessorId = payload['predecessor_id'];

    if (predecessorId is! String || predecessorId.trim().isEmpty) {
      return const SecurityValidationResult.invalid(
        'Data lineage failed: predecessor_id is required.',
      );
    }

    final requiredFields = <String>[
      'profile_id',
      'full_name',
      'email',
      'phone',
      'verification_type',
    ];

    for (final field in requiredFields) {
      final value = payload[field];
      if (value == null || value.toString().trim().isEmpty) {
        return SecurityValidationResult.invalid(
          'Compliance failed: $field is missing or invalid.',
        );
      }
    }

    return const SecurityValidationResult.valid();
  }

  SecurityValidationResult validateInboundResponse(
    VerificationResponse? response,
  ) {
    if (response == null) {
      return const SecurityValidationResult.invalid(
        'Fail-closed: API response is null.',
      );
    }

    if (response.status != 'verified') {
      return SecurityValidationResult.invalid(
        'Fail-closed: unexpected status "${response.status}".',
      );
    }

    final values = <String, String>{
      'verification_id': response.verificationId,
      'predecessor_id': response.predecessorId,
      'trace_id': response.traceId,
      'logic_hash': response.logicHash,
      'message': response.message,
    };

    for (final entry in values.entries) {
      if (entry.value.trim().isEmpty) {
        return SecurityValidationResult.invalid(
          'Fail-closed: required response field "${entry.key}" is empty.',
        );
      }
    }

    return const SecurityValidationResult.valid();
  }
}
