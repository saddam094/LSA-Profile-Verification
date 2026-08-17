# Architecture / Byt Boundary Map

## Presentation boundary
- `views/lsa_profile_verification_screen.dart`
- `views/widgets/*`

These are stateless widgets. They render state and dispatch user intent.

## State/orchestration boundary
- `controllers/lsa_verification_controller.dart`

Owns reactive state, validation orchestration, friction tracking lifecycle and submission flow.

## Security boundary
- `core/security/security_validator.dart`
- `core/security/hash_service.dart`

Outbound lineage and compliance validation happens before API submission. Inbound responses are validated before any success state.

## Network boundary
- `core/network/verification_api.dart`
- `core/network/http_verification_api.dart`
- `core/network/mock_verification_api.dart`

The controller depends on the interface, allowing the demo API and production HTTP API to be swapped.

## Persistence/quarantine boundary
- `core/storage/quarantine_storage.dart`

Rejected data is persisted for inspection instead of being silently discarded.

## Data lineage

`predecessor_id` is mandatory and is checked before the HTTP boundary. This prevents orphaned verification events.

## Metadata lineage

`trace_id` is a UUID generated per outbound request.

`logic_hash` is a SHA-256 digest of the normalized outbound payload. The canonicalization is deterministic so the same payload produces the same hash.

## Fail-closed

There are two gates:

1. Outbound gate — missing/invalid required fields or lineage stops the request.
2. Inbound gate — null/invalid response stops success and quarantines the event.
