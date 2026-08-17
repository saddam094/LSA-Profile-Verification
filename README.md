# LSA Profile Verification — HabotConnect Hiring Project

Flutter/GetX implementation of the requirements in the provided Hiring Project Form for **Digivir - Flutter Mobile App Developer**.

> The supplied PDF specifies the functional requirements, but it does not provide a complete visual Figma specification in the parsed content. Therefore, the UI below is an original Material 3 implementation of an LSA Profile Verification screen, not a claim of pixel-perfect Figma reproduction.

## Requirements covered

- Stateless Flutter UI widgets.
- GetX state management in a dedicated controller.
- Modular atomic components ("Byt" boundary interpretation).
- API request model and HTTP client.
- Mandatory `trace_id` UUID header.
- Mandatory `logic_hash` SHA-256 header.
- `predecessor_id` data-lineage validation before the request.
- Fail-closed validation for null/invalid API responses.
- Quarantine persistence for rejected/invalid data.
- >5-second UI friction event tracking.
- Three interview demo scenarios:
  1. Valid Submission
  2. Missing Lineage
  3. Fail-Closed Error State
- Unit tests for security and hashing logic.

## Dependencies

The project uses current stable package versions checked from pub.dev at preparation time:

- GetX 4.7.3
- http 1.6.0
- crypto 3.0.7
- uuid 4.6.0
- shared_preferences 2.5.5

## Run

1. Create a fresh Flutter shell if needed:

```bash
flutter create .
```

2. Replace/add the files from this repository.
3. Run:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## API

The assignment requires HTTP/API submission logic, but the PDF does not provide an actual endpoint, request contract, or backend URL. Therefore:

- `MockVerificationApi` is the default demo API so all three test cases can be demonstrated offline.
- `HttpVerificationApi` is included as the production HTTP implementation.
- Replace `AppConstants.defaultBaseUrl` and adapt the response mapping when the real API contract is supplied.

## Security flow

```text
Form input
   |
   v
Client validation
   |
   v
predecessor_id != null/empty
   |
   +---- FAIL ----> Quarantine + STOP
   |
   v
Generate trace_id UUID
   |
   v
Generate logic_hash SHA-256
   |
   v
HTTP/API submission
   |
   v
Response validation
   |
   +---- FAIL ----> Quarantine + STOP
   |
   v
Verified state
```

## Why GetX does not violate the UI stateless requirement

The PDF explicitly asks for a stateless Flutter/Dart widget. The screen and all reusable UI components in this project are `StatelessWidget`/`GetView`. State, timers, controllers and orchestration live outside the UI in `LsaVerificationController`.

This preserves a stateless presentation layer while still implementing the required 5-second listener and reactive UI.

## Demo cases

### 1. Valid Submission

Keep `predecessor_id` populated and select **Valid Submission**. Tap **Submit for verification**.

Expected:
- UUID generated.
- SHA-256 generated.
- API call runs.
- Valid response is accepted.
- UI becomes `Verified`.

### 2. Missing Lineage

Select **Missing Lineage** and clear `predecessor_id`.

Expected:
- Request is blocked before API submission.
- Data is written to quarantine storage.
- UI becomes `Blocked`.
- No success state is possible.

### 3. Fail-Closed Error

Restore `predecessor_id`, select **Fail-Closed Error**, and submit.

Expected:
- Demo API returns a malformed response.
- Response validation fails because `verification_id` is empty.
- Response/request metadata is quarantined.
- UI becomes `Quarantined`.
- No success state is possible.

## Friction tracking

Interact with the primary input fields, then stop interacting for more than 5 seconds. The `FrictionTracker` emits a friction event and the dashboard count increases.

## Important submission note

Do not claim that the provided PDF supplied an exact Figma layout if the company has not separately shared the referenced sample design. The PDF text only says to review a sample Figma wireframe description; it does not expose the actual design specification in the PDF content available here.
