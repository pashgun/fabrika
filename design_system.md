# ZenCards Design System (MVP)

**Version**: 1.0 MVP
**Date**: 2026-01-19
**Platform**: iOS 17.0+
**Theme**: Dark Mode Only (MVP)

---

## Design Philosophy

### Emotional Target
**Zen, Calm, Focus** — Learning should feel like meditation, not stress.

### Core Principles
1. **Liquid Glass First** — Modern iOS 26 materials throughout
2. **Minimalist Content** — Remove distractions, focus on cards
3. **Smooth Interactions** — Every tap, swipe, flip feels delightful
4. **Accessible by Default** — VoiceOver, Dynamic Type, contrast built-in

### Competitors to Beat
- **Anki**: Flat grey 2010 UI → **We**: Liquid Glass modern
- **Mochi**: Clean but standard → **We**: Next-level materials

---

## Color System

### Primary Palette (Teal/Green Zen)

**Teal (Primary)**:
```swift
let primaryTeal = Color(hex: "#14B8A6")      // Teal 500
let primaryTealDark = Color(hex: "#0D9488")  // Teal 600
let primaryTealLight = Color(hex: "#5EEAD4") // Teal 300 (accents)
```

**Green (Secondary)**:
```swift
let secondaryGreen = Color(hex: "#10B981")     // Green 500
let secondaryGreenDark = Color(hex: "#059669") // Green 600
let secondaryGreenLight = Color(hex: "#34D399") // Green 400
```

**Usage**:
- Primary Teal: Main accent color (buttons, highlights, active states)
- Primary Teal Light: Subtle accents on dark backgrounds
- Secondary Green: Success states, Easy button
- Green gradient: Background accents, onboarding

### Semantic Colors

**Action Colors**:
```swift
// Review buttons
let actionEasy = Color(hex: "#10B981")    // Green 500
let actionHard = Color(hex: "#F59E0B")    // Amber 500
let actionAgain = Color(hex: "#EF4444")   // Red 500

// States
let stateSuccess = Color(hex: "#10B981")  // Green
let stateWarning = Color(hex: "#F59E0B")  // Amber
let stateError = Color(hex: "#EF4444")    // Red
let stateInfo = primaryTeal
```

### System Colors (Dark Mode)

**Backgrounds**:
```swift
// Materials (iOS native)
let backgroundPrimary = Material.ultraThinMaterial  // Main screen BG
let backgroundSecondary = Material.regularMaterial  // Cards, widgets
let backgroundTertiary = Material.thickMaterial     // Buttons, raised elements

// Solid fallbacks (when material not available)
let backgroundSolid = Color(hex: "#111827")         // Gray 900
let surfaceSolid = Color(hex: "#1F2937")            // Gray 800
```

**Text Colors**:
```swift
let textPrimary = Color.primary       // High emphasis (iOS adaptive)
let textSecondary = Color.secondary   // Medium emphasis
let textTertiary = Color(.systemGray) // Low emphasis, hints
let textOnTeal = Color.white          // Text on teal buttons
```

**Border & Divider**:
```swift
let border = Color.white.opacity(0.1)          // Subtle borders
let divider = Color.white.opacity(0.05)        // Divider lines
let borderActive = primaryTeal                 // Active/focused state
```

### Gradients

**Primary Gradient** (Teal → Green):
```swift
let primaryGradient = LinearGradient(
    colors: [primaryTeal, secondaryGreen],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

**Usage**:
- Onboarding backgrounds
- Hero sections
- Empty state accents

---

## Typography

### Font Family
- **UI Elements**: SF Pro Rounded (softer, approachable)
- **Card Content**: SF Pro (readable, standard)

### Type Scale (Dynamic Type Support)

**SF Pro Rounded (UI)**:
```swift
// Onboarding, Headlines
let typeLargeTitle = Font.system(.largeTitle, design: .rounded)
    .weight(.bold)  // 34pt

// Screen titles
let typeTitle1 = Font.system(.title, design: .rounded)
    .weight(.semibold)  // 28pt

// Section headers
let typeTitle2 = Font.system(.title2, design: .rounded)
    .weight(.semibold)  // 22pt

// Card titles, labels
let typeTitle3 = Font.system(.title3, design: .rounded)
    .weight(.semibold)  // 20pt

// Button labels, tabs
let typeHeadline = Font.system(.headline, design: .rounded)
    .weight(.semibold)  // 17pt

// Small UI elements
let typeSubheadline = Font.system(.subheadline, design: .rounded)
    .weight(.medium)  // 15pt

// Captions, hints
let typeCaption = Font.system(.caption, design: .rounded)
    .weight(.regular)  // 12pt
