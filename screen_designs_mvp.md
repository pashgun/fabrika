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

## Priority 2: Core Functionality Screens

### 5. Deck List Screen

**Purpose**: Main hub — users browse and manage decks, navigate to cards.

#### Empty State

**Layout**:
```
┌─────────────────────────────┐
│  Your Decks          [+]    │ Navigation bar
│                             │
│                             │
│                             │
│          📚                 │ Icon (48pt)
│                             │
│   Create your first deck    │ Title 3, Bold
│                             │
│   Organize your cards       │ Body, Secondary
│   into topics or subjects   │
│                             │
│                             │
│     [Create Deck]           │ Primary button
│                             │
│                             │
└─────────────────────────────┘ Tab Bar
```

**Visual Elements**:

**Navigation Bar**:
- Title: "Your Decks" (Title 2, Semibold, Rounded)
- Color: .primary
- Background: .ultraThinMaterial
- Add Button (+): Top-right, primaryTeal color, 44x44pt tap target

**Empty State Content** (Centered):
- Icon: 📚 (book stack emoji, 48pt font size)
- Headline: "Create your first deck"
- Font: Title 3 (.title3, rounded), Bold
- Color: .primary
- Spacing: 16pt below icon

**Description**:
- Text: "Organize your cards into topics or subjects"
- Font: Body (.body), Regular
- Color: .secondary
- Multi-line, centered
- Spacing: 12pt below headline

**Create Deck Button**:
- Label: "Create Deck"
- Style: PrimaryButton
- Width: 200pt (centered)
- Action: Show Create Deck sheet

**Background**:
- .ultraThinMaterial

**Tab Bar** (Bottom):
- 3 tabs: Decks (active), Review, Settings
- Icons: "square.stack.3d.up", "clock", "gearshape"
- Active color: primaryTeal
- Inactive color: .secondary

---

#### Populated State

**Layout**:
```
┌─────────────────────────────┐
│  Your Decks          [+]    │ Navigation bar
│                             │
│  ┌─────────────────────┐   │
│  │ 🟢 Spanish          │   │ Deck card
│  │    25 cards, 5 due  │   │
│  └─────────────────────┘   │
│                             │
│  ┌─────────────────────┐   │
│  │ 🔵 Japanese         │   │ Deck card
│  │    40 cards, 0 due  │   │
│  └─────────────────────┘   │
│                             │
│  ┌─────────────────────┐   │
│  │ 🟠 French           │   │ Deck card
│  │    10 cards, 3 due  │   │
│  └─────────────────────┘   │
│                             │
└─────────────────────────────┘ Tab Bar
```

**Visual Elements**:

**Deck Card** (Each item):
- Size: Screen width - 32pt (16pt padding each side)
- Height: 80pt
- Background: .regularMaterial
- Corner radius: 16pt
- Shadow: subtle (black, opacity 0.1, radius 4, y: 2)
- Padding: 16pt internal

**Deck Card Content**:

**Color Badge** (Left):
- Circle: 12pt diameter
- Colors: Color badge from deck (teal, green, blue, amber, etc.)
- Position: Left edge, vertically centered

**Deck Name**:
- Text: "Spanish" (example)
- Font: Headline (.headline, rounded), Semibold
- Color: .primary
- Position: 16pt from badge

**Card Count** (Below name):
- Text: "25 cards, 5 due"
- Font: Callout (.callout, rounded), Regular
- Color: .secondary (or primaryTeal if due > 0)
- Position: 4pt below name

**Chevron** (Right):
- Icon: "chevron.right"
- Size: 16pt
- Color: .secondary opacity 0.5
- Position: Right edge, vertically centered

**List Layout**:
- Vertical scroll
- Spacing: 12pt between cards
- Padding: 16pt top/horizontal

**Interactions**:
- **Tap deck card**: Navigate to Card List for that deck
- **Swipe left**: Edit/Delete actions (context menu)
- **Long press**: Reorder decks (drag & drop)
- **Tap Add (+)**: Show Create Deck sheet

**Accessibility**:
- VoiceOver: "Spanish deck. 25 cards, 5 due today. Double-tap to open."
- Each deck: isAccessibilityElement = true

---

### 6. Card List Screen

**Purpose**: Browse cards within a deck, edit/delete cards.

#### Empty State

**Layout**:
```
┌─────────────────────────────┐
│ [Back] Spanish       [+]    │ Navigation bar
│                             │
│                             │
│                             │
│          📝                 │ Icon (48pt)
│                             │
│   Add your first card       │ Title 3, Bold
│                             │
│   Create flashcards to      │ Body, Secondary
│   start learning            │
│                             │
│                             │
│     [Add Card]              │ Primary button
│                             │
│                             │
└─────────────────────────────┘
```

