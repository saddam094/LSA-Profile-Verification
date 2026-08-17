import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/lsa_verification_controller.dart';
import '../models/verification_scenario.dart';
import 'widgets/metrics_row.dart';
import 'widgets/profile_header.dart';
import 'widgets/scenario_selector.dart';
import 'widgets/security_status_card.dart';
import 'widgets/section_card.dart';
import 'widgets/verification_form.dart';

class LsaProfileVerificationScreen extends GetView<LsaVerificationController> {
  const LsaProfileVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LSA Profile Verification',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Chip(
                  avatar: Icon(
                    Icons.shield_outlined,
                    size: 16,
                    color: controller.statusColor,
                  ),
                  label: Text(controller.statusLabel),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ProfileHeader(),
                  const SizedBox(height: 14),
                  SectionCard(
                    title: 'Verification details',
                    subtitle:
                        'Complete the profile data required for a secure verification request.',
                    icon: Icons.verified_user_outlined,
                    child: VerificationForm(
                      formKey: controller.formKey,
                      profileIdController: controller.profileIdController,
                      fullNameController: controller.fullNameController,
                      emailController: controller.emailController,
                      phoneController: controller.phoneController,
                      predecessorIdController:
                          controller.predecessorIdController,
                      validateRequired: controller.validateRequired,
                      validateEmail: controller.validateEmail,
                      validateLineage: controller.validateLineage,
                      isObscured: controller.isObscured.value,
                      onToggleObscure: controller.toggleObscure,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SectionCard(
                    title: 'Security test harness',
                    subtitle:
                        'Use the three required interview scenarios without changing the architecture.',
                    icon: Icons.security_outlined,
                    child: Obx(
                      () => Column(
                        children: [
                          ScenarioSelector(
                            value: controller.selectedScenario.value,
                            onChanged: controller.selectScenario,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              controller.selectedScenario.value.description,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (controller.selectedScenario.value ==
                              VerificationScenario.missingLineage)
                            OutlinedButton.icon(
                              onPressed: controller.restoreLineage,
                              icon: const Icon(Icons.restore),
                              label: const Text('Restore predecessor_id'),
                            )
                          else
                            OutlinedButton.icon(
                              onPressed: controller.clearLineageForDemo,
                              icon: const Icon(Icons.account_tree_outlined),
                              label: const Text('Clear predecessor_id'),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => SecurityStatusCard(
                      statusLabel: controller.statusLabel,
                      statusMessage: controller.statusMessage.value,
                      statusColor: controller.statusColor,
                      traceId: controller.traceId.value,
                      logicHash: controller.logicHash.value,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => MetricsRow(
                      frictionCount: controller.frictionEventCount.value,
                      lastFrictionSeconds:
                          controller.lastFrictionSeconds.value,
                      quarantineCount: controller.quarantineCount.value,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Obx(
                    () => FilledButton.icon(
                      onPressed:
                          controller.uiState.value ==
                                  VerificationUiState.submitting
                              ? null
                              : controller.submitVerification,
                      icon: controller.uiState.value ==
                              VerificationUiState.submitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.verified_outlined),
                      label: Text(
                        controller.uiState.value ==
                                VerificationUiState.submitting
                            ? 'Verifying...'
                            : 'Submit for verification',
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Fail-closed rule: missing lineage or an invalid response is quarantined and never promoted to success.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
