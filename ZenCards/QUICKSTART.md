# ZenCards - Quick Start Guide (No Paywall Version)

## What Changed

✅ Removed Adapty dependency (no paywall/subscription)
✅ Removed onboarding flow
✅ App starts directly in main TabView
✅ All features unlocked by default
✅ Sample data automatically created in DEBUG mode

## Quick Setup (5 Minutes)

### Option 1: Xcode GUI (Recommended)

1. **Open Xcode** (15.0+)

2. **Create New Project**:
   - File → New → Project
   - iOS → App
   - Product Name: `ZenCards`
   - Interface: SwiftUI
   - Storage: SwiftData
   - iOS 17.0+

3. **Add Widget Extension**:
   - Click **+** at bottom of targets
   - iOS → Widget Extension
   - Name: `ZenCardsWidget`
   - Include Configuration Intent: ✅

4. **Delete Xcode's default files**:
   - Delete `ContentView.swift` (Xcode's version)
   - Delete `Item.swift`
   - Delete widget defaults

5. **Add our code**:
   - Drag `ZenCards/ZenCards/` folder → Xcode
   - Target: ✅ ZenCards
   - Drag `ZenCards/ZenCardsWidget/` folder → Xcode
   - Target: ✅ ZenCardsWidget

6. **Share models with widget**:
   - Select `Card.swift`, `Deck.swift`, `ReviewRecord.swift`
   - Check ✅ ZenCardsWidget in File Inspector
   - Select `FSRSService.swift` → Check ✅ ZenCardsWidget
   - Select `Color+Hex.swift` → Check ✅ ZenCardsWidget

7. **Add FSRS package**:
   - File → Add Package Dependencies
   - URL: `https://github.com/open-spaced-repetition/swift-fsrs`
   - Version: `5.0.0`
   - Targets: ✅ ZenCards, ✅ ZenCardsWidget

8. **Configure App Groups**:
   - Both targets → Signing & Capabilities → + Capability → App Groups
   - Add: `group.com.zencards.shared`

9. **Build & Run** (Cmd+R)
   - Select scheme: ZenCards
   - Select simulator: iPhone 15 Pro
   - Click ▶️

### Option 2: Command Line (Advanced)

```bash
# Coming soon - requires swift-package-manager Xcode project generation
```

## What You'll See

### First Launch

- ✅ App opens directly to main TabView
- ✅ 3 decks with 16 sample cards automatically created:
  - **Spanish** (8 cards) - Basic phrases
  - **Swift Basics** (4 cards) - Programming concepts
  - **World Capitals** (4 cards) - Geography

### Tabs

1. **Review**: Flip cards and rate them (Again/Hard/Easy)
2. **Decks**: Manage your decks (create, edit, delete)
3. **Settings**: App preferences

### Testing Widget

1. Run app once (registers widget)
2. Stop app
3. Simulator Home → Long press → + button
4. Search "ZenCards"
5. Add Medium or Large widget
6. You should see first due card
7. Tap Hard/Easy buttons → Widget updates!

## Sample Data

In DEBUG mode, app automatically creates:

- **Spanish Deck** (Teal):
  - Hello → Hola
  - Goodbye → Adiós
  - Thank you → Gracias
  - + 5 more cards

- **Swift Basics** (Amber):
  - What is SwiftUI? → A declarative UI framework...
  - What is SwiftData? → A data persistence framework...
  - + 2 more cards

- **World Capitals** (Purple):
  - Capital of France? → Paris
  - Capital of Japan? → Tokyo
  - + 2 more cards

All cards are **new** and **due immediately** for testing.

## File Structure

```
ZenCards/
├── QUICKSTART.md                  ← You are here
├── XCODE_SETUP.md                ← Detailed setup guide
├── README.md                     ← Full documentation
├── ACCESSIBILITY.md              ← Accessibility guide
│
├── Package.swift                 ← SPM dependencies (FSRS only)
│
├── ZenCards/                     ← Main app target
│   ├── ZenCardsApp.swift         ← App entry (with sample data)
│   ├── ContentView.swift         ← Root view (just MainTabView)
│   ├── SampleDataHelper.swift    ← Sample data creation
│   ├── Info.plist                ← App metadata
│   ├── ZenCards.entitlements     ← App Groups capability
│   │
│   ├── Models/
│   │   ├── Card.swift            ← SwiftData model
│   │   ├── Deck.swift            ← SwiftData model
│   │   └── ReviewRecord.swift    ← SwiftData model
│   │
│   ├── Services/
│   │   ├── FSRSService.swift     ← FSRS algorithm wrapper
│   │   └── TTSService.swift      ← Text-to-Speech
│   │
│   └── Views/
│       ├── Review/               ← Review session
│       ├── Decks/                ← Deck management
│       ├── Cards/                ← Card management
│       ├── Settings/             ← Settings screen
│       └── Components/           ← Reusable UI
│
└── ZenCardsWidget/               ← Widget extension target
    ├── ZenCardsWidget.swift      ← Widget bundle
    ├── ZenCardsWidgetProvider.swift
    ├── Info.plist
    ├── ZenCardsWidget.entitlements
    ├── Views/
    │   └── ZenCardsWidgetViews.swift
    └── Intents/
        └── RateCardIntent.swift
```

## Troubleshooting

### App crashes on launch

**Error**: "Could not initialize ModelContainer"
- **Fix**: Clean build folder (Cmd+Shift+K) and rebuild

### Widget shows "No cards due"

- **Fix**: Make sure sample data was created (check console)
- **Fix**: Verify App Groups in both targets
- **Fix**: Restart simulator

### Build errors

1. Clean: Product → Clean Build Folder (Cmd+Shift+K)
2. Resolve packages: File → Packages → Resolve Package Versions
3. Restart Xcode

### Sample data not appearing

- **Fix**: Delete app from simulator
- **Fix**: Clean build folder
- **Fix**: Run again

### Widget buttons don't work

- **Fix**: Make sure model files are shared with widget target
- **Fix**: Verify App Group is enabled in both targets
- **Fix**: Check Console.app for errors (filter: "ZenCardsWidget")

## Testing Checklist

- [ ] App launches without crash
- [ ] See 3 sample decks
- [ ] Can create new deck
- [ ] Can create new card
- [ ] Can review cards (flip animation works)
- [ ] Rating buttons (Again/Hard/Easy) work
- [ ] TTS preview works in card edit
- [ ] Widget appears in widget gallery
- [ ] Widget shows due card
- [ ] Widget Hard button updates card
- [ ] Widget Easy button updates card

## Next Steps

Once app works:

1. **Test all features**:
   - Create custom decks
   - Add your own cards
   - Review cards to test FSRS scheduling
   - Test accessibility (VoiceOver, Dynamic Type)

2. **Test all 3 widget sizes**:
   - Small: Shows due count
   - Medium: Card + 2 buttons (Hard/Easy)
   - Large: Card front+back + 4 buttons (Again/Hard/Good/Easy)

3. **Customize**:
   - Change colors in design_system.md
   - Add more sample decks
   - Customize UI components

4. **Deploy**:
   - Test on physical device
   - Create beta build
   - Submit to TestFlight

## Need Help?

1. Check **XCODE_SETUP.md** for detailed setup instructions
2. Check **README.md** for architecture details
3. Check **ACCESSIBILITY.md** for accessibility implementation
4. Check Console.app for error logs

## What's Next?

To re-enable paywall later:
1. Add Adapty SDK back to Package.swift
2. Restore PaywallView.swift, OnboardingView.swift
3. Restore SubscriptionService.swift
4. Update ContentView.swift to show onboarding/paywall flow
5. Configure Adapty dashboard with products

---

**Estimated Setup Time**: 5-10 minutes (first time)
**Build Time**: 2-3 minutes
**Sample Data**: Auto-created on first launch (DEBUG mode only)

Enjoy building with ZenCards! 🎉
