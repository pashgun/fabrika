# ZenCards MVP — Screen Designs

**Version**: 1.0 MVP
**Date**: 2026-01-19
**Design System**: See design_system.md

---

## Priority 1: Critical Path Screens

### 1. Onboarding Flow (3 Screens)

#### Screen 1: Welcome

**Purpose**: First impression — establish brand identity and value proposition.

**Layout**:
```
┌─────────────────────────────┐
│                             │ Safe Area Top
│          [Logo]             │ 48pt spacing
│        ZenCards             │ Large Title, Bold
│                             │
│   Beautiful Spaced          │ Title 2, Regular
│      Repetition             │
│                             │
│   Learn smarter,            │ Body, Secondary
│    not harder               │
│                             │
│   [Animated Preview]        │ Liquid Glass card
│    (floating cards)         │ with subtle animation
│                             │
│                             │
│     ●  ○  ○                │ Page indicators
│                             │
│   [Get Started]             │ Primary button
│                             │ 16pt bottom padding
│   Skip                      │ Text button
│                             │
└─────────────────────────────┘ Safe Area Bottom
```

**Visual Elements**:

**Logo/Icon**:
- ZenCards logo (circular, teal gradient)
- Size: 80pt diameter
- Centered horizontally
- Top: Safe Area + 48pt

**App Name**:
- "ZenCards"
- Font: Large Title (.largeTitle, rounded), Bold
- Color: Primary gradient (teal → green)
- Centered

**Tagline**:
- "Beautiful Spaced Repetition"
- Font: Title 2 (.title2, rounded), Regular
- Color: .primary
- Centered
- Spacing: 8pt below name

**Subtext**:
- "Learn smarter, not harder"
- Font: Body (.body), Regular
- Color: .secondary
- Centered
- Spacing: 12pt below tagline

**Animated Preview** (Hero):
- 3 floating flashcards
- Liquid Glass material (.regularMaterial)
- Corner radius: 16pt
- Subtle floating animation (up/down 8pt, 3s loop)
- Stacked with depth (z-index + scale)
- Card 1 (front): "Hello" (largest, center)
- Card 2 (back): "Hola" (medium, slightly left)
- Card 3 (front): "こんにちは" (small, slightly right)

**Page Indicators**:
- 3 dots: ● ○ ○
- Active: primaryTeal
- Inactive: .secondary opacity 0.3
- Size: 8pt diameter
- Spacing: 8pt between dots
- Centered horizontally

**Get Started Button** (Primary CTA):
- Label: "Get Started"
- Style: PrimaryButton (from design system)
- Width: Screen width - 32pt (16pt padding each side)
- Height: 52pt
- Background: primaryGradient (teal → green)
- Corner radius: 12pt
- Bottom: 16pt above Skip button

**Skip Button**:
- Label: "Skip"
- Style: Text button (no background)
- Font: Headline (.headline, rounded), Semibold
- Color: .secondary
- Centered
- Bottom: Safe Area + 16pt

**Background**:
- .ultraThinMaterial (shows iOS wallpaper)
- Subtle teal gradient overlay (opacity 0.1) from top

**Accessibility**:
- VoiceOver: "Welcome to ZenCards. Beautiful spaced repetition. Learn smarter, not harder. Get Started button. Skip button."
- Animated preview: accessibilityHidden (decorative)

---

#### Screen 2: Feature Highlight

**Purpose**: Show core value — FSRS algorithm makes learning effective.

**Layout**:
```
┌─────────────────────────────┐
│                             │ Safe Area Top
│                             │ 32pt spacing
│    [Review Preview]         │ Mock review session
│     (flip animation)        │ Liquid Glass card
│                             │ Shows flip interaction
│                             │
│                             │
│      Modern Algorithm       │ Title 2, Bold
│                             │
│   FSRS spaced repetition    │ Body, Regular
│   helps you remember        │ Multi-line
│      long-term              │
│                             │
│                             │
│                             │
│     ○  ●  ○                │ Page indicators
│                             │
│      [Next]                 │ Primary button
│                             │
│   Skip                      │ Text button
│                             │
└─────────────────────────────┘ Safe Area Bottom
```