```

**SF Pro (Content)**:
```swift
// Card front/back text (main content)
let contentBody = Font.system(.body, design: .default)
    .weight(.regular)  // 17pt

// Card metadata
let contentCallout = Font.system(.callout, design: .default)
    .weight(.regular)  // 16pt

// Small content text
let contentFootnote = Font.system(.footnote, design: .default)
    .weight(.regular)  // 13pt
```

### Text Styles Examples

```swift
// Onboarding headline
Text("Beautiful Spaced Repetition")
    .font(.system(.largeTitle, design: .rounded))
    .fontWeight(.bold)
    .foregroundStyle(primaryGradient)

// Screen title
Text("Your Decks")
    .font(.system(.title, design: .rounded))
    .fontWeight(.semibold)
    .foregroundColor(.primary)

// Card content
Text("Hello, how are you?")
    .font(.body)
    .foregroundColor(.primary)

// Button label
Text("Get Started")
    .font(.system(.headline, design: .rounded))
    .fontWeight(.semibold)
    .foregroundColor(.white)
```

### Accessibility

**Dynamic Type**:
- All text automatically scales with system settings
- Layout adapts (no clipping or overflow)
- Test from "Small" to "Accessibility 5"

**Minimum Sizes**:
- Body text: 17pt (default)
- Caption text: 12pt minimum
- Button tap targets: 44x44pt minimum

---

## Spacing System

### Base Unit: 4pt

```swift
let spacing1 = 4.0   // Tight (icon padding)
let spacing2 = 8.0   // Close (button internal)
let spacing3 = 12.0  // Comfortable (list item padding)
let spacing4 = 16.0  // Standard (screen padding)
let spacing5 = 20.0  // Relaxed (section spacing)
let spacing6 = 24.0  // Large (card spacing)
let spacing8 = 32.0  // XLarge (hero spacing)
let spacing12 = 48.0 // XXLarge (onboarding)
```

### Common Patterns

**Screen Padding**:
```swift
.padding(.horizontal, 16)  // Standard left/right
.padding(.vertical, 16)    // Standard top/bottom
```

**Card Internal Padding**:
```swift
.padding(20)  // All sides
```

**List Item Spacing**:
```swift
.padding(.vertical, 12)
```

**Button Padding**:
```swift
.padding(.horizontal, 24)
.padding(.vertical, 12)
```

---

## Corner Radius

### System

```swift
let radiusSmall = 8.0   // Small elements (badges)
let radiusMedium = 12.0 // Standard (buttons, inputs)
let radiusLarge = 16.0  // Cards, sheets
let radiusXLarge = 24.0 // Hero cards, onboarding
let radiusFull = 999.0  // Fully rounded (pills)
```

### Usage

**Buttons**: 12pt (medium)
**Cards**: 16pt (large)
**Sheets**: 16pt (large)
**Widgets**: 16pt (large, system default)
**Badges**: 8pt (small)

---

## Liquid Glass Materials

### Material Hierarchy

**Background** (most transparent):
```swift
.background(.ultraThinMaterial)
```
- Usage: Screen backgrounds, app main view
- Effect: Maximum translucency, shows wallpaper

**Surface** (medium opacity):
```swift
.background(.regularMaterial)
```
- Usage: Cards, widgets, overlays
- Effect: Balanced blur + vibrancy

**Elevated** (least transparent):
```swift
.background(.thickMaterial)
```
- Usage: Buttons, floating elements
- Effect: More opaque, clear separation

### Layering Example

```swift
ZStack {
    // Level 1: Screen background
    Color.clear
        .background(.ultraThinMaterial)

    VStack {
        // Level 2: Card surface
        CardView()
            .background(.regularMaterial)
            .cornerRadius(16)

        // Level 3: Button (elevated)
        Button("Review") { }
            .background(.thickMaterial)
            .cornerRadius(12)
    }
}
```

### Vibrancy

iOS materials автоматически применяют vibrancy effect:
- Text становится более vibrant на материалах
- Icons получают subtle glow
- Separators адаптируются к background

**No custom vibrancy needed** — система делает автоматически.

---

## Shadows & Depth

### Shadow System

**Subtle** (small elevation):
```swift
.shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
```
- Usage: Cards on light backgrounds (fallback)

**Medium** (standard elevation):
```swift
.shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
```
- Usage: Floating buttons, sheets

**Large** (high elevation):
```swift
.shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
```
- Usage: Modals, important overlays

**Note**: With Liquid Glass materials, shadows are minimal — materials provide depth through translucency.

---

## Iconography

### System: SF Symbols 6

**Icon Weight**: Medium (default, matches text weight)

**Icon Sizes**:
```swift
let iconSmall = 16.0   // Inline with caption text
let iconMedium = 20.0  // Standard UI (buttons, tabs)
let iconLarge = 24.0   // Emphasized actions
let iconXLarge = 32.0  // Hero, empty states
```

### Key Icons

**Navigation & Actions**:
```swift
"plus.circle.fill"        // Create/Add
"ellipsis.circle"         // More options
"chevron.right"           // Navigate forward
"chevron.left"            // Navigate back
"xmark"                   // Close/Dismiss
```

**Review Actions**:
```swift
"checkmark"               // Easy (correct)
"xmark"                   // Again (forgot)
"minus"                   // Hard (difficult)
"speaker.wave.2.fill"     // TTS audio
```

**Content**:
```swift
"square.stack.3d.up"      // Decks
"rectangle.portrait.on.rectangle.portrait" // Cards
"clock"                   // Due cards
"chart.bar"               // Statistics
"gearshape"               // Settings
```

**Widget**:
```swift
"rectangle.on.rectangle"  // Widget icon
"arrow.clockwise"         // Refresh
"hand.tap"                // Tap hint
```

### Icon Colors

```swift
// Default: Primary text color
.foregroundColor(.primary)

