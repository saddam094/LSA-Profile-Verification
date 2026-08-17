import 'package:flutter/material.dart';

import '../../models/verification_scenario.dart';

class ScenarioSelector extends StatelessWidget {
  const ScenarioSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final VerificationScenario value;
  final ValueChanged<VerificationScenario?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<VerificationScenario>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: 'Demo test case',
        prefixIcon: Icon(Icons.science_outlined),
      ),
      items: VerificationScenario.values
          .map(
            (scenario) => DropdownMenuItem<VerificationScenario>(
              value: scenario,
              child: Text(scenario.label),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
