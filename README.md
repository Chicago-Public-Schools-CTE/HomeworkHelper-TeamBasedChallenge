# Homework Helper Accessibility Remediation Challenge

## Illinois Team-Based Challenge Brief

![App Demo](app_demo.gif)
### Client scenario

**Client:** A school district's Digital Learning and Accessibility Office, working with an educational technology partner.

**Business need:** Before Homework Helper is offered to all students, the client needs an accessibility compliance audit and a prioritized remediation plan. The team must evaluate the SwiftUI app against WCAG 2.2 AA-informed practices and Apple accessibility guidance, then demonstrate and verify selected fixes.

**Driving question:** How can our team make Homework Helper more usable for students who use VoiceOver, large text, motor accommodations, visual alternatives to audio, or reduced-motion settings—while preserving the app's core study-planning experience?

This is an authentic workplace simulation: the client expects a clear report, evidence of testing, recommended code changes, and a concise presentation that supports a go/no-go rollout decision.

> **Teacher setup:** Confirm the participating district or EdTech partner and the adult industry mentor before launch. The mentor must be an accessibility, UX, QA, mobile-development, or related professional who is not the assigned classroom teacher.

---

## Illinois TBC Alignment

Illinois Team-Based Challenges include an authentic community/business problem, meaningful interaction with an adult expert mentor, pathway-specific technical competency, cross-sector essential employability competency, student collaboration, and a final product or presentation. This challenge is designed to supply evidence for each element.

| TBC requirement | Evidence in this challenge |
|---|---|
| Authentic problem with a community or business partner | The client commissions an accessibility readiness audit before district-wide deployment. |
| Meaningful industry-mentor interaction | Mentor kickoff, design-review feedback, and final showcase; teams document feedback and their response. |
| Pathway-specific technical competency | Teams inspect a SwiftUI app, use accessibility tools, plan code remediation, and verify work with XCTest. |
| Essential Employability Skill | Teams demonstrate teamwork, problem solving, professional communication, and work ethic through shared artifacts and reflection. |
| Collaborative groups | Teams of 3–4 students use defined roles, a shared issue log, and review checkpoints. |
| Final solution product/presentation | Accessibility Audit Report, remediation evidence/pull request or patch, verification results, and client presentation. |

Use the district's approved **Illinois Information Technology Technical Competencies** and **Illinois Essential Employability Skills Framework** to select and record the exact competency identifiers assessed locally. The recommended evidence below supports an application-development, testing, usability/accessibility, and troubleshooting focus. See the [ISBE College and Career Pathway Endorsement resources](https://www.isbe.net/pathwayendorsements), [Team-Based Challenge step-by-step process](https://www.isbe.net/Documents/Career-Awareness-Career-Exp.pdf), and [Illinois PWR resources](https://www.isbe.net/pwr).

---

## Team Structure and Collaboration

Form teams of **3–4 students**. Assign one primary role per student; all team members contribute to the final audit, remediation decisions, and presentation.

| Role | Primary responsibilities | Evidence |
|---|---|---|
| Team Lead & Project Manager | Coordinates scope, meeting notes, issue-log ownership, synthesis, deadlines, and employability reflection. | Team plan, meeting notes, completed issue log. |
| VoiceOver & Screen Reader Specialist | Tests labels, values, traits, hints, reading order, and state announcements. | VoiceOver test notes and prioritized findings. |
| Visual & Motor Ergonomics Specialist | Tests Dynamic Type, contrast, color independence, touch targets, Reduce Motion, and visual alternatives to audio. | Screenshots, measurements, and Inspector findings. |
| SwiftUI Remediation & Verification Engineer | Traces root causes in `ContentView.swift`, implements approved fixes, and runs automated/manual verification. | Patch or pull request, XCTest/Inspector results. |

### Collaboration protocol

- Maintain one shared issue log with: issue ID, screen/feature, accessibility lens, reproduction steps, user impact, severity, owner, proposed fix, verification result, and mentor feedback.
- Hold a short stand-up at the start of each work session: completed work, next work, and blockers.
- Use peer review before a finding is included in the final report; a second team member must reproduce it.
- Record every mentor recommendation and state whether the team adopted, adapted, or deferred it with a reason.
- Use respectful, professional language that centers the user impact rather than blaming a person or a disability.