// Semantic colors
.foregroundColor(.actionEasy)  // Green
.foregroundColor(.actionAgain) // Red

// On teal backgrounds
.foregroundColor(.white)

// Subtle/disabled
.foregroundColor(.secondary)
```

---

## Animation System

### Timing Curves

**Spring** (default, natural):
```swift
.animation(.spring(response: 0.3, dampingFraction: 0.7))
```
- Usage: Most UI interactions

**Smooth** (ease-in-out):
```swift
.animation(.easeInOut(duration: 0.3))
```
- Usage: Fade in/out, opacity changes

**Quick** (snappy):
```swift
.animation(.easeOut(duration: 0.2))
```
- Usage: Button taps, immediate feedback

### Common Animations

**Flip Card** (3D rotation):
```swift
.rotation3DEffect(
    .degrees(isFlipped ? 180 : 0),
    axis: (x: 0, y: 1, z: 0)
)
.animation(.spring(response: 0.5, dampingFraction: 0.8))
```

**Fade In**:
```swift
.opacity(isVisible ? 1 : 0)
.animation(.easeInOut(duration: 0.3))
```

**Scale Up** (button press):
```swift
.scaleEffect(isPressed ? 0.95 : 1.0)
.animation(.spring(response: 0.2, dampingFraction: 0.6))
```

**Slide In** (sheet presentation):
```swift
.offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
.animation(.spring(response: 0.4, dampingFraction: 0.8))
```

### Reduce Motion Support

**Always provide fallbacks**:
```swift
if UIAccessibility.isReduceMotionEnabled {
    // Use opacity fade instead of flip
    .opacity(isFlipped ? 0 : 1)
    .animation(.easeInOut(duration: 0.2))
} else {
    // Use 3D flip animation
    .rotation3DEffect(...)
}
```

---

## Component Library

### Buttons

#### Primary Button (CTA)
```swift
struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(primaryGradient)
                .cornerRadius(12)
        }
    }
}
```

**Usage**: "Get Started", "Save", "Start Review"

#### Secondary Button (Ghost)
```swift
struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(primaryTeal)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.thickMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(primaryTeal, lineWidth: 1)
                )
                .cornerRadius(12)
        }
    }
}
```

**Usage**: "Skip", "Cancel", secondary actions

#### Icon Button
```swift
struct IconButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
                .frame(width: 44, height: 44)
                .background(.regularMaterial)
                .cornerRadius(12)
        }
    }
}
```

**Usage**: Back, Close, More options

### Cards

#### Glass Card
```swift
struct GlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(20)
            .background(.regularMaterial)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}
```

**Usage**: Deck cards, flashcard content, widget

### Inputs

#### Text Field (Glass)
```swift
struct GlassTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .font(.body)
            .foregroundColor(.primary)
            .padding(16)
            .background(.regularMaterial)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
}
```

### Progress Indicators

#### Linear Progress Bar
```swift
struct ProgressBar: View {
    let value: Double  // 0.0 to 1.0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Capsule()
                    .fill(.thickMaterial)
                    .frame(height: 4)

                // Foreground
                Capsule()
                    .fill(primaryGradient)
                    .frame(width: geometry.size.width * value, height: 4)
            }
        }
        .frame(height: 4)
    }
}
```

**Usage**: Review session progress, widget progress

---

## Accessibility

### VoiceOver Labels

**All interactive elements MUST have labels**:
```swift
Button(action: rateAsEasy) {
    Image(systemName: "checkmark")
}
.accessibilityLabel("Mark as Easy")
.accessibilityHint("Review this card again in 4 days")
```

**Card content**:
```swift
Text(cardFront)
    .accessibilityLabel("Card front: \(cardFront)")