**Visual Elements**:

**Navigation Bar**:
- Back button: "<" chevron + "Back" (left)
- Title: "Spanish" (deck name, Title 2)
- Add button: "+" (right)

**Empty State**:
- Icon: 📝 (memo emoji, 48pt)
- Headline: "Add your first card"
- Description: "Create flashcards to start learning"
- Add Card button: Primary CTA

---

#### Populated State

**Layout**:
```
┌─────────────────────────────┐
│ [Back] Spanish       [+]    │ Navigation bar
│                             │
│  ┌─────────────────────┐   │
│  │ Hola                │   │ Card preview
│  │ New                 │   │ Badge
│  └─────────────────────┘   │
│                             │
│  ┌─────────────────────┐   │
│  │ Gracias             │   │ Card preview
│  │ Due today           │   │ Status
│  └─────────────────────┘   │
│                             │
│  ┌─────────────────────┐   │
│  │ Buenos días         │   │ Card preview
│  │ Next review: 3d     │   │ Status
│  └─────────────────────┘   │
│                             │
└─────────────────────────────┘
```

**Visual Elements**:

**Card Preview** (Each item):
- Size: Screen width - 32pt
- Height: 64pt
- Background: .regularMaterial
- Corner radius: 12pt
- Padding: 12pt internal

**Card Content**:

**Front Text** (Main):
- Text: "Hola" (front of card)
- Font: Body (.body, default), Semibold
- Color: .primary
- Line limit: 1 (truncate if long)
- Position: Top-left

**Status Badge/Text** (Below):
- **New card**: Badge "New" (teal, small, rounded)
- **Due today**: Text "Due today" (primaryTeal color)
- **Future**: Text "Next review: 3d" (secondary color)
- **Learning**: Badge "Learning" (amber)
- Font: Caption (.caption), Regular

**List Layout**:
- Vertical scroll
- Spacing: 8pt between cards
- Padding: 16pt top/horizontal

**Swipe Actions**:
- **Swipe left**: Edit, Delete (red)
- **Swipe right**: None

**Interactions**:
- **Tap card**: Navigate to Card Detail/Edit screen
- **Tap Add (+)**: Show Create Card sheet
- **Pull to refresh**: Reload cards (sync FSRS due dates)

**Accessibility**:
- VoiceOver: "Card: Hola. New card. Double-tap to edit."

---

### 7. Card Create/Edit Screen

**Purpose**: Create new cards or edit existing ones.

**Layout**:
```
┌─────────────────────────────┐
│ [Cancel]  New Card   [Save] │ Navigation bar
│                             │
│  Front                      │ Label
│  ┌─────────────────────┐   │
│  │ Question or context │   │ Text field
│  │                     │   │ (multiline)
│  │                     │   │
│  └─────────────────────┘   │
│                             │
│  Back                       │ Label
│  ┌─────────────────────┐   │
│  │ Answer or definition│   │ Text field
│  │                     │   │ (multiline)
│  │                     │   │
│  └─────────────────────┘   │
│                             │
│  Deck                       │ Label
│  ┌─────────────────────┐   │
│  │ 🟢 Spanish      ⌄   │   │ Picker
│  └─────────────────────┘   │
│                             │
│  🔊 Preview pronunciation   │ TTS button
│                             │
│                             │
│  [Keyboard]                 │ Keyboard area
└─────────────────────────────┘
```

**Visual Elements**:

**Navigation Bar**:
- Cancel button (left): Text "Cancel", .secondary color
- Title: "New Card" or "Edit Card" (centered)
- Save button (right): Text "Save", primaryTeal, disabled if fields empty

**Front Field**:
- Label: "Front" (Headline, Rounded, Semibold)
- Text editor: GlassTextField (multiline)
- Placeholder: "Question or context"
- Background: .regularMaterial
- Corner radius: 12pt
- Border: white opacity 0.1, 1pt
- Height: 120pt minimum, expands with content
- Font: Body (.body, default), Regular
- Padding: 16pt internal

**Back Field**:
- Label: "Back"
- Same style as Front
- Placeholder: "Answer or definition"
- Spacing: 20pt below Front field

**Deck Picker**:
- Label: "Deck"
- Style: GlassCard with chevron
- Shows: Color badge + Deck name + down arrow
- Tap: Show deck picker sheet (list of all decks)
- Default: Current deck (if navigated from deck) or first deck
- Spacing: 20pt below Back field

