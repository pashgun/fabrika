# Handoff: PM Lead → UI Engineer

## Phase Summary
**Phase**: Phase 1 - Research & Requirements
**Agent**: pm_lead (Research-First Protocol)
**Status**: COMPLETE ✅
**Date**: 2026-01-19

## Deliverables Created
- [x] **backlog.md** с полным анализом требований (700+ lines)
- [x] **Open Source Foundation** — найдены готовые компоненты (FSRS, widget examples, flashcard references)
- [x] **Reddit Research** — проанализированы complaints Anki/Mochi users
- [x] **Конкурентный анализ** — 4 competitors (Anki, Mochi, Quizlet, RemNote)
- [x] **User stories** с критериями приёмки
- [x] **Технические требования** — SwiftData models, Apple frameworks, FSRS integration

## Executive Summary: What We're Building

**ZenCards 2.0** — iOS flashcard app ("Anki Killer") с тремя killer features:

### 🎯 Core Differentiation
1. **Liquid Glass UI** — решает главную жалобу на Anki ("ugly UI from 2010")
2. **AI Auto-Creation** — OCR фото → AI генерирует карточку за 5 секунд (unique feature)
3. **Interactive Widget** — review cards прямо с Home Screen через App Intents (никто не имеет)

### 🎨 Design Philosophy
- **Target Emotion**: Zen, Calm, Focus (like meditation app, но для learning)
- **Color Palette**: Teals/Greens (NOT Anki blues, NOT Mochi purples)
- **Materials**: iOS 26 Liquid Glass (translucency, depth, fluid animations)
- **Typography**: SF Pro Rounded (softer, more approachable)
- **Competitors to Beat**:
  - Anki: flat grey UI → We: Liquid Glass modern
  - Mochi: beautiful but не Liquid Glass → We: next-level materials

## For Next Agent: Priority Focus

### MUST DO (Критически важно)

#### 1. **Design System с Liquid Glass Materials** ⭐⭐⭐
**Context**: Главная цель — визуально дифференцироваться от Anki (ugly) и Mochi (good but not great).

