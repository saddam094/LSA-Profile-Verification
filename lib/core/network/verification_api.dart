import '../../features/lsa_verification/models/verification_request.dart';
import '../../features/lsa_verification/models/verification_response.dart';

abstract class VerificationApi {
  Future<VerificationResponse?> submit({
    required VerificationRequest request,
    required Map<String, String> headers,
  });
}