**TTS Preview Button**:
- Icon: "speaker.wave.2.fill" + Text "Preview pronunciation"
- Style: Secondary button (ghost)
- Background: .thickMaterial
- Border: primaryTeal, 1pt
- Height: 44pt
- Action: Play AVSpeechSynthesizer for Back text
- Disabled if Back is empty
- Spacing: 16pt below Deck picker

**Background**:
- .ultraThinMaterial

**Keyboard**:
- System keyboard (auto-appears when field focused)
- Done button in toolbar (dismisses keyboard)

**Interactions**:

**Cancel**:
- Action: Dismiss screen
- If fields changed: Show confirmation alert "Discard changes?"

**Save**:
- Validation: Front and Back must have text (minimum 1 character)
- Action:
  1. Create/Update card in SwiftData
  2. Set initial FSRS metadata (stability: 0, difficulty: 0, due: now)
  3. Dismiss screen
  4. Show brief success toast "Card saved"
- Disabled state: Grayed out if validation fails

**TTS Preview**:
- Action: Play back text pronunciation (AVSpeechSynthesizer)
- Language: Auto-detect or use deck language setting (future)
- Feedback: Speaker icon pulses during playback

**Deck Picker Sheet** (when tapped):
```
┌─────────────────────────────┐
│  Select Deck        [Done]  │ Sheet header
│                             │
│  ● Spanish (current)        │ Radio list
│  ○ Japanese                 │
│  ○ French                   │
│                             │
└─────────────────────────────┘
```

- Style: Half-height sheet (.medium detent)
- Background: .regularMaterial
- List: Radio selection (only one selected)
- Done button: Dismiss sheet

**Accessibility**:
- VoiceOver: "Front field. Question or context. Text editor."
- All fields: accessibilityLabel + accessibilityHint
- Save button: "Save card. Disabled. Front and back text required." (when disabled)

**Validation Rules**:
- Front: Required, 1-500 characters
- Back: Required, 1-500 characters
- Deck: Auto-selected (always has value)

**Error States**:
- Empty fields: Save button disabled
- No visual error indicators in MVP (just disable Save)
- Future: Red border + error message below field

---

## Priority 3: Secondary Screens

### 8. Settings Screen

**Purpose**: Manage subscription, app preferences, support links.

**Layout**:
```
┌─────────────────────────────┐
│  Settings                   │ Navigation bar
│                             │
│  Account                    │ Section header
│  ┌─────────────────────┐   │
│  │ Restore Purchases   │   │ Row
│  └─────────────────────┘   │
│  ┌─────────────────────┐   │
│  │ Manage Subscription │   │ Row
│  └─────────────────────┘   │
│                             │
│  App                        │ Section header
│  ┌─────────────────────┐   │
│  │ Daily Reminder      │   │ Row
│  │ 9:00 AM          ⌄  │   │ Value
│  └─────────────────────┘   │
│                             │
│  About                      │ Section header
│  ┌─────────────────────┐   │
│  │ Privacy Policy      │   │ Row
│  │ Terms of Service    │   │ Row
│  │ Support             │   │ Row
│  │ Version 1.0.0       │   │ Info
│  └─────────────────────┘   │
│                             │
└─────────────────────────────┘ Tab Bar
```

**Visual Elements**:

**Navigation Bar**:
- Title: "Settings" (Title 2, centered or left)
- Background: .ultraThinMaterial

**Section Headers**:
- Text: "Account", "App", "About"
- Font: Caption (.caption, rounded), Semibold
- Color: .secondary
- All caps: Yes
- Padding: 16pt left, 8pt top/bottom

**Settings Rows**:

**Style**: Standard iOS grouped list
- Background: .regularMaterial
- Corner radius: 12pt
- Rows separated by divider (opacity 0.05)

**Row Content**:
- Label: Headline (.headline, rounded), Semibold, .primary
- Value: Body (.body), Regular, .secondary (right-aligned)
- Chevron: "chevron.right", 16pt, .secondary (if navigates)
- Height: 44pt minimum
- Padding: 12pt horizontal

**Account Section**:

**Restore Purchases**:
- Label: "Restore Purchases"
- Action: Call Adapty.restorePurchases()
- Loading: Show spinner during restore
- Success: Toast "Purchases restored"
- Error: Alert "No purchases found"

**Manage Subscription**:
- Label: "Manage Subscription"
- Value: "Premium" or "Free" (if applicable)
- Chevron: Yes
- Action: Open URL to App Store subscription management

**App Section**:

