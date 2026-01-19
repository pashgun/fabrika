# Handoff: PM Lead → UI Engineer (MVP Scope)

## Phase Summary
**Phase**: Phase 1 - Research & Requirements (MVP)
**Agent**: pm_lead (Research-First Protocol)
**Status**: COMPLETE ✅
**Date**: 2026-01-19

## Scope Change: MVP Focus

**Important**: Используем **MVP scope** (backlog_mvp.md), не full v1.0 (backlog.md).

### MVP Includes:
- ✅ Liquid Glass Design
- ✅ FSRS Review Session
- ✅ Manual Card CRUD
- ✅ Interactive Widget (killer feature)
- ✅ Onboarding (3 screens)
- ✅ Paywall (Adapty)
- ✅ Settings

### Deferred to v1.1:
- 🔮 AI Auto-Creation (OCR → Card)
- 🔮 Statistics Dashboard
- 🔮 CloudKit Sync

## Deliverables Created
- [x] **backlog_mvp.md** — MVP requirements (~900 lines)
- [x] **backlog.md** — full v1.0 vision (reference)
- [x] **Open Source Foundation** — FSRS, widget examples, flashcard refs
- [x] **Reddit Research** — Anki/Mochi user complaints
- [x] **Competitive Analysis** — 4 competitors
- [x] **Technical Requirements** — SwiftData models, frameworks, Adapty setup

## Executive Summary: MVP

**ZenCards MVP** — "Beautiful Anki" с killer feature: **Interactive Widget**.

### 🎯 Core Differentiation (MVP)
1. **Liquid Glass UI** — beats Anki's 2010 design
2. **Interactive Widget** — никто из competitors не имеет (unique!)
3. **FSRS Algorithm** — modern spaced repetition vs SM-2

### 🎨 Design Philosophy
- **Emotion**: Zen, Calm, Focus
- **Colors**: Teal/Green (NOT Anki blues, NOT Mochi purples)
- **Materials**: iOS 26 Liquid Glass
- **Typography**: SF Pro Rounded
- **Dark Mode Only** (simplifies MVP)

---

## For Next Agent: MVP Priority Screens

### Priority 1 (Critical Path) ⭐⭐⭐

#### 1. **Onboarding (3 Screens)**
**Why Critical**: First impression — must show value in 30 seconds.

**Screens**:
1. **Welcome**:
   - Hero: ZenCards logo + Liquid Glass background
   - Headline: "Beautiful Spaced Repetition"
   - Subheadline: "Learn smarter, not harder"
   - CTA: "Get Started"

2. **Feature Highlight**:
   - Visual: Mock review session (flip animation preview)
   - Headline: "Modern Algorithm"
   - Text: "FSRS helps you remember long-term"
   - Skip button (top-right)

3. **Value Prop**:
   - Visual: Beautiful UI showcase (Liquid Glass materials)
   - Headline: "Flashcards you'll love using"
   - Text: "Gorgeous design meets powerful learning"
   - CTA: "Start Learning" → Paywall

**Design Notes**:
- Page indicators (dots)
- Swipe or Next button navigation
- Skip button on all screens (goes to Paywall)

---

#### 2. **Paywall (Adapty Template Reference)**
**Why Critical**: Monetization — показываем после onboarding.

**Note**: Используем Adapty Paywall Builder (no custom UI), но нужны визуальные референсы для branding.

**Elements**:
- Headline: "Unlock Beautiful Learning"
- Features list:
  - ✅ Unlimited decks & cards
  - ✅ FSRS spaced repetition
  - ✅ Liquid Glass design (exclusive)
  - ✅ Interactive Home Screen widget
  - 🔮 Cloud sync (coming soon)
  - 🔮 AI auto-creation (coming soon)
- Pricing: $4.99/mo or $39.99/year (save 33%)
- Trust signals: "Cancel anytime", "7-day refund"
- Restore purchases link

**Design**: Adapty handles UI, just provide color scheme + logo.

---

#### 3. **Review Session Screen**
**Why Critical**: Core experience — 80% of user time.

**UI States**:
- **Front State**:
  - Card front text (question/context)
  - Minimalist design (no distractions)
  - "Tap to flip" hint (subtle, bottom)

