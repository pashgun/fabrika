# Xcode Project Setup Instructions

## Prerequisites

- macOS with Xcode 15.0+ installed
- iOS 17.0+ Simulator or physical device

## Step 1: Create Xcode Project

1. Open Xcode
2. File → New → Project
3. Choose **iOS** → **App**
4. Configure project:
   - **Product Name**: `ZenCards`
   - **Team**: Select your team
   - **Organization Identifier**: `com.zencards` (or your own)
   - **Bundle Identifier**: Will be `com.zencards.ZenCards`
   - **Interface**: SwiftUI
   - **Storage**: SwiftData
   - **Language**: Swift
   - **Minimum Deployment**: iOS 17.0

5. Save project to: `ZenCards/` directory (replace the existing Package.swift location)

## Step 2: Add Widget Extension Target

1. In Xcode, click **+** button at bottom of target list
2. Choose **iOS** → **Widget Extension**
3. Configure:
   - **Product Name**: `ZenCardsWidget`
   - **Include Configuration Intent**: ✅ YES
   - **Bundle Identifier**: `com.zencards.ZenCards.ZenCardsWidget`

4. Xcode will create widget files - DELETE the default ones:
   - Delete `ZenCardsWidget.swift` (Xcode's version)
   - Delete `ZenCardsWidgetBundle.swift`
   - Delete `ZenCardsWidgetLiveActivity.swift`
   - Delete `AppIntent.swift`

## Step 3: Import Existing Code

### Main App Target

1. **Delete** Xcode's default files:
   - `ContentView.swift` (Xcode's version)
   - `Item.swift`
   - Any other default files

2. **Add** our files to `ZenCards` target:
   - Drag `ZenCards/ZenCards/` folder into Xcode project navigator
   - Select **all subfolders** (Models, Services, Views, Extensions)
   - Check **"Copy items if needed"** → NO (they're already in place)
   - Check **"Create groups"** (not folder references)
   - Target Membership: ✅ ZenCards

3. **Add** `ZenCards.entitlements` and `Info.plist` to target

### Widget Extension Target

1. **Add** our widget files to `ZenCardsWidget` target:
   - Drag `ZenCards/ZenCardsWidget/` folder into project
   - Target Membership: ✅ ZenCardsWidget

2. **Share models** with widget:
   - Select `Card.swift`, `Deck.swift`, `ReviewRecord.swift`
   - In File Inspector (right panel): Check ✅ ZenCardsWidget target
   - Select `Color+Hex.swift`: Check ✅ ZenCardsWidget target
   - Select `FSRSService.swift`: Check ✅ ZenCardsWidget target

## Step 4: Add Swift Package Dependencies

1. File → Add Package Dependencies
2. Enter URL: `https://github.com/open-spaced-repetition/swift-fsrs`
3. Version: `5.0.0` (Up to Next Major)
4. Click **Add Package**
5. Select targets:
   - ✅ ZenCards
   - ✅ ZenCardsWidget (for FSRS integration)

## Step 5: Configure App Groups

### Main App Target

1. Select `ZenCards` target
2. **Signing & Capabilities** tab
3. Click **+ Capability** → **App Groups**
4. Click **+** under App Groups list
5. Enter: `group.com.zencards.shared`
6. Click **OK**

### Widget Extension Target

1. Select `ZenCardsWidget` target
2. **Signing & Capabilities** tab
3. Click **+ Capability** → **App Groups**
4. Enable the **same** group: ✅ `group.com.zencards.shared`

## Step 6: Fix Build Settings

### Main App Target

1. Select `ZenCards` target
2. **Build Settings** tab
3. Search for "SWIFT_VERSION"
   - Set to: **Swift 5**

4. Search for "IPHONEOS_DEPLOYMENT_TARGET"
   - Set to: **17.0**

5. Check **Info.plist File** path:
   - Should be: `ZenCards/Info.plist`

6. Check **Entitlements File** path:
   - Should be: `ZenCards/ZenCards.entitlements`

### Widget Extension Target

1. Select `ZenCardsWidget` target
2. **Build Settings** tab
3. Same settings as above
4. Check paths:
   - Info.plist: `ZenCardsWidget/Info.plist`
   - Entitlements: `ZenCardsWidget/ZenCardsWidget.entitlements`

## Step 7: Resolve Build Errors

### Common Issues

1. **"Cannot find 'FSRS' in scope"**
   - Solution: Wait for SPM to finish resolving packages
   - File → Packages → Resolve Package Versions

2. **"Cannot find type 'Card' in scope"** (in Widget)
   - Solution: Make sure `Card.swift` is added to ZenCardsWidget target
   - Select file → File Inspector → Check ✅ ZenCardsWidget

3. **"Missing import for FSRS"**
   - Solution: Add `import FSRS` at top of files using Rating enum

4. **"App Group not found"**
   - Solution: Both targets must have EXACT same group ID
   - Verify in Signing & Capabilities

## Step 8: Create Sample Data (Optional)

Add this code to create test decks/cards for development:

```swift
// In ZenCardsApp.swift init()
#if DEBUG
// Create sample data for testing
createSampleDataIfNeeded(modelContainer: modelContainer)
#endif

private func createSampleDataIfNeeded(modelContainer: ModelContainer) {
    let context = ModelContext(modelContainer)

    // Check if data exists
    let descriptor = FetchDescriptor<Deck>()
    let existingDecks = (try? context.fetch(descriptor)) ?? []

    if existingDecks.isEmpty {
        // Create sample deck
        let deck = Deck(name: "Spanish", colorHex: "#14B8A6")
        context.insert(deck)

        // Create sample cards
        let cards = [
            Card(front: "Hello", back: "Hola", deck: deck),
            Card(front: "Goodbye", back: "Adiós", deck: deck),
            Card(front: "Thank you", back: "Gracias", deck: deck)
        ]

        cards.forEach { context.insert($0) }
        try? context.save()
    }
}
```

## Step 9: Build & Run

1. Select **ZenCards** scheme (NOT ZenCardsWidget)
2. Select iOS Simulator: **iPhone 15 Pro** (or any iOS 17+ simulator)
3. Click **▶️ Run** (Cmd+R)

### First Launch

- App should open directly to main TabView
- You'll see 3 tabs: Review / Decks / Settings
- If you added sample data, you'll see "Spanish" deck
- Otherwise, tap **+** in Decks tab to create your first deck

## Step 10: Test Widget

### Add Widget to Simulator

1. Run the app once (it registers the widget)
2. **Stop** the app
3. On Simulator Home Screen:
   - Long press on empty area
   - Tap **+** button (top left)
   - Search for "ZenCards"
   - Select widget size (Small / Medium / Large)
   - Tap **Add Widget**

### Test Widget Functionality

1. Create cards in the app (they should be due immediately)
2. Add **Medium** or **Large** widget to Home Screen
3. Widget should show first due card
4. Tap **Hard** or **Easy** button on widget
5. Widget should update with next card

## Troubleshooting

### Widget shows "No cards due"

- Make sure you have created cards
- Check that cards are marked as "due" (new cards are due immediately)
- Verify App Group is configured correctly in BOTH targets
- Check Console.app for widget errors:
  - Filter: "ZenCardsWidget"
  - Look for data sync errors

### Widget buttons don't work

- Make sure `RateCardIntent` has target membership for ZenCardsWidget
- Check that `FSRSService` is available to widget
- Verify all model files are shared with widget target

### Build errors

1. Clean build folder: **Product → Clean Build Folder** (Cmd+Shift+K)
2. Resolve packages: **File → Packages → Resolve Package Versions**
3. Restart Xcode
4. Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData`

### Runtime errors

- Check Console.app for crash logs
- Look for SwiftData migration errors
- Verify App Group container is accessible

## Success Criteria

✅ App builds without errors
✅ App launches on simulator
✅ Can create decks
✅ Can create cards
✅ Can review cards with flip animation
✅ FSRS schedules next review correctly
✅ Widget shows on Home Screen
✅ Widget displays due cards
✅ Widget buttons rate cards correctly

## Next Steps

Once everything works:
1. Test on physical device
2. Test all accessibility features (VoiceOver, Dynamic Type)
3. Test all 3 widget sizes
4. Create beta build for TestFlight
5. Prepare App Store assets (screenshots, description)

## Support

If you encounter issues:
1. Check `README.md` for architecture details
2. Check `ACCESSIBILITY.md` for accessibility implementation
3. Review generated code in `ZenCards/ZenCards/` folders
4. Check Console.app for detailed error messages

---

**Estimated Time**: 30-45 minutes for first-time setup
**Estimated Build Time**: 2-3 minutes (depends on Mac)
**Estimated SPM Resolution**: 1-2 minutes (first time)
