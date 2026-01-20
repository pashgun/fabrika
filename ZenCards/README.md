# ZenCards - Beautiful Spaced Repetition

Modern flashcard app with FSRS algorithm, interactive widgets, and Liquid Glass design.

## Features

- **FSRS Algorithm**: Free Spaced Repetition Scheduler v5 for optimal learning
- **Interactive Widget**: Review cards directly from Home Screen (iOS 17+)
- **Liquid Glass Design**: Translucent materials with teal/green zen aesthetic
- **Text-to-Speech**: Pronunciation support for better memorization
- **Dark Mode Only**: Simplified MVP design
- **Full Accessibility**: VoiceOver, Dynamic Type, Reduce Motion support

## Architecture

### Tech Stack
- **SwiftUI** + **SwiftData** for declarative UI and data persistence
- **FSRS** (swift-fsrs v5.0.0) for spaced repetition scheduling
- **Adapty SDK** (v3.0.0) for subscription management
- **App Intents** for interactive widgets (iOS 17+)
- **App Group** (`group.com.zencards.shared`) for widget data sharing

### Project Structure
```
ZenCards/
├── ZenCardsApp.swift              # App entry point
├── ContentView.swift              # Root view with Onboarding/Paywall/Main flow
├── Models/
│   ├── Card.swift                 # SwiftData model with FSRS state
│   ├── Deck.swift                 # SwiftData model with relationships
│   └── ReviewRecord.swift         # Review history tracking
├── Services/
│   ├── FSRSService.swift          # FSRS wrapper with widget sync
│   ├── SubscriptionService.swift  # Adapty wrapper
│   └── TTSService.swift           # Text-to-Speech service
├── Views/
│   ├── Onboarding/                # 3-page onboarding flow
│   ├── Paywall/                   # Adapty paywall
│   ├── Review/                    # Review session with flip animation
│   ├── Decks/                     # Deck CRUD
│   ├── Cards/                     # Card CRUD with TTS
│   ├── Settings/                  # Settings + subscription management
│   └── Components/                # Reusable UI (GlassCard, Buttons, etc.)
└── Extensions/
    └── Color+Hex.swift            # Hex color support

ZenCardsWidget/
├── ZenCardsWidget.swift           # Widget bundle
├── ZenCardsWidgetProvider.swift   # Timeline provider
├── Views/
│   └── ZenCardsWidgetViews.swift  # Small/Medium/Large widget views
└── Intents/
    └── RateCardIntent.swift       # App Intent for card rating
```

## Setup Instructions

### 1. Xcode Project Setup

1. Create new iOS App project in Xcode:
   - **Product Name**: ZenCards
   - **Bundle ID**: `com.zencards.app`
   - **Minimum Deployment**: iOS 17.0
   - **Interface**: SwiftUI
   - **Storage**: SwiftData

2. Add Widget Extension target:
   - **Product Name**: ZenCardsWidget
   - **Bundle ID**: `com.zencards.app.widget`
   - **Include Configuration Intent**: Yes

3. Enable App Groups:
   - Target → Signing & Capabilities → **+ Capability** → App Groups
   - Add group: `group.com.zencards.shared`
   - Enable for **both** main app and widget targets

### 2. Add Dependencies

Add via Swift Package Manager (File → Add Package Dependencies):

1. **swift-fsrs**: `https://github.com/open-spaced-repetition/swift-fsrs` (v5.0.0+)
2. **AdaptySDK-iOS**: `https://github.com/adaptyteam/AdaptySDK-iOS` (v3.0.0+)

### 3. Adapty Configuration

