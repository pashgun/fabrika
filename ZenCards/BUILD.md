# ZenCards - Quick Build Guide

## One-Command Build & Run 🚀

```bash
./build_and_run.sh
```

This automated script will:
1. ✅ Check for Xcode and dependencies (installs if missing)
2. ✅ Generate Xcode project from `project.yml`
3. ✅ Download FSRS dependency via Swift Package Manager
4. ✅ Build main app + widget extension
5. ✅ Start iOS Simulator (iPhone 15 Pro)
6. ✅ Install and launch ZenCards

**First run**: ~5 minutes (installs xcodegen, downloads FSRS package)
**Subsequent runs**: ~2 minutes (just builds and launches)

---

## What You'll See

When the app launches on simulator:

✅ **3 Sample Decks** (automatically created):
- **Spanish** (8 cards) - Basic phrases: Hello→Hola, Goodbye→Adiós, etc.
- **Swift Basics** (4 cards) - Programming concepts: SwiftUI, SwiftData, @State, FSRS
- **World Capitals** (4 cards) - Geography: Paris, Tokyo, Brasília, Canberra

✅ **All cards are new and due immediately** - ready to review!

✅ **Main TabView** with 3 tabs:
- **Review** - Flip cards and rate them (Again/Hard/Easy)
- **Decks** - Browse, create, edit decks
- **Settings** - Daily reminders, app info

---

## Testing Features

### Core Functionality

**Review Session:**
1. Tap **Review** tab
2. Tap card to flip (shows answer)
3. Rate card: **Again** / **Hard** / **Easy**
4. Watch FSRS schedule next review
5. Card disappears from "due" list

**Deck Management:**
1. Tap **Decks** tab
2. Tap **+** button to create new deck
3. Choose color and name
4. Tap deck to see cards
5. Swipe left on card to **Edit** or **Delete**

**Card Creation:**
1. Inside a deck, tap **+** button
2. Enter **front** (question) and **back** (answer)
3. Tap **Preview Pronunciation** to test TTS
4. Tap **Save**

### Interactive Widget (Killer Feature!)

**Setup:**
1. Run app once (registers widget with iOS)
2. Stop the app (not required, but clearer for testing)
3. On Simulator **Home Screen**:
   - Long press on empty area
   - Tap **+** button (top left corner)
   - Search for **"ZenCards"**
   - Choose widget size:
     - **Small**: Shows due card count
     - **Medium**: Card + Hard/Easy buttons (2 ratings)
     - **Large**: Card front+back + Again/Hard/Good/Easy buttons (4 ratings)
   - Tap **Add Widget**

**Testing Widget:**
1. Widget shows first due card
2. Tap **Hard** button → Card rescheduled, widget shows next card
3. Tap **Easy** button → Card rescheduled for later, widget updates
4. If no cards due → Widget shows "All Done! ✅"

**Widget Data Sync:**
- Widget reads from shared App Group (`group.com.zencards.shared`)
- Main app writes to shared UserDefaults after each review
- Widget timeline refreshes every 15 minutes automatically
- Rating from widget triggers immediate timeline reload

---

## Manual Xcode Development

If you prefer to use Xcode GUI:

### 1. Generate Project (one time)
```bash
cd /home/user/fabrika/ZenCards
xcodegen generate
```

### 2. Open in Xcode
```bash
open ZenCards.xcodeproj
```

### 3. Use Xcode Normally
- Select **ZenCards** scheme
- Select **iPhone 15 Pro** simulator
- Click **▶️ Run** button (or press Cmd+R)

### 4. Edit and Rebuild
- Make code changes in Xcode
- Cmd+R to rebuild and run
- No need to run script again

---

## Project Structure

