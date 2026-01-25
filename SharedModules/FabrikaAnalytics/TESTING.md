# FabrikaAnalytics Testing Guide

## Testing Checklist

### Phase 4: Testing Analytics Functionality

After integrating FabrikaAnalytics into your app, follow this checklist to verify everything works.

## Prerequisites

1. **Mac with Xcode 15.0+**
2. **iOS Simulator installed**
3. **NoPressureApp integrated with FabrikaAnalytics** ✅

## Functional Testing

### 1. Verify Local Storage

**Test: Events are stored in SwiftData**

```bash
cd /Users/pavelloucker/Documents/Fabrika/git/NoPressureApp
./build_and_run.sh
```

**Steps:**
1. Launch app on simulator
2. Navigate to Library screen
3. Open a deck and start study session
4. Rate a few cards (Again, Hard, Good, Easy)
5. Complete the session

**Verify:**
```swift
// In Xcode Debug Console or using SwiftData inspector
// Check that AnalyticsEventRecord entries exist:
// - screen_viewed (Library, Home)
// - study_session_started
// - card_rated (multiple)
// - study_session_completed
```

**Expected Result:** All events stored locally in SwiftData, no errors in console.

---

### 2. Verify Event Properties

**Test: Events contain correct properties**

**Check in SwiftData:**
- `study_session_started` has: `deck_name`, `due_cards_count`
- `card_rated` has: `rating`, `card_age_days`
- `study_session_completed` has: `cards_reviewed`, `duration_seconds`, `cards_per_minute`
- `screen_viewed` has: `screen_name`

**Expected Result:** All event properties are correctly populated.

---

### 3. Verify User Stats Calculation

**Test: UserStats calculates correctly from local events**

**Steps:**
1. Complete 2-3 study sessions
2. Add code to display stats (or check in debugger):

```swift
let stats = analytics.getUserStats(from: modelContext)
print("Streak: \(stats.streakDays) days")
print("Cards Reviewed: \(stats.totalCardsReviewed)")
print("Study Sessions: \(stats.totalStudySessions)")
```

**Expected Result:**
- Streak shows 1 day (if tested today)
- Cards Reviewed matches number of cards rated
- Study Sessions matches number of completed sessions
- Average cards per session calculated correctly

---

### 4. Verify Privacy (MVP Mode)

**Test: No cloud tracking in MVP mode**

**Configuration Check:**
```swift
// In NoPressureApp.swift
let config = AnalyticsConfiguration(
    enableAmplitude: false,  // ✅ Disabled
    enableAppsFlyer: false,   // ✅ Disabled
    enableCloudSync: false,   // ✅ Disabled
    hasUserConsent: true      // ✅ Local tracking only
)
```

**Steps:**
1. Launch app
2. Perform actions (navigate, study)
3. Check Debug Console

**Expected Result:**
- No network requests to Amplitude or AppsFlyer
- No errors about missing API keys
- Events stored locally only

---

## Performance Testing

### 1. App Launch Performance

**Test: No performance impact on app launch**

**Steps:**
1. Profile app launch with Instruments
2. Compare with/without analytics

**Expected Result:**
- App launch < 2 seconds
- Analytics initialization < 50ms
- No blocking on main thread

---

### 2. Event Tracking Performance

**Test: Event tracking doesn't block UI**

**Steps:**
1. Rate 20+ cards rapidly
2. Check for UI lag or freezing

**Expected Result:**
- UI remains responsive
- No noticeable delays
- Events queued asynchronously

---

## Integration Testing

### 1. Screen Tracking

**Test: Screen views tracked correctly**

**Steps:**
1. Navigate: Home → Library → Study Session
2. Check AnalyticsEventRecord in SwiftData

**Expected Events:**
- `screen_viewed` with `screen_name: "Home"`
- `screen_viewed` with `screen_name: "Library"`

---

### 2. Study Session Flow

**Test: Complete study session tracking**

**Steps:**
1. Start study session (Deck with 5 cards)
2. Rate all 5 cards
3. Complete session

