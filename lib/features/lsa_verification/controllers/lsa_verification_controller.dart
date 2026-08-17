import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/security/hash_service.dart';
import '../../../core/security/security_validator.dart';
import '../../../core/storage/quarantine_storage.dart';
import '../../../core/network/verification_api.dart';
import '../models/quarantine_event.dart';
import '../models/verification_request.dart';
import '../models/verification_response.dart';
import '../models/verification_scenario.dart';
import '../services/friction_tracker.dart';

enum VerificationUiState {
  idle,
  submitting,
  success,
  blocked,
  failed,
}

class LsaVerificationController extends GetxController {
  LsaVerificationController({
    required this.apiFactory,
    required this.hashService,
    required this.securityValidator,
    required this.quarantineStorage,
  });

  final VerificationApi Function(VerificationScenario scenario) apiFactory;
  final HashService hashService;
  final SecurityValidator securityValidator;
  final QuarantineStorage quarantineStorage;

  final formKey = GlobalKey<FormState>();

  final profileIdController =
      TextEditingController(text: 'LSA-070826-001');
  final fullNameController =
      TextEditingController(text: 'Aarav Sharma');
  final emailController =
      TextEditingController(text: 'aarav.sharma@example.com');
  final phoneController =
      TextEditingController(text: '+91 98765 43210');
  final predecessorIdController =
      TextEditingController(text: 'PRE-070826-001');

  final selectedScenario = VerificationScenario.validSubmission.obs;
  final uiState = VerificationUiState.idle.obs;
  final statusMessage = ''.obs;
  final traceId = ''.obs;
  final logicHash = ''.obs;
  final frictionEventCount = 0.obs;
  final lastFrictionSeconds = 0.obs;
  final quarantineCount = 0.obs;
  final isObscured = false.obs;

  late final FrictionTracker _frictionTracker;

  final _uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();

    _frictionTracker = FrictionTracker(
      threshold: const Duration(seconds: 5),
      onFriction: _onFrictionDetected,
    );

