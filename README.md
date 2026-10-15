# Homework Helper — Accessible App Design Sprint

![App Demo](app_demo.gif)

## CPS × Apple Team-Based Challenge

**Date:** October 22, 2026 · 9:45 AM – 1:10 PM
**Location:** Truman College, 1145 W. Wilson Ave., Chicago, IL 60640
**Pathways:** Information Technology (IT) · Manufacturing, Engineering, Technology & Trades (METT)
**Teams:** 3–5 students per team, ~25 teams (~100 students total)

## Essential Question

> Who is locked out of this app, and what will it take to let them in?

## The Challenge

Digital products exclude users when accessibility is omitted during design and development. Today your team will audit this pre-built Homework Helper app — which contains intentional accessibility barriers — through **one assigned accessibility lens**. You'll find where the app fails that lens, pick the barrier that matters most, and use Xcode, SwiftUI, and Xcode's built-in AI coding tools to build, prototype, test, or document a fix. Apple engineers, designers, and accessibility reviewers will mentor your team and judge your final pitch.

You don't need prior coding experience — Xcode's AI agent can help generate and refactor code. Your job is to think critically about the accessibility problem, direct the tool, and verify what it gives you.

### Student Learning Targets

By the end of the challenge, you will be able to:

- Identify a specific accessibility barrier in a digital product.
- Explain how that barrier affects a user completing a specific task.
- Use evidence to prioritize an improvement.
- Use Xcode, SwiftUI, and AI tools to build, prototype, test, or document an accessibility improvement.
- Communicate a recommendation to an authentic audience.
- Use feedback to identify a next step for testing or improvement.

---

## Team Roles

Every team fills four roles:

| Role | Responsibility |
|---|---|
| Auditor | Identifies barriers in the app and records evidence in the Accessibility Audit Log. |
| Driver | Hands-on at the keyboard — writes code, builds, prototypes, or tests the fix in Xcode and SwiftUI. |
| Navigator | Guides without typing — directs AI prompting and testing, and calls the next step. |
| Reporter | Organizes the recommendation and leads the team's presentation. |

## Your Accessibility Lens

Each team is assigned one lens for the day — it's on your Team Card. Homework Helper's planted flaws are organized around Apple's five accessibility categories:

- **Vision** — blindness, low vision, color vision deficiency: VoiceOver, Dynamic Type, contrast, Display & Motion settings
- **Hearing** — deafness, hard of hearing: captions, transcripts, visual or haptic alternatives to sound
- **Speech** — users who can't or prefer not to speak aloud: Live Speech, Personal Voice, Vocal Shortcuts
- **Mobility** — tremor, limited dexterity: touch targets, gesture alternatives, Switch Control, Voice Control
- **General** — attention, memory, focus: predictable UI, plain-language errors, reduced distractions

For every barrier you find within your lens, record it in the Accessibility Audit Log: the issue, where it is in the app, who's affected, what task becomes difficult or impossible, its severity (Low/Medium/High), and the evidence, test, or standard behind it. Then pick the one barrier your team will fix.

---

## Schedule

| Time | Segment | Details |
|---|---|---|
| 9:45 – 10:00 AM | Student Check-in | Arrive and check in. |
| 10:00 – 10:05 AM | Welcome & Seating | Seating by sprint team. |
| 10:05 – 10:20 AM | Apple Accessibility Overview | Apple's team introduces inclusive design, innovation principles, and accessibility features. |
| 10:20 – 10:30 AM | Challenge Launch | Sprint instructions, role claims, lens assignment. |
| 10:30 – 10:45 AM | Accessibility Audit | Audit Homework Helper through your assigned lens; log findings. |
| 10:45 – 11:45 AM | App Fix & AI Prototyping Sprint | Build and test a fix in Xcode/SwiftUI with AI tools; log every prompt. |
| 11:45 AM – 12:15 PM | Lunch Break | Pizza provided. |
| 12:15 – 1:00 PM | Team Presentations & Judging | Deliver your 90-second pitch and demo to the judge panel. |
| 1:00 – 1:10 PM | Wrap-Up | Feedback, scores, departure. |

## Required Team Deliverables

- **Accessibility Audit Log** — barriers found within your lens, severity, affected users, and evidence.
- **AI Prompt and Testing Log** — every prompt you gave the AI, what it returned, what you tested, and what you verified before trusting it.
- **An accessible app fix, prototype, or design specification** resolving your team's chosen barrier.
- **A one-slide recommendation** summarizing the problem, the solution, and its impact.
- **A 90-second technical pitch** to the judge panel.
- **An individual reflection** from each team member.

### The 90-Second Pitch

Your pitch must make four things clear: the barrier, the affected user, the improvement, and the decision — what should happen next.

| Time | Content |
|---|---|
| 0 – 20s | Name the barrier and the affected user |
| 20 – 45s | Explain the selected improvement |
| 45 – 65s | Demonstrate the fix or prototype |
| 65 – 90s | State the recommendation and next step |

### Using AI Tools in Xcode

Xcode's built-in AI agent can help you generate and refactor code — never coded before? No problem. But don't trust its output blindly. Before you rely on an AI-suggested change, verify it:

- Does it actually fix the barrier you identified?
- Does it create a new barrier?
- Can your team explain what the tool did and what you decided?

Log every attempt in the AI Prompt and Testing Log.

---

## Accessibility Tools and Technical Reference

### Accessibility Inspector

Use **Xcode → Open Developer Tool → Accessibility Inspector** to inspect a running Simulator or device app.

- Run **Audit** for common issues such as missing labels, contrast, hit targets, and Dynamic Type.
- Inspect each control's **Label**, **Value**, **Traits**, and **Hint**.
- Test with simulated settings including Invert Colors, Dynamic Type, Reduce Motion, Differentiate Without Color, and Bold Text.

### Device and Simulator Tests

- **VoiceOver (Vision):** Navigate with swipe left/right and activate with double-tap. Confirm controls announce meaningful labels, state, and actions.
- **Dynamic Type (Vision):** Enable Larger Accessibility Sizes and test at the maximum size for clipping, overlap, and usable reading order.
- **Color and contrast (Vision):** Enable Differentiate Without Color and Increase Contrast; confirm status is not color-only.
- **Reduce Motion (Vision):** Enable it and confirm nonessential motion and flashing are reduced or removed.
- **Audio alternatives (Hearing):** Mute the device and verify that important audio alerts and recordings have a captioned or visual equivalent.
- **Spoken input (Speech):** Confirm no action requires the user to speak, and that any voice-driven shortcut has a typed or tapped equivalent.
- **Touch and gesture access (Mobility):** Evaluate target dimensions against the 44×44 pt Apple guidance and test Switch Control, Voice Control, or AssistiveTouch.
- **Predictability and errors (General):** Confirm error messages are plain-language and destructive actions are confirmed or reversible.

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
- [Apple Accessibility (overview of Vision, Hearing, Speech, Mobility, and General features)](https://www.apple.com/accessibility/)
- [Apple Human Interface Guidelines: Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)
- [Apple Accessibility developer documentation](https://developer.apple.com/accessibility/)
- [W3C Web Content Accessibility Guidelines (WCAG) 2.2](https://www.w3.org/TR/WCAG22/)