**Expected Events (in order):**
1. `study_session_started` (deck_name, due_cards_count: 5)
2. `card_rated` × 5 (with different ratings)
3. `study_session_completed` (cards_reviewed: 5, duration > 0)

---

### 3. Milestone Tracking

**Test: Milestones triggered correctly**

**Steps:**
1. Rate 10 cards total

**Expected Events:**
- `milestone_reached` (milestone_type: "cards_reviewed", value: 10)

---

## Privacy Testing (For Future Cloud Integration)

### 1. Consent Management

**Test: No cloud tracking without consent**

**When enabling Amplitude/AppsFlyer:**
```swift
let config = AnalyticsConfiguration(
    enableAmplitude: true,
    enableAppsFlyer: true,
    enableCloudSync: true,
    hasUserConsent: false  // ❌ No consent
)
```

**Expected Result:**
- Events stored locally ✅
- No events sent to cloud ✅
- Console message: "User has not consented to analytics"

---

### 2. ATT Permission (Future)

**Test: App Tracking Transparency flow**

**Prerequisites:**
- Add `NSUserTrackingUsageDescription` to Info.plist
- Enable AppsFlyer

**Steps:**
1. Launch app (fresh install)
2. ATT prompt appears
3. Deny tracking

**Expected Result:**
- App continues working
- No AppsFlyer events sent
- Local analytics still works

---

## Error Handling

### 1. Missing SwiftData Context

**Test: Graceful handling of nil context**

```swift
analytics.track(StandardEvent.appLaunched, context: nil)
```

**Expected Result:**
- No crash
- Event not stored locally
- Cloud adapters still work (if enabled)

---

### 2. Invalid Event Names

**Test: Event taxonomy validation**

```swift
let isValid = EventTaxonomy.validateEventName("invalid-name")  // false
let isValid2 = EventTaxonomy.validateEventName("valid_name")   // true
```

**Expected Result:**
- Validation works correctly
- Invalid names can be logged/reported

---

## Debugging Tips

### View SwiftData Records

**Option 1: Xcode Debug Console**
```swift
let descriptor = FetchDescriptor<AnalyticsEventRecord>()
let events = try? modelContext.fetch(descriptor)
events?.forEach { print($0.name, $0.timestamp) }
```

**Option 2: Instruments**
- Run app with Core Data template
- View AnalyticsEventRecord, SessionRecord, PrivacyConsent

**Option 3: SQLite Browser**
```bash
# Find SwiftData database
~/Library/Developer/CoreSimulator/Devices/.../Library/Application Support/

# Open with SQLite browser
```

---

## Test Report Template

```markdown
# FabrikaAnalytics Test Report

**Date:** [Date]
**Tester:** [Name]
**App:** NoPressureApp
**Version:** [Version]

## Functional Tests
- [ ] Local storage working
- [ ] Event properties correct
- [ ] User stats calculate correctly
- [ ] Privacy (MVP mode) works

## Performance Tests
- [ ] App launch < 2s
- [ ] Event tracking non-blocking

## Integration Tests
- [ ] Screen tracking works
- [ ] Study session flow complete
- [ ] Milestones triggered

## Issues Found
1. [Issue description]
2. [Issue description]

## Recommendations
- [Recommendation 1]
- [Recommendation 2]
```

---

## Next Steps After Testing

1. ✅ All tests pass → Ready for production
2. ⚠️ Minor issues → Document and fix
3. ❌ Major issues → Review implementation

**For Production:**
1. Add Amplitude API key
2. Add AppsFlyer keys
3. Enable cloud sync with user consent
4. Add Privacy Settings view
5. Add Stats view for users
6. Test with real API keys

---

## Support

**Issues with FabrikaAnalytics?**
- Check SharedModules/FabrikaAnalytics/README.md
- Review event taxonomy in EventTaxonomy.swift
- Verify SwiftData schema includes analytics models

**Common Issues:**
1. **Events not storing:** Check modelContext passed to track()
2. **Stats showing zero:** Ensure events have correct names
3. **Performance lag:** Check for blocking operations on main thread