**Visual Elements**:

**Review Preview** (Hero):
- Large flashcard mock
- Size: 280pt width x 180pt height
- Liquid Glass material (.regularMaterial)
- Corner radius: 16pt
- Centered horizontally
- Top: Safe Area + 64pt

**Card States** (animated loop):
1. **Front state** (2s):
   - Text: "Hola"
   - Font: Title 1 (.title, default), Bold
   - Color: .primary
   - Centered in card
   - Hint: "Tap to flip" (caption, bottom, subtle)

2. **Flip animation** (0.5s):
   - 3D rotation (Y-axis, 180°)
   - Spring animation

3. **Back state** (2s):
   - Text: "Hello"
   - Font: Title 1 (.title, default), Bold
   - Color: .primary
   - Speaker icon (TTS indicator)
   - Size: 24pt, below text

**Headline**:
- "Modern Algorithm"
- Font: Title 2 (.title2, rounded), Bold
- Color: .primary
- Centered
- Spacing: 32pt below card preview

**Description**:
- "FSRS spaced repetition helps you remember long-term"
- Font: Body (.body), Regular
- Color: .secondary
- Centered
- Multi-line (3 lines max)
- Line spacing: 1.2
- Spacing: 12pt below headline

**Page Indicators**:
- ○ ● ○ (2nd active)

**Next Button** (Primary CTA):
- Label: "Next"
- Same style as "Get Started"

**Skip Button**:
- Same as Screen 1

**Background**:
- .ultraThinMaterial
- Subtle gradient accent (primaryTeal, opacity 0.05) center

**Accessibility**:
- VoiceOver: "Modern Algorithm. FSRS spaced repetition helps you remember long-term. Review card preview showing flip animation."
- Card animation: Reduce Motion fallback (fade in/out)

---

#### Screen 3: Value Proposition

**Purpose**: Final push — show beautiful UI as key differentiator.

**Layout**:
```
┌─────────────────────────────┐
│                             │ Safe Area Top
│                             │ 32pt spacing
│   [UI Showcase]             │ Multiple UI elements
│    Deck card                │ Showing Liquid Glass
│    Review buttons           │ design aesthetic
│    Widget preview           │
│                             │
│                             │
│    Flashcards you'll        │ Title 2, Bold
│     love using              │
│                             │
│   Gorgeous design meets     │ Body, Regular
│    powerful learning        │
│                             │
│                             │
│     ○  ○  ●                │ Page indicators
│                             │
│   [Start Learning]          │ Primary button
│                             │
│   Skip                      │ Text button (hidden)
│                             │
└─────────────────────────────┘ Safe Area Bottom
```

**Visual Elements**:

**UI Showcase** (Hero):
Stacked preview of app screens:

1. **Deck Card** (top):
   - Mini deck card preview
   - "Spanish" deck name
   - Teal color badge
   - "25 cards, 5 due"
   - Glass material
   - Width: 320pt, Height: 80pt

2. **Review Buttons** (middle):
   - 3 buttons: Again (red), Hard (amber), Easy (green)
   - Compact size
   - Glass material backgrounds
   - Width: 100pt each, Height: 44pt

3. **Widget Preview** (bottom):
   - Medium widget mock
   - Shows due card
   - "3 cards left" progress
   - Glass material
   - Width: 320pt, Height: 140pt

**Arrangement**:
- Vertically stacked with 12pt spacing
- Slight 3D depth (scale + shadow)
- Subtle float animation (like Screen 1)
- Top: Safe Area + 48pt

