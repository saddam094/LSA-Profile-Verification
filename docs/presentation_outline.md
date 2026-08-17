# 12-Slide Presentation Outline

## Slide 1 — LSA Profile Verification
- Candidate name
- Email
- Phone
- Flutter + GetX
- HabotConnect Hiring Project

## Slide 2 — Objective + Demo
- Secure LSA profile verification
- Stateless Material UI
- Embedded 2–3 minute demo video

## Slide 3 — Screen Walkthrough
- Profile information
- Predecessor ID
- Verification action
- Security status

## Slide 4 — Component Architecture
- Stateless screen
- Atomic widgets
- Controller
- Services
- Network boundary

## Slide 5 — Byt Boundary
- Presentation
- State/orchestration
- Security
- Network
- Persistence

## Slide 6 — API Data Flow
- Form
- Validation
- Metadata
- API
- Response gate

## Slide 7 — Metadata Headers
- `trace_id`: UUID
- `logic_hash`: SHA-256

## Slide 8 — Data Lineage
- `predecessor_id` required
- No request when missing
- Prevent orphan data

## Slide 9 — Fail-Closed
- Invalid/null response
- Quarantine
- Stop data movement
- Never mark verified

## Slide 10 — Friction Tracking
- Primary input interaction
- 5-second stall
- Friction event
- Event counter

## Slide 11 — Three Test Cases
- Valid Submission
- Missing Lineage
- Fail-Closed Error State
- Screenshots + expected results

## Slide 12 — Conclusion
- Requirements covered
- Repository link
- Thank you