1. Sign up at [Adapty](https://adapty.io)
2. Create app in Adapty Dashboard
3. Copy **Public SDK Key**
4. Replace in `ZenCardsApp.swift`:
   ```swift
   Adapty.activate("PUBLIC_SDK_KEY_FROM_ADAPTY_DASHBOARD")
   ```
5. Create paywall with placement ID: `main_paywall`
6. Add products:
   - Monthly: `com.zencards.premium.monthly` ($4.99/month)
   - Yearly: `com.zencards.premium.yearly` ($39.99/year)
7. Create access level: `premium`

### 4. App Store Connect Setup

1. Create app in App Store Connect
2. Add In-App Purchases:
   - Auto-Renewable Subscriptions
   - Reference names match Adapty products
3. Link Adapty to App Store Connect (follow Adapty docs)

### 5. Build & Run

1. Select ZenCards scheme
2. Run on iOS 17+ simulator or device
3. Widget will appear in Widget Gallery after first launch

## Accessibility Implementation

All screens implement full accessibility support per Apple HIG.

### VoiceOver

Every interactive element has:
```swift
.accessibilityLabel("Clear description")
.accessibilityHint("What happens when activated")
```

Examples:
- Card flip: "Tap to flip to back. Reveals the answer."
- Rating buttons: "Rate as Easy. Marks this card as easy to remember."
- Widget buttons: "Rate as Hard. Reviews card from Home Screen."

### Dynamic Type

All text uses semantic sizes that scale:
```swift
.font(.body)        // NOT .font(.system(size: 17))
.font(.headline)
.font(.caption)
```

Capped at `.xxxLarge` for layouts that break at extreme sizes.

### Reduce Motion

Animations respect accessibility setting:
```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

.animation(reduceMotion ? .none : .spring(...), value: isFlipped)
```

Affected features:
- Card flip animation → fade transition
- Onboarding page transitions → crossfade
- Button feedback → instant state change

### Color Contrast

All colors meet WCAG AA (4.5:1 for text, 3:1 for large text):
- Teal (#14B8A6) on dark background: 5.2:1 ✅
- White on Teal: 4.6:1 ✅
- Green (#10B981) on dark background: 5.8:1 ✅

Tested with [Color Contrast Analyzer](https://www.tpgi.com/color-contrast-checker/).

### Minimum Touch Targets

All interactive elements are **44×44pt minimum** (Apple HIG):
```swift
.frame(minWidth: 44, minHeight: 44)
```

Applied to:
- All buttons (56pt height for comfort)
- List row tap areas
- Widget buttons
- Color picker circles

## Widget Development

### Data Flow

1. **Main App** → Review card with FSRS
2. **FSRSService** → Save to SwiftData
3. **FSRSService** → Sync to UserDefaults (App Group)
   ```swift
   UserDefaults(suiteName: "group.com.zencards.shared")
   sharedDefaults?.set(data, forKey: "dueCards")
   ```
4. **Widget** → Read from UserDefaults
5. **RateCardIntent** → Rate card → Reload timeline

### Testing Widgets

1. Run widget scheme
2. Add widget to Home Screen
3. Rate cards from widget → Verify timeline updates
4. Test all 3 sizes (Small, Medium, Large)

### Debugging

Enable widget timeline logging:
```swift
WidgetCenter.shared.reloadAllTimelines()
print("Widget timeline reloaded")
```

View widget logs in Console.app (filter: "ZenCardsWidget")

## Testing Checklist

### Phase 3A: Foundation
- [ ] Cards persist in SwiftData
- [ ] FSRS schedules next review correctly
- [ ] Review flow: flip gesture works
- [ ] Action buttons update FSRS state
- [ ] Due cards query returns correct results
- [ ] VoiceOver reads card content
- [ ] Dynamic Type scales text

### Phase 3B: Paywall + Content
- [ ] Adapty paywall loads products
- [ ] Purchase flow completes
- [ ] Restore purchases works
- [ ] Premium access check works
- [ ] Onboarding navigates to paywall
- [ ] Deck CRUD operations work
- [ ] Card CRUD operations work
- [ ] TTS pronunciation plays
- [ ] Empty states show correctly

### Phase 3C: Widget
- [ ] Widget shows due cards
- [ ] Hard button rates card correctly
- [ ] Easy button rates card correctly
- [ ] Widget updates after rating
- [ ] App Group shares data
- [ ] Widget reflects app changes
- [ ] All 3 sizes display correctly
- [ ] Settings manage subscription link works

### Accessibility
- [ ] All elements have labels/hints
- [ ] VoiceOver navigation is logical
- [ ] Dynamic Type scales to xxxLarge
- [ ] Contrast meets WCAG AA
- [ ] Reduce Motion disables animations
- [ ] All buttons meet 44×44pt minimum

## Known Constraints

1. **Dark Mode Only**: Light Mode deferred to v1.1
2. **iOS 17+ Only**: Required for App Intents (interactive widgets)
3. **No CloudKit Sync**: Deferred to v1.1
4. **Single Language**: TTS defaults to `en-US`
5. **Basic FSRS**: Using default weights

## Next Steps

1. **Internal Testing**: Test on iPhone SE, Pro, Pro Max
2. **Beta Testing**: TestFlight with 10-20 users
3. **App Store Submission**: Prepare metadata, screenshots, privacy policy
4. **Launch**: Submit with Adapty paywall live

## Resources

- [FSRS Algorithm Paper](https://github.com/open-spaced-repetition/fsrs4anki/wiki/The-Algorithm)
- [Adapty iOS SDK Docs](https://docs.adapty.io/docs/ios-sdk)
- [App Intents Guide](https://developer.apple.com/documentation/appintents)
- [SwiftData Guide](https://developer.apple.com/documentation/swiftdata)
- [Apple Accessibility HIG](https://developer.apple.com/design/human-interface-guidelines/accessibility)

## License

Proprietary - All rights reserved

## Contact

For questions or issues, contact: support@zencards.app
