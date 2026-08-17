enum VerificationScenario {
  validSubmission,
  missingLineage,
  failClosedResponse,
}

extension VerificationScenarioX on VerificationScenario {
  String get label {
    switch (this) {
      case VerificationScenario.validSubmission:
        return 'Valid Submission';
      case VerificationScenario.missingLineage:
        return 'Missing Lineage';
      case VerificationScenario.failClosedResponse:
        return 'Fail-Closed Error';
    }
  }

  String get description {
    switch (this) {
      case VerificationScenario.validSubmission:
        return 'All required fields are present and the response is compliant.';
      case VerificationScenario.missingLineage:
        return 'predecessor_id is deliberately removed before submission.';
      case VerificationScenario.failClosedResponse:
        return 'The demo API returns an invalid response to prove fail-closed behavior.';
    }
  }
}