**Headline**:
- "Flashcards you'll love using"
- Font: Title 2 (.title2, rounded), Bold
- Color: Primary gradient (teal → green)
- Centered
- Spacing: 32pt below showcase

**Description**:
- "Gorgeous design meets powerful learning"
- Font: Body (.body), Regular
- Color: .secondary
- Centered
- Spacing: 12pt below headline

**Page Indicators**:
- ○ ○ ● (3rd active)

**Start Learning Button** (Final CTA):
- Label: "Start Learning"
- Primary button style
- Slightly larger (height: 56pt vs 52pt)
- Extra emphasis (subtle pulse animation on appear)

**Skip Button**:
- Hidden на этом экране (last screen, no skip needed)
- Or: Make it very subtle (opacity 0.3)

**Background**:
- .ultraThinMaterial
- Gradient accent (primaryGradient, opacity 0.08) from bottom

**Accessibility**:
- VoiceOver: "Flashcards you'll love using. Gorgeous design meets powerful learning. UI showcase showing deck cards, review buttons, and widgets."

**Interaction**:
- Tap "Start Learning" → Navigate to Paywall
- Swipe left → Navigate to Paywall (same as button)

---

### 2. Paywall Screen (Adapty Reference)

**Purpose**: Monetization — convert users to paid subscribers immediately after onboarding.

**Note**: Using **Adapty Paywall Builder** (no custom UI needed), but providing visual reference for branding.

**Adapty Configuration**:

**Placement ID**: `"onboarding"`

**Headline**: "Unlock Beautiful Learning"

**Subheadline**: "Join thousands using ZenCards to master new skills"

**Features List**:
```
✅ Unlimited decks & cards
✅ FSRS spaced repetition algorithm
✅ Liquid Glass design (exclusive)
✅ Interactive Home Screen widget
🔮 Cloud sync across devices (coming soon)
🔮 AI auto-creation (coming soon)
```

**Products**:
1. **Yearly** (Recommended):
   - Price: $39.99/year
   - Badge: "Save 33%"
   - Subtext: "$3.33/month"

2. **Monthly**:
   - Price: $4.99/month

**Call to Action**: "Subscribe Now"

**Footer**:
- "Cancel anytime"
- "7-day money back guarantee"
- "Restore purchases" (link)