```
ZenCards/
├── project.yml                      # XcodeGen config (defines targets)
├── build_and_run.sh                 # Automated build script
├── BUILD.md                         # This file
│
├── ZenCards/                        # Main app target
│   ├── ZenCardsApp.swift            # @main entry point
│   ├── ContentView.swift            # Root view (TabView)
│   ├── SampleDataHelper.swift       # Auto-creates sample data
│   ├── Info.plist
│   ├── ZenCards.entitlements        # App Groups capability
│   │
│   ├── Models/
│   │   ├── Card.swift               # SwiftData + FSRS state
│   │   ├── Deck.swift               # Collection of cards
│   │   └── ReviewRecord.swift       # Review history
│   │
│   ├── Services/
│   │   ├── FSRSService.swift        # FSRS algorithm wrapper
│   │   └── TTSService.swift         # Text-to-speech
│   │
│   └── Views/
│       ├── Review/                  # Review session with flip
│       ├── Decks/                   # Deck CRUD
│       ├── Cards/                   # Card CRUD
│       ├── Settings/                # Settings screen
│       └── Components/              # Reusable UI
│
└── ZenCardsWidget/                  # Widget extension target
    ├── ZenCardsWidget.swift         # @main widget bundle
    ├── ZenCardsWidgetProvider.swift # Timeline provider
    ├── Info.plist
    ├── ZenCardsWidget.entitlements  # App Groups capability
    ├── Views/
    │   └── ZenCardsWidgetViews.swift  # Small/Medium/Large
    └── Intents/
        └── RateCardIntent.swift     # Interactive widget actions
```

---

## Troubleshooting

### "xcodegen: command not found"

**Solution:**
```bash
brew install xcodegen
```

If Homebrew is not installed:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

### "iPhone 15 Pro simulator not found"

**Solution:**
1. Open **Xcode**
2. **Window** → **Devices and Simulators**
3. Click **+** button (bottom left)
4. Select **iPhone 15 Pro**
5. Click **Create**
6. Run script again

**Alternative:** Edit `build_and_run.sh` line 135 to use a different simulator:
```bash
-destination 'platform=iOS Simulator,name=iPhone 14 Pro'
```

---

### Build Errors

**Clean and rebuild:**
```bash
# Remove build artifacts
rm -rf ~/Library/Developer/Xcode/DerivedData/ZenCards-*

# Remove generated project
rm -rf ZenCards.xcodeproj

# Rebuild
./build_and_run.sh
```

**Check Xcode version:**
```bash
xcodebuild -version
# Should be Xcode 15.0 or later
```

---

### Widget Not Working

**Issue:** Widget shows "No cards due" even though you have cards

**Solutions:**

1. **Verify App Groups are configured:**
   - Both `ZenCards` and `ZenCardsWidget` targets must have **identical** App Group
   - Should be: `group.com.zencards.shared`
   - Check in `project.yml` (should be auto-configured)

2. **Check widget logs:**
   ```bash
   # Open Console.app
   # Filter: "ZenCardsWidget"
   # Look for errors about data not found
   ```

3. **Re-register widget:**
   ```bash
   # Uninstall app from simulator
   xcrun simctl uninstall booted com.zencards.app

   # Rebuild and reinstall
   ./build_and_run.sh
   ```

4. **Verify shared data:**
   - Open Xcode debugger
   - Set breakpoint in `FSRSService.syncDueCardsToWidget()`
   - Check if data is written to UserDefaults
   - Check if widget reads same group

---

### Widget Buttons Don't Work

**Issue:** Tapping Hard/Easy does nothing

**Solutions:**

1. **Check target membership:**
   - `RateCardIntent.swift` must be in **ZenCardsWidget** target
   - Models (`Card.swift`, `Deck.swift`) must be in **both** targets
   - `FSRSService.swift` must be in **both** targets

2. **Check App Intents:**
   - Widget uses `RateCardIntent` (App Intents framework, iOS 17+)
   - Simulator must be iOS 17+
   - Check Console.app for intent execution errors

3. **Restart simulator:**
   ```bash
   xcrun simctl shutdown booted
   xcrun simctl boot "iPhone 15 Pro"
   ```

---

### App Crashes on Launch

**Issue:** App crashes immediately after launch

**Common causes:**

1. **SwiftData migration issue:**
   ```bash
   # Delete app data (simulator only)
   xcrun simctl uninstall booted com.zencards.app
   ./build_and_run.sh
   ```

2. **Sample data creation error:**
   - Check console for errors in `SampleDataHelper`
   - Sample data only runs in `DEBUG` mode

3. **Missing FSRS dependency:**
   ```bash
   # Manually resolve packages
   xcodebuild -resolvePackageDependencies -project ZenCards.xcodeproj
   ```

---

### FSRS Package Download Fails

**Issue:** "Failed to resolve package dependencies"