---

## Industry Mentor Touchpoints

| Checkpoint | Mentor interaction | Student output |
|---|---|---|
| Sprint 1 — Kickoff | Mentor introduces the client context, workplace expectations, and why accessibility matters to real users. | Team charter, clarifying questions, and initial audit scope. |
| Sprint 2 — Design Review | Teams present their highest-impact findings and proposed remediations; mentor gives actionable feedback. | Revised issue log and remediation plan with feedback response. |
| Sprint 4 — Final Showcase | Teams present the completed audit, demonstration, verification evidence, and remaining risks to the mentor/client panel. | Final report, presentation, and individual reflection. |

---

## Four-Phase Challenge Workflow

### Phase 1 — Team Formation and Discovery Audit

1. Review the client scenario, create a team charter, assign roles, and meet the mentor at kickoff.
2. Complete a feature walkthrough and run an initial Accessibility Inspector audit.
3. Audit each screen using the four lenses below.
4. Create a shared, evidence-based issue log and select the highest-impact findings for review.

**Phase deliverable:** Team charter, initial audit log, and mentor questions.

### Phase 2 — Root-Cause Analysis and Remediation Plan

1. Reproduce and prioritize findings by user impact, severity, frequency, and feasibility.
2. Trace selected findings to their likely SwiftUI implementation in `ContentView.swift`.
3. Propose code-level fixes and acceptance criteria; identify any tradeoffs or remaining risk.
4. Present the plan at the mentor design review and revise it from feedback.

**Phase deliverable:** Prioritized remediation plan with root cause, proposed fix, acceptance criteria, and mentor-feedback response.

### Phase 3 — Code Remediation and Verification

1. Implement the approved fixes in a branch or patch.
2. Re-test the affected screen with VoiceOver, Dynamic Type, visual/motor accommodations, muted audio, and Reduce Motion as applicable.
3. Run the Accessibility Inspector audit and an automated XCTest accessibility audit where available.
4. Have a teammate independently verify each resolved issue.

**Phase deliverable:** Remediated code/pull request or patch, before-and-after evidence, and verification record.

### Phase 4 — Executive Report and Client Presentation

1. Prepare a concise Accessibility Audit Report for the client.
2. Deliver a 5–8 minute presentation and live demonstration to the mentor/client panel.
3. Explain resolved issues, deferred risks, verification results, and the recommendation for rollout.
4. Complete an individual reflection on technical growth and Essential Employability Skills.

**Phase deliverable:** Final report, presentation, demonstration, issue log, and individual reflection.

---

## Required Final Deliverables

1. **Accessibility Audit Report** — executive summary; audit scope; prioritized findings; affected users; screenshots or Inspector evidence; standards/guidance consulted; recommended actions; and residual risk.
2. **Remediation Artifact** — a pull request, patch, or clearly documented code changes for the selected fixes in `ContentView.swift`.
3. **Verification Evidence** — Accessibility Inspector results, manual test notes, and XCTest accessibility-audit results when the project has a UI-test target.
4. **Industry Presentation** — client-ready slides or briefing with a live demonstration, mentor feedback response, and rollout recommendation.
5. **Individual Reflection** — evidence of teamwork, problem solving, communication, and professional responsibility.

### Suggested assessment evidence

| Dimension | Look-fors |
|---|---|
| Technical competency | Accurate inspection, defensible root-cause analysis, appropriate SwiftUI remediation, and repeatable verification. |
| Teamwork and work ethic | Clear roles, dependable follow-through, shared artifacts, and constructive peer review. |
| Problem solving | Findings are supported by evidence; recommendations are prioritized and feasible. |
| Professional communication | Report and presentation explain user impact, technical decisions, limitations, and mentor feedback clearly. |

---

## App Overview & Core Features

Homework Helper is a SwiftUI study companion with four primary functional areas:

1. **Home (Dashboard):** study tips, today's overview, focus goal, and a recent voice-memo preview.
2. **To-Do List:** assignment cards, completion and removal actions, task creation, priority sorting, and clear-all action.
3. **Study Timer:** focus countdown, start/pause control, session settings, and audio-alert indicator.
4. **Audio Notes:** classroom audio playback, status indicators, and upcoming-note schedule.

---

## The Four Accessibility Lenses

| Lens | Focus area | Audit questions |
|---|---|---|
| Visual | Blindness, low vision, color vision deficiency, bright sunlight | Can a screen reader convey all information and actions? Does text scale? Is information distinguishable without color, and is contrast sufficient? |
| Motor & Mobility | Tremor, limited dexterity, switch access | Are targets easy to activate? Can actions be completed without complex gestures? Can users navigate predictably? |
| Auditory | Deafness, hard of hearing, loud or silent environments | Do audio cues have text, visual, or haptic alternatives? Are alerts perceptible while muted? |
| Cognitive | Attention, learning, memory, executive function | Is the UI predictable? Are errors clear? Can motion be reduced? Are destructive actions reversible or confirmed? |

---

## Accessibility Tools and Technical Reference

### Accessibility Inspector

Use **Xcode → Open Developer Tool → Accessibility Inspector** to inspect a running Simulator or device app.

- Run **Audit** for common issues such as missing labels, contrast, hit targets, and Dynamic Type.
- Inspect each control's **Label**, **Value**, **Traits**, and **Hint**.
- Test with simulated settings including Invert Colors, Dynamic Type, Reduce Motion, Differentiate Without Color, and Bold Text.

### Device and Simulator Tests

- **VoiceOver:** Navigate with swipe left/right and activate with double-tap. Confirm controls announce meaningful labels, state, and actions.
- **Dynamic Type:** Enable Larger Accessibility Sizes and test at the maximum size for clipping, overlap, and usable reading order.
- **Color and contrast:** Enable Differentiate Without Color and Increase Contrast; confirm status is not color-only.
- **Motor access:** Evaluate target dimensions against the 44×44 pt Apple guidance and test Touch Accommodations or AssistiveTouch.
- **Audio alternatives:** Mute the device and verify that important audio alerts have another perceivable signal.
- **Reduce Motion:** Enable it and confirm nonessential motion is reduced or removed.

### XCTest accessibility audit

When a UI-test target is available, use an automated audit alongside manual testing:

```swift
func testAccessibilityAudit() throws {
    let app = XCUIApplication()
    app.launch()

    try app.performAccessibilityAudit()
}
```

Audits can be narrowed to categories such as `.contrast`, `.hitRegion`, `.dynamicType`, and `.elementDetection`.

### SwiftUI APIs to consider

| API / modifier | Purpose |
|---|---|
| `.accessibilityLabel(...)` | Gives a screen reader a meaningful description when visible text is absent or unclear. |
| `.accessibilityValue(...)` | Communicates a control's current state or value. |
| `.accessibilityHint(...)` | Explains the result of an interaction. |
| `.accessibilityAddTraits(...)` / `.accessibilityRemoveTraits(...)` | Corrects the semantic traits announced for an element. |
| `.accessibilityHidden(...)` | Removes decorative content from the accessibility tree. |
| `.accessibilityElement(children:)` | Combines or controls child semantics. |
| `.accessibilityAction(...)` | Adds a VoiceOver rotor action. |
| `@Environment(\\.accessibilityReduceMotion)` | Adapts custom animation to the user's Reduce Motion preference. |
| `@Environment(\\.dynamicTypeSize)` | Allows layouts to respond to the user's text-size preference. |

---

## Reference Resources

- [ISBE College and Career Pathway Endorsement: Team-Based Challenges and competency resources](https://www.isbe.net/pathwayendorsements)
- [ISBE Team-Based Challenge Step-by-Step Process](https://www.isbe.net/Documents/Career-Awareness-Career-Exp.pdf)
- [Apple Human Interface Guidelines: Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)
- [Apple Accessibility documentation](https://developer.apple.com/accessibility/)
- [W3C Web Content Accessibility Guidelines (WCAG) 2.2](https://www.w3.org/TR/WCAG22/)