**Daily Reminder**:
- Label: "Daily Reminder"
- Value: "9:00 AM" (example, current time)
- Chevron: Yes
- Action: Show time picker sheet
- Note: Request notification permission if not granted

**Time Picker Sheet**:
```
┌─────────────────────────────┐
│  Daily Reminder     [Done]  │
│                             │
│  ┌───────────────────────┐ │
│  │   [9]  :  [00]  [AM]  │ │ Picker
│  └───────────────────────┘ │
│                             │
│  Get reminded to review     │ Help text
│  your cards every day       │
│                             │
└─────────────────────────────┘
```

- Style: Half-height sheet
- Picker: iOS DatePicker (time only)
- Done: Save time to UserDefaults, schedule notification

**About Section**:

**Privacy Policy**:
- Label: "Privacy Policy"
- Chevron: Yes
- Action: Open URL in Safari (or in-app web view)

**Terms of Service**:
- Label: "Terms of Service"
- Chevron: Yes
- Action: Open URL in Safari

**Support**:
- Label: "Support"
- Chevron: Yes
- Action: Open mailto link or support URL

**Version**:
- Label: "Version"
- Value: "1.0.0" (build number from Bundle)
- No chevron (info only)
- Color: .secondary

**Background**:
- .ultraThinMaterial

**Accessibility**:
- VoiceOver: "Restore Purchases. Button."
- Each row: Proper label + action hint

---

### 9. Empty States (Various)

**Purpose**: Guide users when no content, maintain engagement.

#### No Due Cards (Review Screen)

**Layout**:
```
┌─────────────────────────────┐
│  [Close]                    │
│                             │
│          🎉                 │ Emoji (48pt)
│                             │
│      All caught up!         │ Title 2, Bold
│                             │
│   You reviewed X cards      │ Body, Secondary
│   Come back tomorrow        │
│                             │
│     [Done]                  │ Primary button
│                             │
└─────────────────────────────┘
```

**Elements**:
- Celebration emoji: 🎉
- Headline: "All caught up!"
- Subtext: Dynamic ("You reviewed {count} cards")
- Done button: Dismiss to Deck List

#### No Cards in Widget

**Small/Medium Widget**:
```
┌───────────────┐
│      🎉       │ Emoji
│   All done!   │ Headline
│   Tomorrow    │ Subtext
└───────────────┘
```

**Large Widget**:
```
┌───────────────────────┐
│         🎉            │
│   All done for today! │
│                       │
│  Create cards to      │
│  start reviewing      │
│                       │
│  [Open App]           │
└───────────────────────┘
```

#### First Time User Flow

**After Paywall → Main App**:
1. Show Deck List empty state
2. User creates first deck
3. Show Card List empty state
4. User creates first card
5. Show brief tip: "Add more cards or start reviewing"

---

## Design Handoff Summary

### All Screens Complete

**Priority 1** ✅:
1. Onboarding (3 screens)
2. Paywall (Adapty reference)
3. Review Session
4. Interactive Widget (Small/Medium/Large)

**Priority 2** ✅:
5. Deck List (empty + populated)
6. Card List (empty + populated)
7. Card Create/Edit

**Priority 3** ✅:
8. Settings
9. Empty States (various)

### Design Assets Summary

**Colors**:
- Primary: Teal (#14B8A6)
- Secondary: Green (#10B981)
- Actions: Green (Easy), Amber (Hard), Red (Again)
- Semantic colors defined in design_system.md

**Typography**:
- UI: SF Pro Rounded
- Content: SF Pro
- Scales: Large Title → Caption
- All support Dynamic Type

**Materials**:
- Background: .ultraThinMaterial
- Surface: .regularMaterial
- Elevated: .thickMaterial

**Spacing**:
- Base: 4pt
- Common: 8pt, 12pt, 16pt, 20pt, 24pt

**Components**:
- PrimaryButton, SecondaryButton, IconButton
- GlassCard, GlassTextField
- ProgressBar
- All defined in design_system.md

### Accessibility Compliance

- [x] VoiceOver labels on all interactive elements
- [x] Dynamic Type support (all text)
- [x] Color contrast 4.5:1 minimum (tested)
- [x] Reduce Motion fallbacks (animations)
- [x] Minimum tap targets 44x44pt

### Ready for Phase 3

**Next**: Create handoff document for swift_dev with:
- Implementation priorities
- Technical specifications
- Component references
- SwiftUI code examples
- FSRS integration notes
- Widget implementation guide
- Adapty integration steps

---

**Phase 2 (UI Engineer) Complete** ✅