**Solutions:**

1. **Check internet connection** (package downloads from GitHub)

2. **Clear SPM cache:**
   ```bash
   rm -rf ~/Library/Caches/org.swift.swiftpm
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```

3. **Manually add package in Xcode:**
   - Open `ZenCards.xcodeproj`
   - File → Add Package Dependencies
   - Enter: `https://github.com/open-spaced-repetition/swift-fsrs`
   - Version: `5.0.0` (Up to Next Major)

---

## Requirements

### System Requirements
- **macOS**: Ventura 13.0 or later
- **Xcode**: 15.0 or later
- **iOS Simulator**: 17.0 or later
- **Homebrew**: For installing xcodegen (auto-installed by script)

### Disk Space
- Xcode: ~15 GB
- DerivedData (build artifacts): ~500 MB
- FSRS package: ~5 MB

### Time Estimates
- First build (cold): ~5 minutes
- Incremental rebuild: ~30 seconds
- Clean rebuild: ~2 minutes
- Simulator boot: ~10 seconds

---

## Advanced Usage

### Build Only (No Run)

```bash
# Generate project
xcodegen generate

# Build without launching
xcodebuild \
  -project ZenCards.xcodeproj \
  -scheme ZenCards \
  -sdk iphonesimulator \
  build
```

### Run on Different Simulator

Edit `build_and_run.sh` line 135:
```bash
# Change from:
-destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# To:
-destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)'
```

### Build for Physical Device

```bash
xcodebuild \
  -project ZenCards.xcodeproj \
  -scheme ZenCards \
  -sdk iphoneos \
  -configuration Release \
  build
```

**Note:** Requires Apple Developer account and code signing setup.

### Export IPA for Distribution

```bash
# Archive
xcodebuild archive \
  -project ZenCards.xcodeproj \
  -scheme ZenCards \
  -archivePath ZenCards.xcarchive

# Export IPA
xcodebuild -exportArchive \
  -archivePath ZenCards.xcarchive \
  -exportPath . \
  -exportOptionsPlist ExportOptions.plist
```

---

## Next Steps

Once app is running successfully:

1. **Explore the code:**
   - Open `ZenCards.xcodeproj` in Xcode
   - Review SwiftData models in `Models/`
   - Study FSRS integration in `Services/FSRSService.swift`
   - Examine widget implementation in `ZenCardsWidget/`

2. **Customize the design:**
   - Colors defined in `Extensions/Color+Hex.swift`
   - Design tokens in `design_system.md`
   - Component library in `Views/Components/`

3. **Add features:**
   - Check `backlog_mvp.md` for deferred features
   - Add CloudKit sync (v1.1)
   - Add statistics dashboard (v1.1)
   - Add AI auto-card creation (v1.1)

4. **Test accessibility:**
   - Enable VoiceOver (Settings → Accessibility)
   - Test Dynamic Type (Settings → Display & Text Size)
   - Test Reduce Motion (Settings → Accessibility → Motion)
   - Review `ACCESSIBILITY.md` for implementation details

5. **Prepare for release:**
   - Read `README.md` for architecture overview
   - Review `XCODE_SETUP.md` for deployment steps
   - Configure Adapty for paywall (optional, removed in free version)
   - Create App Store assets (screenshots, description)

---

## Getting Help

### Documentation Files
- **BUILD.md** (this file) - Quick build guide
- **README.md** - Architecture and feature overview
- **QUICKSTART.md** - 5-minute quick start
- **XCODE_SETUP.md** - Detailed Xcode manual setup
- **ACCESSIBILITY.md** - Accessibility implementation guide
- **design_system.md** - Design tokens and components
- **screen_designs_mvp.md** - Screen specifications

### Common Issues
- Check **Troubleshooting** section above
- Review Console.app logs (filter: "ZenCards")
- Check Xcode build logs for detailed errors

### Project Status
- ✅ Phase 1 (PM Lead): Requirements complete
- ✅ Phase 2 (UI Engineer): Design system complete
- ✅ Phase 3 (Swift Developer): Implementation complete
- 🎯 **Current**: Testing and validation
- ⏭️ **Next**: App Store submission prep

---

**Happy Building!** 🎉

Questions? Check the other documentation files or review the code structure above.
