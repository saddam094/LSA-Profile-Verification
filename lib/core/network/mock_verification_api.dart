import '../../features/lsa_verification/models/verification_request.dart';
import '../../features/lsa_verification/models/verification_response.dart';
import 'verification_api.dart';
import '../../features/lsa_verification/models/verification_scenario.dart';

class MockVerificationApi implements VerificationApi {
  MockVerificationApi({required this.scenario});

  final VerificationScenario scenario;

  @override
  Future<VerificationResponse?> submit({
    required VerificationRequest request,
    required Map<String, String> headers,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    switch (scenario) {
      case VerificationScenario.validSubmission:
        return VerificationResponse(
          status: 'verified',
          verificationId: 'VER-${request.profileId}',
          predecessorId: request.predecessorId!,
          traceId: headers['trace_id']!,
          logicHash: headers['logic_hash']!,
          message: 'LSA profile verification accepted.',
        );

      case VerificationScenario.missingLineage:
        // Normally this scenario is blocked before the API is called.
        return null;

      case VerificationScenario.failClosedResponse:
        // Deliberately invalid response to prove fail-closed handling.
        return VerificationResponse(
          status: 'verified',
          verificationId: '',
          predecessorId: request.predecessorId!,
          traceId: headers['trace_id']!,
          logicHash: headers['logic_hash']!,
          message: 'Malformed demo response.',
        );
    }
  }
}