- **Back State**:
  - Card back text (answer/definition)
  - TTS speaker icon (optional pronunciation)
  - Action buttons (bottom):
    - Again (red, left)
    - Hard (yellow, center)
    - Easy (green, right)

- **Progress Indicator** (top):
  - "5 cards due today"
  - Progress bar or count

**Animations**:
- Flip animation: 3D card rotation (SwiftUI rotation3DEffect)
- Must be smooth (60fps)
- Reduce Motion fallback: fade transition

**Accessibility**:
- VoiceOver labels for all elements
- Dynamic Type support
- Min 44pt button tap targets

**Reference**:
- Mochi: clean review interface
- Duolingo: clear action buttons

---

#### 4. **Interactive Widget (Small/Medium/Large)** ⭐ KILLER FEATURE
**Why Critical**: **Unique differentiation** — no competitors have this.

**Widget Sizes**:

**Small (2x2)**:
- Due card front text (truncated if long)
- "Tap to flip" hint (icon or text)
- Minimal chrome (just card content)

**Medium (4x2)** (Primary focus):
- Due card (front or back state)
- Flip button (tap anywhere to flip)
- Easy/Hard buttons (when showing back)
- Progress: "3 cards left"

**Large (4x4)**:
- Current due card (larger text)
- Next 2 cards preview (small, faded)
- Easy/Hard/Again buttons
- Progress bar

**Interactions** (App Intents):
- Tap widget → Flip card (show back)
- Tap Easy → Rate card as easy, show next card
- Tap Hard → Rate card as hard, show next card
- Tap "Again" → Mark forgot, show next card

**Widget States**:
- **Has due cards**: Show card + buttons
- **No due cards**: "All done! 🎉" + "Review tomorrow"
- **No cards at all**: "Create your first card" + "Open App" button

**Design Requirements**:
- Liquid Glass background (translucent)
- Teal/Green color scheme
- Large, readable text (widget space limited)
- SF Pro Rounded font
- SF Symbols for icons (speaker, checkmark, etc.)

**Technical Notes** (for context):
- iOS 17.0+ required (App Intents)
- WidgetKit + App Intents frameworks
- AppGroup shared container для data
- Memory limit: 50MB для widget extension

