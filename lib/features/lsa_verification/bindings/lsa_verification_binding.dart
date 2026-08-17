import 'package:get/get.dart';

import '../../../core/network/mock_verification_api.dart';
import '../../../core/security/hash_service.dart';
import '../../../core/security/security_validator.dart';
import '../../../core/storage/quarantine_storage.dart';
import '../controllers/lsa_verification_controller.dart';

class LsaVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HashService>(() => HashService(), fenix: true);
    Get.lazyPut<SecurityValidator>(() => SecurityValidator(), fenix: true);
    Get.lazyPut<QuarantineStorage>(() => QuarantineStorage(), fenix: true);

    Get.lazyPut<LsaVerificationController>(
      () => LsaVerificationController(
        apiFactory: (scenario) => MockVerificationApi(scenario: scenario),
        hashService: Get.find<HashService>(),
        securityValidator: Get.find<SecurityValidator>(),
        quarantineStorage: Get.find<QuarantineStorage>(),
      ),
      fenix: true,
    );
  }
}