    for (final controller in [
      profileIdController,
      fullNameController,
      emailController,
      phoneController,
      predecessorIdController,
    ]) {
      controller.addListener(_onPrimaryInputChanged);
    }
  }

  @override
  void onReady() {
    super.onReady();
    _loadQuarantineCount();
  }

  void _onPrimaryInputChanged() {
    _frictionTracker.userInteracted();
  }

  void _onFrictionDetected(Duration duration) {
    frictionEventCount.value++;
    lastFrictionSeconds.value = duration.inSeconds;

    Get.log(
      'FRICTION_EVENT: stall_seconds=${duration.inSeconds}, '
      'field=primary_profile_input',
    );

    statusMessage.value =
        'Friction event logged: ${duration.inSeconds}s stall.';
  }

  Future<void> _loadQuarantineCount() async {
    final events = await quarantineStorage.readAll();
    quarantineCount.value = events.length;
  }

  void selectScenario(VerificationScenario? scenario) {
    if (scenario == null) return;
    selectedScenario.value = scenario;
    resetState();
  }

  void toggleObscure() {
    isObscured.toggle();
  }

  void clearLineageForDemo() {
    predecessorIdController.clear();
    selectedScenario.value = VerificationScenario.missingLineage;
  }

  void restoreLineage() {
    predecessorIdController.text = 'PRE-070826-001';
    selectedScenario.value = VerificationScenario.validSubmission;
  }

  void resetState() {
    uiState.value = VerificationUiState.idle;
    statusMessage.value = '';
    traceId.value = '';
    logicHash.value = '';
  }

  Future<void> submitVerification() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (uiState.value == VerificationUiState.submitting) return;

    if (!(formKey.currentState?.validate() ?? false)) {
      await _quarantine(
        reason: 'Client validation failed before API submission.',
        payload: _currentPayload(),
      );
      _setBlocked('Submission blocked: required fields are invalid.');
      return;
    }

    final request = VerificationRequest(
      profileId: profileIdController.text.trim(),
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      predecessorId: predecessorIdController.text.trim().isEmpty
          ? null
          : predecessorIdController.text.trim(),
      verificationType: 'identity_and_credentials',
    );

    final payload = request.toJson();

    // Fail closed: no request leaves the client without lineage.
    final outboundValidation =
        securityValidator.validateOutboundPayload(payload);

    if (!outboundValidation.isValid) {
      await _quarantine(
        reason: outboundValidation.reason!,
        payload: payload,
      );
      _setBlocked(outboundValidation.reason!);
      return;
    }

    final generatedTraceId = _uuid.v4();
    final generatedLogicHash = hashService.sha256FromMap(payload);

    traceId.value = generatedTraceId;
    logicHash.value = generatedLogicHash;
    uiState.value = VerificationUiState.submitting;
    statusMessage.value = 'Running secure verification...';

    final headers = <String, String>{
      'trace_id': generatedTraceId,
      'logic_hash': generatedLogicHash,
    };

    try {
      final response = await apiFactory(selectedScenario.value).submit(
        request: request,
        headers: headers,
      );

      // Fail closed: null/invalid responses are quarantined and never
      // converted into a success state.
      final inboundValidation =
          securityValidator.validateInboundResponse(response);

      if (!inboundValidation.isValid) {
        await _quarantine(
          reason: inboundValidation.reason!,
          payload: <String, dynamic>{
            'request': payload,
            'headers': headers,
            'response': response == null ? null : _responseToMap(response),
          },
        );

        _setFailed(inboundValidation.reason!);
        return;
      }

      uiState.value = VerificationUiState.success;
      statusMessage.value = response!.message;
    } catch (error) {
      await _quarantine(
        reason: 'Network/API exception: $error',
        payload: <String, dynamic>{
          'request': payload,
          'headers': headers,
        },
      );

      _setFailed('Fail-closed: API call could not be completed.');
    }
  }

  Map<String, dynamic> _currentPayload() {
    return <String, dynamic>{
      'profile_id': profileIdController.text.trim(),
      'full_name': fullNameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'predecessor_id': predecessorIdController.text.trim().isEmpty
          ? null
          : predecessorIdController.text.trim(),
      'verification_type': 'identity_and_credentials',
    };
  }

  Map<String, dynamic> _responseToMap(VerificationResponse response) {
    return <String, dynamic>{
      'status': response.status,
      'verification_id': response.verificationId,
      'predecessor_id': response.predecessorId,
      'trace_id': response.traceId,
      'logic_hash': response.logicHash,
      'message': response.message,
    };
  }

  Future<void> _quarantine({
    required String reason,
    required Map<String, dynamic> payload,
  }) async {
    final event = QuarantineEvent(
      eventId: _uuid.v4(),
      reason: reason,
      createdAt: DateTime.now().toUtc(),
      payload: payload,
    );

    await quarantineStorage.save(event);
    quarantineCount.value++;
  }

  void _setBlocked(String message) {
    uiState.value = VerificationUiState.blocked;
    statusMessage.value = message;
  }

  void _setFailed(String message) {
    uiState.value = VerificationUiState.failed;
    statusMessage.value = message;
  }

  String? validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required.';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  String? validateLineage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'predecessor_id is mandatory for data lineage.';
    }
    return null;
  }

  Color get statusColor {
    switch (uiState.value) {
      case VerificationUiState.success:
        return Colors.green;
      case VerificationUiState.blocked:
      case VerificationUiState.failed:
        return Colors.red;
      case VerificationUiState.submitting:
        return Colors.orange;
      case VerificationUiState.idle:
        return Colors.blueGrey;
    }
  }

  String get statusLabel {
    switch (uiState.value) {
      case VerificationUiState.idle:
        return 'Ready';
      case VerificationUiState.submitting:
        return 'Processing';
      case VerificationUiState.success:
        return 'Verified';
      case VerificationUiState.blocked:
        return 'Blocked';
      case VerificationUiState.failed:
        return 'Quarantined';
    }
  }

  @override
  void onClose() {
    _frictionTracker.dispose();

    profileIdController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    predecessorIdController.dispose();

    super.onClose();
  }
}