**Reference**:
- [chockenberry/Intentional](https://github.com/chockenberry/Intentional) — interactive widget patterns
- [pawello2222/WidgetExamples](https://github.com/pawello2222/WidgetExamples) — WidgetKit designs

---

### Priority 2 (Core Functionality) ⭐⭐

#### 5. **Deck List Screen**
**Why**: Organization — users manage multiple decks.

**States**:
- **Empty State**:
  - Illustration (optional)
  - "Create your first deck"
  - "+" button (floating, bottom-right)

- **Populated State**:
  - List of decks (vertical scroll)
  - Each deck cell shows:
    - Deck name
    - Deck color badge (left)
    - Card count (e.g., "25 cards")
    - Due count (e.g., "5 due today")
  - "+" button (floating, bottom-right)

**Interactions**:
- Tap deck → Card List для этого deck
- Long press → Edit/Delete menu

**Design**:
- Liquid Glass cards (translucent)
- Color-coded badges (teal/green variations)

---

#### 6. **Card List Screen**
**Why**: Card management — browse/edit cards.

**States**:
- **Empty State**:
  - "Add your first card"
  - "+" button

- **Populated State**:
  - List of cards (vertical scroll)
  - Each card cell shows:
    - Front text preview (1 line, truncated)
    - Due date или "New" badge
  - Swipe left: Edit, Delete
  - "+" button (floating)

**Interactions**:
- Tap card → Card Detail/Edit
- Swipe left → Edit/Delete
- "+" → Create new card

---

#### 7. **Card Create/Edit Screen**
**Why**: Content creation — users create cards manually.

**Fields**:
- **Front** (text input, multiline)
  - Placeholder: "Question or context"
- **Back** (text input, multiline)
  - Placeholder: "Answer or definition"
- **Deck** (picker)
  - Select destination deck
- **TTS Preview** (optional button)
  - Speaker icon → hear pronunciation

**Actions**:
- Cancel (top-left)
- Save (top-right, primary button)

**Design**:
- Fullscreen или sheet modal
- Liquid Glass background
- Focus on text inputs (keyboard-first)

---

### Priority 3 (Secondary) ⭐

#### 8. **Settings Screen**
**Why**: Subscription management + preferences.

**Sections**:
- **Account**:
  - Restore purchases (button)
  - Manage subscription (link to App Store)

- **App Settings**:
  - Daily reminder time (time picker)

- **About**:
  - Version number
  - Privacy Policy (link)
  - Terms of Service (link)
  - Support email (link)

**Design**:
- Standard iOS Settings style
- Grouped list layout

---

#### 9. **Empty States** (Various)
**Why**: User guidance — show value when no content.

**States Needed**:
- No decks: "Create your first deck"
- No cards in deck: "Add your first card"
- No due cards: "All done! 🎉"
- Widget no cards: "Create cards to review"

**Design**:
- Illustrations (simple, minimal)
- Clear CTAs

---

## Design System Requirements

### Color Palette (Teal/Green Zen Theme)

**Light Colors** (Dark Mode only, but define для consistency):
```swift
Primary Teal: #14B8A6 (teal-500)
Primary Teal Dark: #0D9488 (teal-600)
Secondary Green: #10B981 (green-500)
Secondary Green Dark: #059669 (green-600)
Background: .ultraThinMaterial (system)
Surface: .regularMaterial
Text Primary: .primary (system)
Text Secondary: .secondary (system)
```

**Dark Mode** (MVP only):
```swift
Primary Teal: #14B8A6 (lighter для visibility)
Primary Teal Dark: #5EEAD4 (teal-300, for accents)
Secondary Green: #34D399 (green-400)
Background: .ultraThinMaterial
Surface: .regularMaterial
Buttons: .thickMaterial
```

**Semantic Colors**:
```swift
Success (Easy): Green #10B981
Warning (Hard): Yellow #F59E0B
Danger (Again): Red #EF4444
```

### Typography

**Font Family**: SF Pro Rounded (UI), SF Pro (content)

**Scales**:
```swift
Large Title: 34pt, Bold (SF Pro Rounded) — Onboarding headlines
Title 1: 28pt, Semibold — Screen titles
Title 2: 22pt, Semibold — Section headers
Body: 17pt, Regular (SF Pro) — Card content
Callout: 16pt, Regular — Metadata
Caption: 12pt, Regular — Hints
```

**Dynamic Type**: All text must support Dynamic Type (SF Pro scales automatically).

### Liquid Glass Materials

**Background Layers**:
```swift
Screen Background: .ultraThinMaterial (translucent blur)
Card/Widget: .regularMaterial (more opaque)
Button: .thickMaterial (most opaque)
```

**Effects**:
- Translucency (blur + vibrancy)
- Layering (depth through materials)
- Smooth animations (spring curves)

**Reference**: [axiom-liquid-glass](https://github.com/CharlesWiltgen/Axiom) skill

### Iconography

**System**: SF Symbols 6
**Weight**: Medium (default)
**Size**: Match text size (automatic scaling)

**Key Icons**:
- Plus: "plus.circle.fill" (create)
- Speaker: "speaker.wave.2" (TTS)
- Checkmark: "checkmark" (Easy)
- XMark: "xmark" (Again)
- Clock: "clock" (due cards)
- Gear: "gearshape" (settings)

---

## Accessibility Requirements

### VoiceOver
- All UI elements labeled (accessibilityLabel)
- Card content readable
- Button actions clear ("Mark as Easy", not just "Easy")

### Dynamic Type
- Text scales from Small → Accessibility 5
- Layout adapts (не breaks)

### Color Contrast
- Minimum 4.5:1 для text (WCAG AA)
- Test с Color Contrast Analyzer
- Dark Mode: ensure readable colors

### Reduce Motion
- Disable flip animations
- Use fade transitions instead
- Check UIAccessibility.isReduceMotionEnabled

---

## Technical Context (For Understanding)

### Frameworks Used
- SwiftUI (all UI)
- SwiftData (local storage)
- WidgetKit (widget)
- App Intents (widget interactivity)
- Adapty SDK (paywall)

### Constraints
- iOS 17.0+ (for App Intents)
- iPhone only (no iPad для MVP)
- Dark Mode only (no Light Mode)
- Portrait primary (Landscape optional)

### Widget Technical
- Memory limit: 50MB
- AppGroup для shared data: `com.zencards.shared`
- Timeline updates via push notifications or background refresh

---

## Deliverables Expected

### 1. Design System Document
**File**: `design_system.md`

**Contents**:
- Color tokens (hex codes, semantic names)
- Typography scales (sizes, weights, usage)
- Liquid Glass material specs
- Component library (buttons, cards, inputs)
- Spacing/padding system
- Icon usage guidelines

### 2. Screen Mockups
**Format**: SwiftUI Previews (preferred) or Figma/Sketch

**Screens** (priority order):
1. Onboarding (3 screens)
2. Review Session (front/back states)
3. Interactive Widget (Small/Medium/Large)
4. Deck List (empty + populated)
5. Card List (empty + populated)
6. Card Create/Edit
7. Settings
8. Empty states

**Each mockup should show**:
- Light Mode: N/A (Dark Mode only)
- Dark Mode: YES
- VoiceOver hints (annotations)
- Dynamic Type considerations (notes)

### 3. Accessibility Audit
**Document**: accessibility_notes.md

**Contents**:
- VoiceOver labels для all UI elements
- Color contrast ratios (tested)
- Dynamic Type test results
- Reduce Motion alternatives

### 4. Handoff Document
**File**: `.factory/handoffs/phase2_to_phase3.md`

**Contents**:
- Design system reference
- Screen flow diagrams
- Component specifications
- Implementation notes для swift_dev
- Open questions/risks

---

## Timeline

**Phase 2 Duration**: 4-6 days

**Breakdown**:
- Day 1-2: Design System + Color palette
- Day 3: Onboarding + Review Session mockups
- Day 4: Interactive Widget mockups (killer feature)
- Day 5: Deck/Card List + Create/Edit mockups
- Day 6: Settings + Empty states + Accessibility audit

---

## Success Criteria

- [ ] Design System document created
- [ ] All Priority 1 screens designed (Onboarding, Review, Widget)
- [ ] All Priority 2 screens designed (Deck List, Card List, Create/Edit)
- [ ] All Priority 3 screens designed (Settings, Empty states)
- [ ] Liquid Glass materials applied throughout
- [ ] Teal/Green color palette used
- [ ] Dark Mode designs
- [ ] Accessibility audit completed (VoiceOver, contrast, Dynamic Type)
- [ ] Handoff document created для swift_dev

---

## Open Questions / Risks

- [ ] **Widget Design Complexity**: Interactive widgets на iOS 17/18 могут иметь quirks — нужно research Apple HIG
- [ ] **Color Palette Approval**: Teal/Green OK или нужны альтернативы?
- [ ] **Flip Animation**: Можем ли добиться smooth 60fps на iPhone 12/13?
- [ ] **Adapty Branding**: Нужно ли full custom paywall UI или достаточно Adapty template?

---

## Files for Reference

### Primary Documents
- **`backlog_mvp.md`** — MVP requirements (900+ lines) ⭐ PRIMARY
- **`backlog.md`** — Full v1.0 vision (reference only)
- **`ZenCards_PRD.md`** — Original product brief

### Research Sources
- **FSRS**: [open-spaced-repetition/swift-fsrs](https://github.com/open-spaced-repetition/swift-fsrs)
- **Widget Examples**: [chockenberry/Intentional](https://github.com/chockenberry/Intentional)
- **Flashcard Apps**: [vaIerika/Flashcards](https://github.com/vaIerika/Flashcards) (SwiftUI reference)
- **Axiom Skills**: [CharlesWiltgen/Axiom](https://github.com/CharlesWiltgen/Axiom) (axiom-liquid-glass)

### Competitor Analysis
- Anki Mobile: Outdated UI (what NOT to do)
- Mochi: Clean UI (good reference, but add Liquid Glass)
- Reddit: [Anki complaints](https://forums.ankiweb.net/t/really-hate-where-anki-is-going-with-its-new-design/3651)

---

**@ui_engineer**: Phase 1 (MVP) завершён. Фокус на **Interactive Widget** (killer feature) + **Liquid Glass Design**. Timeline: 4-6 days. Начни с Design System и Priority 1 screens.

**Emotional Target**: Users должны чувствовать "This is the Anki I always wanted" — beautiful, modern, zen. 🎨