**Requirements**:
- Следовать **axiom-liquid-glass** skill от [CharlesWiltgen/Axiom](https://github.com/CharlesWiltgen/Axiom)
- Color palette: **Teal/Green gradient** для zen theme
  - Primary: Teal (#14B8A6 to #0D9488)
  - Secondary: Green (#10B981 to #059669)
  - Background: Translucent glass с blur
  - NOT: Blues (Anki), Purples (Mochi)
- Typography:
  - SF Pro Rounded для UI labels
  - SF Pro (regular) для card content
  - Dynamic Type support обязателен
- Iconography: SF Symbols 6
- Dark Mode: обязателен (iOS standard)

**Deliverables**:
- `design_system.md` с:
  - Color tokens (light/dark)
  - Typography scales
  - Liquid Glass material specs
  - Component library (buttons, cards, inputs)
- Figma/Sketch mockups (опционально, можно SwiftUI Previews)

**Reference Competitors**:
- Mochi UI: clean, minimal (но add Liquid Glass materials)
- Calm app: zen colors, calming (inspiration для color palette)

---

#### 2. **Key Screens Design** ⭐⭐⭐

Design следующие экраны в приоритете:

##### A. **Review Session Screen** (Highest Priority)
**Why**: Core experience — users проводят 80% времени здесь.

**Requirements**:
- **Front State**:
  - Context sentence с highlighted target word
  - Minimalist (no distractions)
  - "Tap to flip" hint (subtle)
- **Back State**:
  - Word (large, prominent)
  - Definition (readable)
  - Pronunciation (if exists, smaller text)
  - Audio icon для TTS playback
- **Flip Animation**:
  - 3D card flip (SwiftUI rotation3DEffect)
  - Smooth, не janky (60fps minimum)
- **Action Buttons** (bottom):
  - Again (red tint), Hard (yellow tint), Easy (green tint)
  - Large tap targets (min 44pt height)
- **Progress Indicator** (top):
  - "10 cards due today" → updates in real-time
  - Progress bar или circular progress

**Accessibility**:
- VoiceOver: announce card content, button labels
- Reduce Motion: disable flip animation, use fade instead
- Dynamic Type: text scales correctly

**Reference**:
- Mochi's review interface (clean, minimal)
- Duolingo's question screens (gamified, clear buttons)

---

##### B. **Card List Screen** (Medium Priority)
**Why**: Management — users browse/edit/organize cards.

**Requirements**:
- **List Layout**:
  - Grouped by Deck (collapsible sections)
  - Card cells: show front preview, deck color badge, due date
  - Swipe actions: Edit, Delete
- **Search Bar** (top):
  - SwiftUI `.searchable()`
  - Filter chips: "Due Today", "All", "New"
- **Floating Action Button** (bottom-right):
  - "+" button → New Card (manual) OR Camera (AI auto-creation)
- **Empty State**:
  - Illustration + "Create your first card"

**Design Style**:
- Liquid Glass cards (translucent, layered)
- Color-coded deck badges (teal/green variations)

---

##### C. **AI Auto-Creation Flow** (Highest Priority — Killer Feature)
**Why**: Unique differentiation от всех конкурентов.

**Flow**:
1. **Camera Screen**:
   - Full-screen camera preview
   - "Point at text" instruction
   - Capture button (bottom center)
2. **OCR Result Screen**:
   - Extracted text displayed
   - User can tap/highlight word/phrase
   - "Create Card" button (disabled until word selected)
3. **AI Generating State**:
   - Loading spinner с message "AI is creating your card..."
   - Progress indicator (fake progress 0% → 100% for UX)
4. **Generated Card Preview**:
   - Show generated: Context, Word, Definition, Pronunciation
   - "Looks good!" button (save) vs "Edit" button (manual adjust)

**Design Requirements**:
- Smooth transitions между states (не jarring)
- Clear visual feedback (selection highlight, loading animation)
- Error state: "AI couldn't generate, try manual creation"

**Reference**:
- Google Lens UI (camera + text selection)
- ChatGPT iOS app (loading states, message bubbles)

---

##### D. **Interactive Widget** (Highest Priority — Unique Feature)
**Why**: Никто не имеет interactive review widget для flashcards.

**Widget Sizes**:
- **Small** (1 card):
  - Due card front (context)
  - "Tap to flip" indicator
- **Medium** (1 card + stats):
  - Due card
  - Progress bar: "5 cards remaining"
- **Large** (multiple cards OR expanded review):
  - Current card (larger)
  - Next 2 cards preview (small)

**Interactions** (App Intents):
- Tap widget → flip card (show back)
- Easy/Hard buttons → rate and show next card
- "Open App" button (if user wants full experience)

**Design**:
- Translucent glass background (iOS 18 widget materials)
- Color-coded buttons (red/yellow/green)
- Live updates (Timeline provider)

**Technical Reference**:
- [chockenberry/Intentional](https://github.com/chockenberry/Intentional) — widget + AppIntents example
- iOS 18 WidgetKit best practices

---

##### E. **Statistics Dashboard** (Low Priority — Should Have)
**Why**: Mochi users complain о "spartan stats", мы делаем better.

**Requirements**:
- **Top Cards**:
  - Today: X cards reviewed
  - Study Streak: N days 🔥
  - Retention Rate: Y%
- **Chart**:
  - SwiftUI Charts: reviews over time (bar chart, last 7 days)
- **FSRS Insights** (advanced):
  - Predicted retention percentage
  - Optimal review intervals

**Design**:
- Card-based layout (glass cards)
- Teal/green gradient для chart bars
- Celebration state: "10 day streak! 🎉" (gamification)

---

#### 3. **Accessibility First** ⭐⭐
**Context**: Following **axiom-accessibility-debugging** skill.

**Requirements**:
- **VoiceOver**:
  - Все UI elements labeled (accessibilityLabel)
  - Card content readable (context, word, definition)
  - Button actions clear ("Rate as Easy", не просто "Easy")
- **Dynamic Type**:
  - Text scales от Small → Accessibility 5
  - Layout не breaks при large text
- **Color Contrast**:
  - Minimum 4.5:1 для text (WCAG AA)
  - Test с Color Contrast Analyzer
  - Dark Mode: lighter text на темном background
- **Reduce Motion**:
  - Disable flip animations
  - Use fade transitions instead
  - Check `UIAccessibility.isReduceMotionEnabled`

**Testing Checklist**:
- [ ] VoiceOver walkthrough всех экранов
- [ ] Dynamic Type testing (min/max sizes)
- [ ] Contrast checker для всех text colors
- [ ] Reduce Motion testing

---

### SHOULD DO (Важно)

#### 1. **Onboarding Flow**
- 3 screens:
  1. "Welcome to ZenCards" + hero image (Liquid Glass UI)
  2. "AI Auto-Creation" demo (OCR → Card)
  3. "Review from Home Screen" widget demo
- Skip button (top-right)
- "Get Started" CTA (bottom)

#### 2. **Settings Screen**
- Deck management (create/rename/delete/reorder)
- Notification time для daily reminders
- AI provider choice (Apple Intelligence vs OpenAI)
- Theme toggle (Dark Mode only, no Light/Auto)
- About (version, credits, privacy policy link)

#### 3. **Empty States**
Design для:
- No decks yet → "Create your first deck"
- No cards in deck → "Add cards via camera or manual"
- No due cards → "All done! Come back tomorrow 🎉"

---

### COULD DO (При наличии времени)

#### 1. **iPad Optimization**
- Larger screen layout
- Split view (card list | card detail)
- Keyboard shortcuts

#### 2. **Animations & Micro-interactions**
- Haptic feedback для button taps
- Confetti animation для streak milestones
- Smooth transitions между screens

#### 3. **Premium Tier UI**
- Paywall screen (elegant, not pushy)
- Premium badge на features

---

## Context & Constraints

### Дизайн-вдохновение

#### 1. **Anki Mobile** (What NOT to do)
- ❌ Flat grey UI
- ❌ Cluttered interface
- ❌ Desktop-like buttons (не mobile-optimized)
- **Lesson**: Avoid любые similarities с Anki UI

#### 2. **Mochi** (Good, but not enough)
- ✅ Clean, minimal
- ✅ Good typography
- ✅ Keyboard shortcuts visible
- ❌ But: not Liquid Glass, not iOS-native feel
- **Lesson**: Take Mochi's minimalism, add Liquid Glass materials

#### 3. **Calm** (Zen Inspiration)
- ✅ Calming colors (blues/teals/greens)
- ✅ Minimalist UI (no distractions)
- ✅ Smooth animations
- **Lesson**: Emotional tone — learning should feel calm, not stressful

#### 4. **Duolingo** (Gamification)
- ✅ Clear action buttons (colors, large tap targets)
- ✅ Progress indicators
- ✅ Celebration states (streaks, achievements)
- **Lesson**: Make reviewing feel rewarding

### Брендинг

**App Name**: ZenCards
**Tagline**: "Smart Flashcards, Beautifully Simple"
**Tone**: Calm, Focused, Modern (не corporate, не playful — balanced)

**Logo** (if designing):
- Iconography: Card silhouette + zen circle (enso)
- Colors: Teal gradient
- Style: Minimal, geometric

### Технические Ограничения

- **iOS 17.0+** minimum (для App Intents)
- **iPhone only** для v1.0 (iPad nice-to-have)
- **Portrait primary** (Landscape optional)
- **Dark Mode обязателен** (Light Mode optional)
- **SwiftUI only** (no UIKit)
- **Liquid Glass** требует iOS 26 materials (но fallback для iOS 17-25)

---

## Open Questions / Risks

### Questions for UI Engineer

- [ ] **Color Palette Approval**: Teal/Green OK, или предпочитаете другие zen colors?
- [ ] **Card Template Layout**: Context-first format (front: context, back: word+def) OK?
- [ ] **Widget Complexity**: Feasibility interactive widget с App Intents в iOS 17+?
- [ ] **Animation Performance**: Flip animation 60fps на older iPhones (iPhone 12/13)?

### Risks

- [ ] **Risk**: Liquid Glass materials могут плохо выглядеть на старых iOS versions (17-25)
  - **Mitigation**: Fallback на standard SwiftUI materials (`.ultraThinMaterial`)
- [ ] **Risk**: Flip animation может быть janky (не 60fps)
  - **Mitigation**: Use `.animation(.spring())` + test на real device
- [ ] **Risk**: Context-first format может быть confusing для users (unproven UX)
  - **Mitigation**: A/B test в beta, fallback на traditional front/back если feedback negative

---

## Files for Review

### Primary Document
**`backlog.md`** — полный product requirements document (700+ lines)

**Critical Sections для UI Engineer**:
1. **Line 6-171**: Open Source Foundation (reference repos для design patterns)
2. **Line 173-290**: Market Analysis (competitors UI analysis)
3. **Line 292-317**: Target Audience (emotional needs, pain points)
4. **Line 319-611**: Feature Breakdown (MUST HAVE features детально)
   - Особенно:
     - Line 421-463: Context-First Card Design
     - Line 465-515: AI Auto-Creation flow
     - Line 517-565: Interactive Widget
     - Line 567-611: Liquid Glass Design
5. **Line 613-748**: User Stories (UX flows, acceptance criteria)
6. **Line 750-892**: Technical Requirements (SwiftData models, Apple frameworks)

### Design References (External)

**Axiom Skills** (battle-tested iOS patterns):
- [axiom-liquid-glass](https://github.com/CharlesWiltgen/Axiom) — iOS 26 materials guide
- [axiom-swiftui-26-ref](https://claude-plugins.dev/skills/@CharlesWiltgen/Axiom/swiftui-26-ref) — SwiftUI best practices
- [accessibility-debugging](https://github.com/CharlesWiltgen/Axiom) — WCAG AA compliance

**Widget Examples**:
- [chockenberry/Intentional](https://github.com/chockenberry/Intentional) — interactive widget reference
- [pawello2222/WidgetExamples](https://github.com/pawello2222/WidgetExamples) — WidgetKit patterns

**Flashcard Apps** (SwiftUI reference):
- [vaIerika/Flashcards](https://github.com/vaIerika/Flashcards) — SwiftUI card UI inspiration

---

## Validation Checklist

Phase 1 Complete — все requirements выполнены:

- [x] **Все MUST HAVE функции задокументированы** (7 key features)
- [x] **Определены технические требования** (SwiftData models, Apple frameworks, FSRS integration)
- [x] **Созданы user stories** с критериями приёмки (6 stories)
- [x] **Указаны требования к accessibility** (VoiceOver, Dynamic Type, contrast)
- [x] **Определена возрастная категория** (4+) и требования к privacy
- [x] **Проведён Research-First анализ** (GitHub, Clone-Wars, Reddit, Axiom skills)
- [x] **Найдены Open Source компоненты** (swift-fsrs, Intentional, Flashcards references)
- [x] **Конкурентный анализ** завершён (Anki, Mochi, Quizlet, RemNote)
- [x] **Дифференциация определена** (Liquid Glass + AI + Widget)

---

## Next Steps

### Immediate Actions for ui_engineer

1. **Read `backlog.md`** (focus на Feature Breakdown, User Stories)
2. **Research Axiom axiom-liquid-glass skill** (understand iOS 26 materials)
3. **Create `design_system.md`**:
   - Color tokens (teal/green palette)
   - Typography scales
   - Liquid Glass material specs
   - Component library (buttons, cards, inputs)
4. **Design Key Screens** (priority order):
   - Review Session Screen (highest priority)
   - AI Auto-Creation Flow (killer feature)
   - Interactive Widget (unique feature)
   - Card List Screen
   - Statistics Dashboard (lower priority)
5. **Create Handoff Document** для swift_dev:
   - `.factory/handoffs/phase2_to_phase3.md`
   - Include: design tokens, component specs, screen flows

### Phase 2 Deliverables Expected

- [ ] `design_system.md` (comprehensive design system documentation)
- [ ] SwiftUI Previews или mockups для key screens (Review, AI Flow, Widget)
- [ ] Accessibility audit results (VoiceOver, Dynamic Type, contrast)
- [ ] Handoff document для Phase 3 (Swift Dev)

### Phase Transition

**Phase 1 (PM Lead)**: COMPLETE ✅
**Phase 2 (UI Engineer)**: IN PROGRESS 🎨

---

**@ui_engineer**: Phase 1 завершён. Пожалуйста, ознакомьтесь с `backlog.md` (особенно разделы "Feature Breakdown" и "User Stories") и создайте Design System с Liquid Glass materials.

**Priority Focus**:
1. Design System (colors, typography, materials)
2. Review Session Screen design
3. AI Auto-Creation flow design
4. Interactive Widget design

**Goal**: Создать design который визуально **убивает Anki** (outdated UI) и **превосходит Mochi** (good but not Liquid Glass).

**Emotional Target**: Users должны чувствовать Zen, Calm, Focus — learning как медитация, не как работа.

---

**Спасибо за Research-First approach! Найденные Open Source компоненты сэкономят 50%+ development time.** 🚀