**Branding for Adapty**:
- **Primary Color**: primaryTeal (#14B8A6)
- **Accent Color**: secondaryGreen (#10B981)
- **Background**: Dark (use Adapty's dark theme)
- **Font**: System default (Adapty handles)
- **Logo**: ZenCards icon (provide 512x512 PNG)

**Custom Elements** (if using Adapty Custom UI):
- Background: .ultraThinMaterial (если возможно)
- Button style: primaryGradient background
- Feature checkmarks: primaryTeal color
- "Coming soon" items: .secondary color с lock icon

**Accessibility**:
- Adapty handles VoiceOver labels
- Ensure feature list is readable
- Button: "Subscribe to unlock all features"

**Flow**:
- **After subscription**: Dismiss paywall → Navigate to main app (Deck List empty state)
- **Restore purchases**: Adapty handles (checks subscription status)
- **Close button**: Optional (можем скрыть для paywall-first strategy)

---

### 3. Review Session Screen

**Purpose**: Core experience — users spend 80% of time here reviewing flashcards.

#### Front State

**Layout**:
```
┌─────────────────────────────┐
│  [Close]          5 cards   │ Navigation bar
│                             │
│                             │
│         ┌──────────┐        │
│         │          │        │
│         │  Hola    │        │ Card (front)
│         │          │        │ Liquid Glass
│         │          │        │
│         └──────────┘        │
│                             │
│      Tap to flip ↑          │ Hint (subtle)
│                             │
│                             │
│                             │
│   ━━━━━━━━━━━━━━          │ Progress bar
│   2 of 5                    │ Progress text
│                             │
└─────────────────────────────┘
```

**Visual Elements**:

**Navigation Bar**:
- Height: 44pt + Safe Area Top
- Background: .ultraThinMaterial
- Border bottom: divider (white, opacity 0.05)

**Close Button** (top-left):
- Icon: "xmark"
- Size: 20pt
- Color: .secondary
- Tap target: 44x44pt
- Action: Dismiss review session (with confirmation if unfinished)

**Progress Counter** (top-right):
- Text: "5 cards" (due cards remaining)
- Font: Headline (.headline, rounded), Semibold
- Color: .primary
- Updates in real-time after each review

**Flashcard** (Center):
- Size: Screen width - 48pt (24pt padding each side)
- Height: 400pt (or 50% of available space)
- Background: .regularMaterial
- Corner radius: 20pt (larger for emphasis)
- Shadow: medium (black, opacity 0.15, radius 12, y: 6)

**Card Content** (Front):
- Text: "Hola" (example)
- Font: Title 1 (.title, default), Bold
- Color: .primary
- Centered vertically and horizontally
- Max width: Card width - 40pt (padding)
- Line limit: nil (wraps if long)

**Tap to Flip Hint**:
- Text: "Tap to flip ↑"
- Font: Caption (.caption, rounded), Regular
- Color: .secondary opacity 0.6
- Centered horizontally
- Position: 24pt below card
- Animated: subtle fade in/out (1s loop) for first card only

**Progress Bar** (Bottom):
- Width: Screen width - 32pt
- Height: 4pt
- Background: .thickMaterial
- Foreground: primaryGradient
- Value: currentCard / totalCards (e.g., 2/5 = 40%)
- Corner radius: 2pt (capsule)
- Position: 16pt above progress text

**Progress Text**:
- Text: "2 of 5"
- Font: Callout (.callout, rounded), Regular
- Color: .secondary
- Centered horizontally
- Position: 8pt below progress bar, 24pt above Safe Area Bottom

**Background**:
- .ultraThinMaterial (shows wallpaper)

**Accessibility**:
- VoiceOver: "Card front: Hola. Tap to flip. Progress: 2 of 5 cards."
- Card: isAccessibilityElement = true
- Hint: "Double-tap to flip card"

**Interaction**:
- **Tap anywhere on card**: Flip to back (3D rotation animation)
- **Swipe down**: Dismiss review (with confirmation)

---

#### Back State

**Layout**:
```
┌─────────────────────────────┐
│  [Close]          5 cards   │ Navigation bar
│                             │
│                             │
│         ┌──────────┐        │
│         │          │        │
│         │  Hello   │        │ Card (back)
│         │          │        │ Liquid Glass
│         │   🔊     │        │ TTS icon
│         │          │        │
│         └──────────┘        │
│                             │
│                             │
│  [Again] [Hard]  [Easy]     │ Action buttons
│    ×       –       ✓        │ Icons
│   Red   Amber   Green       │ Colors
│                             │
│   ━━━━━━━━━━━━━━          │ Progress bar
│   2 of 5                    │
│                             │
└─────────────────────────────┘
```

**Visual Elements**:

**Card Content** (Back):
- Text: "Hello" (example answer)
- Font: Title 1 (.title, default), Bold
- Color: .primary
- Centered

**TTS Icon** (Speaker):
- Icon: "speaker.wave.2.fill"
- Size: 24pt
- Color: primaryTeal
- Position: 16pt below answer text
- Centered horizontally
- Tap: Play TTS pronunciation
- Animation: Pulsing scale effect when playing

**Action Buttons** (Bottom):
Three buttons in horizontal stack:

**Again Button** (Left):
- Width: (Screen width - 48pt) / 3 - 8pt
- Height: 56pt
- Background: .thickMaterial
- Border: actionAgain (red), 1.5pt
- Corner radius: 12pt
- Icon: "xmark" (20pt)
- Label: "Again" (caption, below icon)
- Colors: actionAgain (#EF4444)
- Tap: Mark card as "forgot", schedule next review (FSRS rating = 1)

**Hard Button** (Center):
- Width: Same as Again
- Height: 56pt
- Background: .thickMaterial
- Border: actionHard (amber), 1.5pt
- Icon: "minus" (20pt)
- Label: "Hard" (caption)
- Colors: actionHard (#F59E0B)
- Tap: Mark card as "difficult", schedule longer interval (FSRS rating = 2)

**Easy Button** (Right):
- Width: Same as Again
- Height: 56pt
- Background: .thickMaterial
- Border: actionEasy (green), 1.5pt
- Icon: "checkmark" (20pt)
- Label: "Easy" (caption)
- Colors: actionEasy (#10B981)
- Tap: Mark card as "easy", schedule longest interval (FSRS rating = 4)

**Button Layout**:
- Spacing: 8pt between buttons
- Horizontal padding: 16pt from screen edges
- Position: 32pt above progress bar

**Animation on Rating**:
1. Button tap: Scale down (0.95) briefly
2. Card flip out (rotate Y 180°, fade out, 0.3s)
3. Next card flip in (rotate Y from -180°, fade in, 0.3s)
4. Progress bar animates to new value

**Accessibility**:
- VoiceOver: "Card back: Hello. Play pronunciation button. Rate card: Again, Hard, or Easy."
- Each button: accessibilityLabel + accessibilityHint
  - Again: "Mark as forgotten. Review again soon."
  - Hard: "Mark as difficult. Review in a few days."
  - Easy: "Mark as easy. Review in several days."

**Interaction**:
- **Tap Again/Hard/Easy**: Rate card, show next card
- **Tap speaker icon**: Play TTS audio (AVSpeechSynthesizer)
- **Tap card**: No action (prevents accidental flip)
- **Swipe right**: Easy (gesture shortcut)
- **Swipe left**: Again (gesture shortcut)

---

#### Completion State

**When all cards reviewed**:

**Layout**:
```
┌─────────────────────────────┐
│                             │
│                             │
│          🎉                 │ Emoji (48pt)
│                             │
│      All done!              │ Title 1, Bold
│                             │
│   You reviewed 5 cards      │ Body, Regular
│    Come back tomorrow       │
│                             │
│                             │
│     [Done]                  │ Primary button
│                             │
└─────────────────────────────┘
```

**Visual Elements**:
- Celebration emoji: 🎉 (48pt font size)
- Headline: "All done!"
- Subtext: "You reviewed {count} cards. Come back tomorrow"
- Done button: Navigate back to Deck List
- Optional: Confetti animation (brief, 1s)

**Accessibility**:
- VoiceOver: "Congratulations! All done. You reviewed 5 cards. Come back tomorrow."
- Confetti: Reduce Motion fallback (none)

---

### 4. Interactive Widget (Home Screen)

**Purpose**: Killer feature — quick reviews without opening app.

#### Small Widget (2x2)

**Layout**:
```
┌──────────────┐
│              │
│    Hola      │ Due card (front)
│              │ Centered
│              │
│  Tap to flip │ Hint (tiny)
└──────────────┘
```

**Visual Elements**:

**Background**:
- .regularMaterial (Liquid Glass)
- Corner radius: 16pt (system widget default)
- Padding: 12pt all sides

**Card Text**:
- Text: "Hola" (example, front of due card)
- Font: Body (.body, default), Semibold
- Color: .primary
- Centered vertically and horizontally
- Line limit: 2 (truncate if longer)

**Hint**:
- Text: "Tap to flip"
- Font: Caption 2 (.caption2), Regular
- Color: .secondary opacity 0.5
- Centered horizontally
- Position: Bottom, 8pt from edge

**No Due Cards State**:
- Emoji: 🎉 (24pt)
- Text: "All done!" (caption)
- Subtext: "Tomorrow" (caption2, secondary)

**Interaction**:
- **Tap widget**: Open app to Review Session (deep link)
- **Future** (if time): Tap flips card in widget (App Intent)

**Accessibility**:
- accessibilityLabel: "Flashcard widget. Card: Hola. Tap to review."

---

#### Medium Widget (4x2)

**Layout**:
```
┌───────────────────────────────┐
│                               │
│        Hola                   │ Due card
│                               │
│                               │
│  [Hard]         [Easy]        │ Action buttons
│   –               ✓           │ Icons
│                               │
│  ━━━━━━━ 3 left              │ Progress
└───────────────────────────────┘
```

**Visual Elements**:

**Background**:
- .regularMaterial
- Corner radius: 16pt
- Padding: 16pt all sides

**Card Text**:
- Text: "Hola" (due card front)
- Font: Title 3 (.title3, default), Bold
- Color: .primary
- Centered horizontally
- Position: Top third of widget

**Action Buttons** (Bottom):

**Hard Button** (Left):
- Width: 48% of widget width
- Height: 40pt
- Background: .thickMaterial
- Border: actionHard (amber), 1pt
- Icon: "minus" (16pt)
- Label: "Hard" (caption, below icon)
- Corner radius: 10pt

**Easy Button** (Right):
- Width: 48% of widget width
- Height: 40pt
- Background: .thickMaterial
- Border: actionEasy (green), 1pt
- Icon: "checkmark" (16pt)
- Label: "Easy" (caption)
- Corner radius: 10pt

**Spacing**: 8pt between buttons

**Progress Indicator** (Bottom):
- Progress bar: 50pt width, 3pt height, capsule
- Foreground: primaryGradient
- Value: (totalDue - currentIndex) / totalDue
- Text: "3 left" (caption, right-aligned)
- Position: 8pt below buttons

**No Due Cards State**:
- Emoji: 🎉 (32pt)
- Text: "All done for today!" (headline)
- Subtext: "You reviewed {count} cards" (callout, secondary)
- No buttons shown

**Interaction** (App Intents):
- **Tap Hard**: RateCardIntent(rating: 2) → Update FSRS → Show next card → Reload widget timeline
- **Tap Easy**: RateCardIntent(rating: 4) → Update FSRS → Show next card → Reload timeline
- **Tap card area**: Open app to Review Session

**Accessibility**:
- accessibilityLabel: "Flashcard widget. Card: Hola. Hard button. Easy button. 3 cards left."

---

#### Large Widget (4x4)

**Layout**:
```
┌───────────────────────────────┐
│                               │
│        Hola                   │ Current card
│                               │ (large text)
│                               │
│                               │
│  [Again] [Hard]  [Easy]       │ 3 action buttons
│    ×       –       ✓          │
│                               │
│  ━━━━━━━━━━━ 5 cards         │ Progress
│                               │
│  ┌─────────┐  ┌─────────┐    │ Next cards
│  │ Bonjour │  │  Hallo  │    │ (preview)
│  └─────────┘  └─────────┘    │
│                               │
└───────────────────────────────┘
```

**Visual Elements**:

**Background**:
- .regularMaterial
- Corner radius: 16pt
- Padding: 20pt all sides

**Current Card**:
- Text: "Hola"
- Font: Large Title (.largeTitle, default), Bold
- Color: .primary
- Centered horizontally
- Position: Top 40% of widget

**Action Buttons** (Full set):

**Again Button** (Left):
- Width: 30% of widget width
- Height: 48pt
- Style: Same as medium widget
- Icon: "xmark"
- Label: "Again"

**Hard Button** (Center):
- Width: 30%
- Height: 48pt
- Icon: "minus"
- Label: "Hard"

**Easy Button** (Right):
- Width: 30%
- Height: 48pt
- Icon: "checkmark"
- Label: "Easy"

**Spacing**: 12pt between buttons

**Progress Bar** (Full width):
- Width: 100% (minus padding)
- Height: 4pt
- Capsule shape
- Foreground: primaryGradient
- Text: "5 cards" (callout, right-aligned, 4pt below bar)

**Next Cards Preview** (Bottom):
- 2 mini cards showing next due cards
- Size: 120pt width x 60pt height each
- Background: .ultraThinMaterial
- Corner radius: 12pt
- Text: Front of next cards (truncated, body font)
- Opacity: 0.7 (subtle preview)
- Spacing: 12pt between, 16pt from edges

**No Due Cards State**:
- Emoji: 🎉 (48pt)
- Text: "All done for today!" (title1, bold)
- Subtext: "You reviewed {count} cards today" (body, secondary)
- Secondary text: "Next review: Tomorrow at 9:00 AM" (callout, tertiary)
- No buttons, no previews

**Interaction** (App Intents):
- **Tap Again/Hard/Easy**: RateCardIntent → Update card → Reload timeline
- **Tap next card previews**: Open app to Review Session (skip to that card)
- **Tap main card**: Open app

**Accessibility**:
- accessibilityLabel: "Flashcard widget. Current card: Hola. Again, Hard, and Easy buttons. 5 cards remaining. Next cards: Bonjour, Hallo."

---

## Widget Technical Notes

### App Intents Integration

```swift
// Flip card intent (if time permits)
struct FlipCardIntent: AppIntent {
    static var title: LocalizedStringResource = "Flip Card"

    func perform() async throws -> some IntentResult {
        // Toggle card state in shared container
        // Reload widget timeline
        return .result()
    }
}

// Rate card intent (MUST HAVE)
struct RateCardIntent: AppIntent {
    static var title: LocalizedStringResource = "Rate Card"

    @Parameter(title: "Rating")
    var rating: Int  // 1=Again, 2=Hard, 4=Easy

    func perform() async throws -> some IntentResult {
        // 1. Load card from AppGroup container
        // 2. Update FSRS scheduling
        // 3. Save next due card
        // 4. Reload widget timeline
        return .result()
    }
}
```

### AppGroup Shared Container

**Group ID**: `group.com.zencards.shared`

**Shared Data**:
- Current due cards (JSON array)
- Widget state (front/back, current index)
- Review history (for FSRS updates)

**Implementation**:
```swift
let container = UserDefaults(suiteName: "group.com.zencards.shared")
container?.set(dueCards, forKey: "widgetDueCards")
```

### Timeline Provider

```swift
struct CardWidgetProvider: TimelineProvider {
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Load due cards from shared container
        // Create entries for next 24 hours
        // Reload policy: .atEnd (or after user action)
    }
}
```

**Reload Strategy**:
- After user rates card (via App Intent)
- When app comes to foreground (reload timeline)
- Daily at midnight (new due cards)

---

## Design Handoff Notes

### For Phase 3 (Swift Developer)

**Priorities**:
1. Onboarding → Paywall flow (critical path)
2. Review Session (core feature)
3. Interactive Widget (killer feature)

**Assets Needed**:
- ZenCards logo (SVG or PDF, 512x512)
- App icon (various sizes, App Store requirements)
- No custom illustrations (use SF Symbols + text)

**Design Tokens**:
- All colors, spacing, fonts in design_system.md
- Copy design token Swift file to project

**Animations**:
- Card flip: 3D rotation, spring animation (0.5s)
- Button press: Scale down (0.95), spring (0.2s)
- Widget transitions: Fade + slide (0.3s)
- All animations: Reduce Motion fallbacks

**Testing Checklist**:
- [ ] VoiceOver labels on all interactive elements
- [ ] Dynamic Type from Small to Accessibility 5
- [ ] Color contrast ratios (4.5:1 minimum)
- [ ] Widget memory < 50MB
- [ ] Widget updates correctly after rating

---

**Next**: Priority 2 screens (Deck List, Card List, Card Create/Edit)