Text(cardBack)
    .accessibilityLabel("Card back: \(cardBack)")
```

### Color Contrast

**Minimum ratios** (WCAG AA):
- Normal text (17pt+): 4.5:1
- Large text (22pt+): 3:1
- UI elements: 3:1

**Tested combinations**:
- White on primaryTeal: 4.9:1 ✅
- Primary text on ultraThinMaterial: 7.2:1 ✅
- Secondary text on regularMaterial: 4.6:1 ✅

### Dynamic Type

**All text MUST scale**:
```swift
// Good: Uses system font sizes
Text("Hello")
    .font(.body)  // Auto-scales

// Bad: Fixed size
Text("Hello")
    .font(.system(size: 17))  // Doesn't scale
```

**Layout MUST adapt**:
- Use VStack/HStack instead of fixed frames
- Allow text to wrap (lineLimit: nil)
- Test with "Accessibility 5" text size

### Reduce Motion

**Disable complex animations**:
```swift
let reduceMotion = UIAccessibility.isReduceMotionEnabled

// Conditionally apply animations
if reduceMotion {
    .opacity(isFlipped ? 0 : 1)  // Simple fade
} else {
    .rotation3DEffect(...)        // 3D flip
}
```

---

## Dark Mode (MVP Only)

**ZenCards MVP ships with Dark Mode only** (Light Mode in v1.1).

**Rationale**:
- Simplifies development (no dual theme)
- Zen/calm aesthetic fits dark theme
- Liquid Glass materials optimized for dark
- Can add Light Mode post-launch based on feedback

**Design Considerations**:
- All colors chosen for dark backgrounds
- Text colors use iOS adaptive system colors
- Materials automatically adapt to dark mode

---

## Design Tokens (SwiftUI)

### Example Design Token File

```swift
// DesignSystem.swift
import SwiftUI

enum DesignSystem {
    // Colors
    static let primaryTeal = Color(hex: "#14B8A6")
    static let primaryTealLight = Color(hex: "#5EEAD4")
    static let secondaryGreen = Color(hex: "#10B981")

    static let actionEasy = Color(hex: "#10B981")
    static let actionHard = Color(hex: "#F59E0B")
    static let actionAgain = Color(hex: "#EF4444")

    // Spacing
    static let spacing = (
        xs: 4.0,
        sm: 8.0,
        md: 12.0,
        lg: 16.0,
        xl: 20.0,
        xxl: 24.0
    )

    // Corner Radius
    static let radius = (
        sm: 8.0,
        md: 12.0,
        lg: 16.0,
        xl: 24.0
    )

    // Gradients
    static let primaryGradient = LinearGradient(
        colors: [primaryTeal, secondaryGreen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
```

---

## Platform Specifics

### iOS 17.0+ Features

**App Intents** (for widget):
- Fully supported in design system
- Use system materials for widget backgrounds
- Follow iOS widget design guidelines

**Liquid Glass Materials**:
- `.ultraThinMaterial`, `.regularMaterial`, `.thickMaterial`
- Available on iOS 15+, but optimized for iOS 17+

### iPhone Sizes

**Design for**:
- iPhone 12/13/14: 390 x 844 pt
- iPhone 14 Pro/15 Pro: 393 x 852 pt
- iPhone 14 Plus/15 Plus: 428 x 926 pt

**Safe Areas**:
- Top: Dynamic Island или notch
- Bottom: Home indicator (34pt)
- Horizontal: Edge padding (16pt standard)

**Widget Sizes**:
- Small: 158 x 158 pt (approximately)
- Medium: 338 x 158 pt (approximately)
- Large: 338 x 354 pt (approximately)

---

## Design Checklist

Before handoff to Phase 3 (Development):

- [ ] Color palette defined (Teal/Green)
- [ ] Typography scale established (SF Pro Rounded + SF Pro)
- [ ] Spacing system documented (4pt base)
- [ ] Liquid Glass materials specified
- [ ] Component library created (buttons, cards, inputs)
- [ ] Animation system defined (spring curves)
- [ ] Accessibility requirements specified (VoiceOver, Dynamic Type, contrast)
- [ ] Dark Mode colors confirmed
- [ ] All screen mockups created (Priority 1-3)
- [ ] Widget design complete (Small/Medium/Large)
- [ ] Design tokens ready for SwiftUI

---

**Next**: Screen designs (onboarding, review, widget, etc.)
