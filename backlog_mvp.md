# Product Backlog: ZenCards 2.0 — MVP Scope

## Executive Summary

**ZenCards MVP** — минимальный viable product для validation core concept: **Anki с красивым UI**.

MVP фокус:
- ✅ **Liquid Glass Design** — главная дифференциация от Anki
- ✅ **FSRS Algorithm** — modern spaced repetition
- ✅ **Core Flashcard Experience** — CRUD + Review
- ✅ **Onboarding** — показать ценность за 30 секунд
- ✅ **Paywall** — monetization через Adapty

**Откладываем на v1.1**:
- 🔮 AI Auto-Creation (OCR → Card) — premium feature позже
- 🔮 Interactive Widget — сложная фича, не критична для validation
- 🔮 Statistics Dashboard — nice-to-have

**Цель MVP**: Доказать что users хотят "beautiful Anki" и готовы платить.

---

## MVP Feature Set

### MUST HAVE (Core MVP)

#### 1. **Manual Card Creation (CRUD)** ⭐
**Why MVP**: Базовая функциональность flashcard app.

**Scope**:
- Create card: front (question/context), back (answer)
- Edit card
- Delete card (swipe-to-delete)
- Organize in Decks

**Out of MVP**:
- ❌ AI auto-creation (сложно, дорого)
- ❌ Photo/image cards (v1.1)
- ❌ Audio recording (v1.1)
- ✅ TTS pronunciation (системный AVSpeechSynthesizer - easy win)

**SwiftData Models** (simplified):
```swift
@Model
class Card {
    var id: UUID
    var front: String
    var back: String
    var deck: Deck

    // FSRS metadata
    var stability: Double = 0
    var difficulty: Double = 0
    var dueDate: Date = Date()
    var lastReview: Date?
}

@Model
class Deck {
    var id: UUID
    var name: String
    var color: String  // Hex
    var cards: [Card]
}
```

**Acceptance Criteria**:
- [ ] Create/Edit/Delete карточки
- [ ] Front/Back text fields (plain text only)
- [ ] Assign card to deck
- [ ] List all cards (grouped by deck)

---

#### 2. **FSRS Review Session** ⭐⭐⭐
**Why MVP**: Core value proposition — effective spaced repetition.

**Scope**:
- Fetch due cards (where dueDate <= today)
- Show front → tap to flip → show back
- 3 rating buttons: Again (red), Hard (yellow), Easy (green)
- FSRS calculates next review date
- Save review record

**FSRS Integration**:
- Package: `open-spaced-repetition/swift-fsrs` (v5.0.0)
- Wrapper class для integration с SwiftData models

**UI**:
- Flip animation (simple 3D rotation)
- Progress: "5 cards due today"
- Confetti animation при завершении session

**Acceptance Criteria**:
- [ ] Due cards loaded correctly
- [ ] Flip animation works
- [ ] FSRS scheduling after rating
- [ ] Next review date saved

---

#### 3. **Deck Management** ⭐
**Why MVP**: Organization critical для multiple topics.

**Scope**:
- Create deck (name, color)
- Edit deck (rename, change color)
- Delete deck (with warning if has cards)
- List decks with card count

**Out of MVP**:
- ❌ Deck icons (используем SF Symbols default)
- ❌ Nested decks (flat structure only)
- ❌ Deck sharing (v2.0)

**Acceptance Criteria**:
- [ ] Create/Edit/Delete decks
- [ ] Color picker (predefined teal/green palette)
- [ ] Deck shows card count + due count

---

#### 4. **Liquid Glass Design System** ⭐⭐⭐
**Why MVP**: Это ГЛАВНАЯ дифференциация от Anki. Without this, мы просто another flashcard app.

**Scope**:
- Liquid Glass materials на всех экранах
- Color palette: Teal/Green gradient
- SF Pro Rounded typography
- Dark Mode (only, no Light Mode для MVP)
- Smooth animations (flip, transitions)

**Following**:
- axiom-liquid-glass principles (если доступно)
- Apple HIG for iOS 18/iOS 26 materials

**Acceptance Criteria**:
- [ ] All screens use `.ultraThinMaterial` или `.glass()` (если iOS 26)
- [ ] Teal/Green color scheme applied
- [ ] Animations smooth (60fps)
- [ ] Dark Mode only (simplifies MVP)

---

#### 5. **Onboarding (3 Screens)** ⭐⭐
**Why MVP**: First impression critical. Users должны понять value за 30 секунд.

**Flow**:
1. **Welcome Screen**:
   - Hero: ZenCards logo + Liquid Glass background
   - Headline: "Beautiful Spaced Repetition"
   - Subheadline: "Learn smarter, not harder"
   - CTA: "Get Started"

2. **Feature Highlight**:
   - Visual: Mock review session (flip animation)
   - Headline: "Modern Algorithm"
   - Text: "FSRS spaced repetition helps you remember long-term"
   - Skip button (top-right)

3. **Value Prop**:
   - Visual: Beautiful UI comparison (implied: vs Anki)
   - Headline: "Finally, flashcards you'll love using"
   - Text: "Gorgeous design meets powerful learning"
   - CTA: "Start Learning" → Navigate to Paywall

**Acceptance Criteria**:
- [ ] 3 screens с page indicators
- [ ] Swipe to navigate (or Next button)
- [ ] Skip button (goes to Paywall)
- [ ] "Start Learning" → Paywall
- [ ] Show only on first launch (UserDefaults flag)

---

#### 6. **Paywall (Adapty Integration)** ⭐⭐⭐
**Why MVP**: Нужно monetize с первого дня. No "try before buy" для MVP — confidence в product.

**Strategy**: **Paywall-first** (после onboarding, before main app)
- Users видят paywall immediately after onboarding
- Trust в product: "We're confident you'll love this"
- Benchmark: Mochi делает так же ($5/mo subscription)

**Adapty Setup**:
- SDK integration: `AdaptySDK` via SPM
- Paywall: use Adapty Paywall Builder (no custom UI для MVP)
- Products:
  - **Monthly**: $4.99/mo
  - **Yearly**: $39.99/year (save 33%)
- Features list:
  - ✅ Unlimited decks & cards
  - ✅ FSRS spaced repetition
  - ✅ Liquid Glass design
  - ✅ Cloud sync (coming soon)
  - 🔮 AI auto-creation (coming soon)
  - 🔮 Interactive widget (coming soon)

**Implementation**:
```swift
// После onboarding:
if !Adapty.shared.hasActiveSubscription() {
    // Show Adapty paywall
    AdaptyUI.getPaywall(placementId: "onboarding") { paywall in
        present(paywall)
    }
}
```

**Out of MVP**:
- ❌ Free trial (нет trial для MVP, direct purchase)
- ❌ Limited free tier (paywall-first strategy)
- ❌ Custom paywall UI (используем Adapty Paywall Builder)

**Acceptance Criteria**:
- [ ] Adapty SDK integrated
- [ ] Paywall shows after onboarding
- [ ] Monthly + Yearly subscriptions available
- [ ] Purchase flow works (testflight sandbox)
- [ ] hasActiveSubscription() check работает
- [ ] Analytics events sent (paywall shown, purchase completed)

---

#### 7. **Settings Screen** ⭐
**Why MVP**: Users нужно manage subscription, preferences.

**Scope**:
- Account section:
  - Restore purchases (Adapty)
  - Manage subscription (link to App Store)
- App settings:
  - Daily reminder notification time
- About:
  - Version number
  - Privacy Policy (link)
  - Terms of Service (link)
  - Support email

**Out of MVP**:
- ❌ AI provider choice (нет AI в MVP)
- ❌ Theme toggle (Dark Mode only)
- ❌ Advanced FSRS parameters

**Acceptance Criteria**:
- [ ] Restore purchases works
- [ ] Manage subscription opens App Store
- [ ] Notification time picker
- [ ] Privacy/Terms links работают

---

### SHOULD HAVE (If Time Permits)

#### 1. **Search & Filter**
- Search cards by text
- Filter by deck
- Filter by due date ("Due Today" only)

**Why Not Must**: Can browse all cards, не critical для MVP.

#### 2. **Study Streak Tracking**
- Track consecutive days reviewed
- Show streak count (simple number)
- Reset if miss a day

**Why Not Must**: Motivational feature, но не core functionality.

#### 3. **Basic Statistics**
- Total cards reviewed today
- Cards due today count
- Simple retention rate (%)

**Why Not Must**: Nice-to-have, но не critical для MVP validation.

---

### WON'T HAVE (v1.1 or Later)

#### ❌ AI Auto-Creation (OCR → Card)
**Why Not MVP**:
- Complexity: Camera, OCR, LLM integration
- Cost: LLM API expensive
- Risk: Feature может не resonate с users

**Strategy**: Add as **premium feature** в v1.1 после validation core product.
- "Upgrade to Pro for AI auto-creation"
- Отдельный tier: ZenCards Pro+ ($9.99/mo)

#### ❌ Interactive Widget
**Why Not MVP**:
- Complexity: App Intents, WidgetKit, shared data
- Testing burden: iOS 17/18 compatibility
- Not critical для core value prop

**Strategy**: Add в v1.1 как major feature update.
- Marketing: "Now review from your Home Screen!"

#### ❌ Statistics Dashboard
**Why Not MVP**:
- Nice-to-have, но basic stats (cards reviewed today) достаточно
- Charts (SwiftUI Charts) — additional complexity

**Strategy**: v1.1 feature (решает Mochi's "spartan stats" complaint).

#### ❌ Card Templates
**Why Not MVP**:
- Complexity: Template system, customization UI
- MVP uses simple front/back format

**Strategy**: v1.2 (power user feature).

#### ❌ CloudKit Sync
**Why Not MVP**:
- Complexity: CloudKit setup, conflict resolution
- Local-only достаточно для validation

**Strategy**: v1.1 (mentioned в paywall "coming soon").

#### ❌ Context-First Card Design
**Why Not MVP**:
- Unproven UX pattern (риск)
- MVP uses traditional front/back (proven)

**Strategy**: A/B test в beta, если feedback positive → add в v1.1.

---

## MVP User Journey

### 1. First Launch → Onboarding
1. User opens app
2. Onboarding (3 screens): Welcome → Feature Highlight → Value Prop
3. Tap "Start Learning" → Paywall

### 2. Paywall → Purchase
1. Adapty paywall shows (Monthly $4.99 / Yearly $39.99)
2. User selects plan → Apple Pay purchase
3. Success → Main app unlocks

### 3. Main App → First Use
1. Empty state: "Create your first deck"
2. Tap "+" → Create deck (name: "Spanish", color: Teal)
3. Tap deck → Empty state: "Add your first card"
4. Tap "+" → Create card
   - Front: "Hola"
   - Back: "Hello"
   - Tap TTS icon → hear pronunciation
5. Tap "Save" → Card created

### 4. Review Session
1. Dashboard shows: "1 card due today"
2. Tap "Start Review"
3. Review screen:
   - Shows front: "Hola"
   - Tap → flip animation → shows back: "Hello"
   - Tap speaker icon → TTS pronunciation
4. Rate: Easy (green button)
5. FSRS: next review in 4 days
6. Session complete: "All done! 🎉"

---

## MVP Technical Stack

### Platform
- **iOS 17.0+** (lower than original 17.0 для App Intents, since no widget)
  - Actually: можем support iOS 16.0+ для MVP (no App Intents needed)
  - Decision: Stay iOS 17.0+ для future-proofing
- **iPhone only** (no iPad для MVP)
- **Dark Mode only** (Light Mode complexity removed)

### Frameworks
- **SwiftUI** — all UI
- **SwiftData** — local persistence
- **FSRS**: `open-spaced-repetition/swift-fsrs` (v5.0.0)
- **Adapty**: `AdaptySDK` + `AdaptyUI` для paywall
- **AVFoundation**: TTS pronunciation (AVSpeechSynthesizer)
- **UserNotifications**: daily reminders

### NOT Using in MVP
- ❌ Vision framework (no OCR)
- ❌ WidgetKit / App Intents (no widget)
- ❌ CloudKit (no sync)
- ❌ Swift Charts (no advanced stats)
- ❌ LLM API (no AI)

### SwiftData Models (MVP)

```swift
@Model
class Card {
    @Attribute(.unique) var id: UUID
    var front: String
    var back: String
    var createdAt: Date
    var deck: Deck

    // FSRS metadata
    var stability: Double
    var difficulty: Double
    var dueDate: Date
    var lastReview: Date?
    var reviewCount: Int

    init(front: String, back: String, deck: Deck) {
        self.id = UUID()
        self.front = front
        self.back = back
        self.createdAt = Date()
        self.deck = deck
        self.stability = 0
        self.difficulty = 0
        self.dueDate = Date()  // Due immediately for new cards
        self.reviewCount = 0
    }
}

@Model
class Deck {
    @Attribute(.unique) var id: UUID
    var name: String
    var color: String  // Hex color code
    var createdAt: Date
    var cards: [Card]

    init(name: String, color: String) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.createdAt = Date()
        self.cards = []
    }
}

@Model
class ReviewRecord {
    @Attribute(.unique) var id: UUID
    var card: Card
    var rating: Int  // 1 = Again, 2 = Hard, 4 = Easy
    var reviewedAt: Date
    var nextReviewDate: Date

    init(card: Card, rating: Int, nextReviewDate: Date) {
        self.id = UUID()
        self.card = card
        self.rating = rating
        self.reviewedAt = Date()
        self.nextReviewDate = nextReviewDate
    }
}
```

---

## MVP Success Criteria

### Launch Goals (First Month)
- **Downloads**: 500 users (lower than original 1,000 for MVP validation)
- **Purchase Rate**: 10% (50 paid users)
- **DAU/MAU**: 30% (daily use)
- **App Store Rating**: 4.5⭐+

### Key Metrics
- **Paywall Conversion**: 10%+ (industry standard 5-10%)
- **Day 7 Retention**: 30%+ (paid users)
- **Review Completion Rate**: 60%+ (users complete daily reviews)

### Qualitative Goals
- **User Feedback**: "This is the Anki I always wanted" (UI praise)
- **Common Praise**: Liquid Glass design, smooth animations
- **Top Complaint**: "I want AI auto-creation" → Validates v1.1 roadmap

---

## MVP Development Phases

### Phase 1: PM Lead — COMPLETE ✅
- Research-First approach
- Competitive analysis
- Feature prioritization (this document)

### Phase 2: UI Engineer (Design)
**Deliverables**:
- Design system (colors, typography, Liquid Glass)
- Key screens mockups:
  1. Onboarding (3 screens)
  2. Deck List (empty state + populated)
  3. Card List (empty state + populated)
  4. Card Create/Edit
  5. Review Session (front + back states)
  6. Settings
- Accessibility audit (VoiceOver, Dynamic Type, contrast)

**Timeline**: 3-5 days

### Phase 3: Swift Developer (Implementation)
**Deliverables**:
- SwiftData models
- FSRS integration wrapper
- All screens implementation
- Adapty integration
- Onboarding flow
- TTS pronunciation

**Timeline**: 10-14 days

### Phase 4: QA & Testing
**Deliverables**:
- Unit tests для FSRS logic
- UI tests для core flows
- Manual testing (iPhone 12/13/14/15)
- TestFlight beta (10-20 testers)

**Timeline**: 3-5 days

### Phase 5: ASO & Launch
**Deliverables**:
- App Store listing (title, description, keywords, screenshots)
- Privacy Policy & Terms (required)
- Submit for review
- Launch marketing (ProductHunt, Reddit)

**Timeline**: 2-3 days

**Total MVP Timeline**: ~20-25 days

---

## Adapty Integration Details

### Setup Steps

#### 1. **Adapty Account Setup**
- Create account: adapty.io
- Create app: "ZenCards"
- Get API keys (Public SDK key)

#### 2. **Products Setup in Adapty Dashboard**
- Create Access Level: "premium"
- Create Products:
  - `zencards_monthly`: $4.99/mo
  - `zencards_yearly`: $39.99/yr
- Link products to Access Level

#### 3. **Paywall Setup**
- Create Placement: "onboarding"
- Use Adapty Paywall Builder (no-code)
- Configure:
  - Headline: "Unlock ZenCards Premium"
  - Features list: (see above)
  - Products: Monthly + Yearly
  - CTA: "Subscribe Now"
  - Footer: "Restore purchases" link

#### 4. **SDK Integration**

**SPM Dependencies**:
```swift
dependencies: [
    .package(url: "https://github.com/adaptyteam/AdaptySDK-iOS", from: "2.10.0"),
    .package(url: "https://github.com/adaptyteam/AdaptyUI-iOS", from: "2.1.0")
]
```

**AppDelegate/App.swift**:
```swift
import Adapty
import AdaptyUI

@main
struct ZenCardsApp: App {
    init() {
        Adapty.activate("YOUR_PUBLIC_SDK_KEY")
        AdaptyUI.activate()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

**Check Subscription**:
```swift
func checkSubscription() async -> Bool {
    do {
        let profile = try await Adapty.getProfile()
        return profile.accessLevels["premium"]?.isActive == true
    } catch {
        return false
    }
}
```

**Show Paywall**:
```swift
func showPaywall() {
    Task {
        do {
            let paywall = try await Adapty.getPaywall(placementId: "onboarding")
            let paywallView = try await AdaptyUI.paywallView(
                for: paywall,
                products: paywall.products
            )

            // Present paywallView (fullScreenCover)
            present(paywallView)
        } catch {
            print("Paywall error: \(error)")
        }
    }
}
```

**Handle Purchase**:
```swift
// Adapty handles automatically через AdaptyUI
// После успешной покупки:
AdaptyUI.onPurchaseSuccess { product in
    // Navigate to main app
    dismiss()
}
```

#### 5. **Analytics Events**

Adapty автоматически tracks:
- Paywall shown
- Purchase started
- Purchase completed
- Purchase failed
- Restore purchases

Дополнительные custom events:
```swift
Adapty.logShowPaywall(paywall)  // When paywall appears
```

---

## MVP Pricing Strategy

### Paywall-First Rationale

**Why No Free Trial?**
1. **Confidence Signal**: "We're so confident you'll love this, we show paywall first"
2. **Simplicity**: No trial management, no free tier limitations
3. **Benchmark**: Mochi uses same strategy successfully
4. **Target Audience**: Anki refugees already know value of spaced repetition — они готовы платить

**Why Not Freemium?**
1. **Complexity**: Managing free tier limitations (card limits, deck limits)
2. **Support Burden**: Free users generate support requests без revenue
3. **MVP Focus**: Want to validate willingness to pay immediately

### Pricing Rationale

**Monthly: $4.99**
- Matches Mochi ($5/mo)
- Lower than Anki Mobile ($24.99 one-time, но эквивалентно ~$2-3/mo amortized)
- Psychological: Under $5 barrier

**Yearly: $39.99 (Save 33%)**
- Equivalent to $3.33/mo
- Strong incentive для annual commitment
- Benchmark: Education apps typically 30-40% discount на annual

### Conversion Optimization

**Paywall Copy**:
- Headline: "Unlock Beautiful Learning"
- Subheadline: "Join thousands using ZenCards to master new skills"
- Social proof: "★★★★★ 'Finally, flashcards I actually enjoy using'"

**Features List** (В paywall):
- ✅ Unlimited decks & cards
- ✅ FSRS spaced repetition algorithm
- ✅ Liquid Glass design (exclusive)
- ✅ Text-to-speech pronunciation
- ✅ Daily reminders & streaks
- 🔮 Cloud sync across devices (coming soon)
- 🔮 AI auto-creation (coming soon)
- 🔮 Interactive widget (coming soon)

**Trust Signals**:
- "Cancel anytime"
- "7-day money back guarantee" (Apple's refund policy)
- "Restore purchases" link (for existing users)

---

## Out-of-Scope Reminders

### Features Explicitly NOT in MVP

| Feature | Why Not MVP | When to Add |
|---------|-------------|-------------|
| AI Auto-Creation | Complexity, cost | v1.1 (premium tier) |
| Interactive Widget | iOS complexity | v1.1 (major update) |
| CloudKit Sync | Backend complexity | v1.1 (mentioned as "coming soon") |
| Statistics Dashboard | Nice-to-have | v1.1 |
| Card Templates | Power user feature | v1.2 |
| Context-First Cards | Unproven UX | A/B test → v1.1 if positive |
| Image/Photo Cards | Complexity | v1.2 |
| Shared Decks | Backend + moderation | v2.0 |
| iPad Optimization | Platform complexity | v1.3 |
| Siri Integration | After widget | v1.5 |

---

## Risk Mitigation

### Risk 1: Paywall-First Hurts Conversion
**Mitigation**:
- Strong onboarding (show value в 30 секунд)
- Social proof в paywall (fake reviews пока нет real)
- 7-day refund guarantee
- If conversion < 5%: Consider adding 3-day trial

### Risk 2: Users Complain "No Features"
**Mitigation**:
- Clear roadmap в paywall: "Coming soon: AI, Widget, Sync"
- Communication: "MVP to validate, more features coming"
- Reddit post: "Built first version, what features do you want?"

### Risk 3: FSRS Too Complex for Users
**Mitigation**:
- Onboarding explains: "Trust the algorithm"
- No advanced settings в MVP (hidden complexity)
- Default parameters work для 80% users

### Risk 4: Competition Launches Similar
**Mitigation**:
- Speed: Launch MVP в 3-4 weeks
- Differentiation: Liquid Glass дизайн unique
- Community: Build early adopter community (Reddit, Twitter)

---

## MVP Launch Checklist

### Pre-Launch (Development)
- [ ] All MUST HAVE features implemented
- [ ] Adapty integration tested (sandbox)
- [ ] TestFlight beta с 10-20 testers
- [ ] Critical bugs fixed
- [ ] VoiceOver accessibility tested
- [ ] Performance tested (iPhone 12+)

### App Store Submission
- [ ] App Store Connect setup (app ID, bundle ID)
- [ ] Privacy Policy published (website or Github Pages)
- [ ] Terms of Service published
- [ ] App Store listing:
  - Title: "ZenCards: Smart Flashcards"
  - Subtitle: "Beautiful Spaced Repetition"
  - Keywords: flashcards, anki, study, learning, spaced repetition
  - Screenshots (5): Onboarding, Review, Liquid Glass UI, Deck List, Stats
  - App Preview video (optional для MVP)
- [ ] Age rating: 4+
- [ ] Pricing: Free (with in-app subscription)

### Post-Launch
- [ ] Monitor Adapty analytics (conversion rate)
- [ ] Monitor App Store reviews
- [ ] Reddit post: r/languagelearning, r/Anki
- [ ] ProductHunt launch (Day 3-4)
- [ ] Collect user feedback → prioritize v1.1 features

---

## Next Phase: UI Engineer

**@ui_engineer**: MVP scope определён. Создай Design System для следующих экранов (priority order):

### Priority 1 (Critical Path):
1. **Onboarding** (3 screens)
2. **Paywall** (Adapty template — just визуальные референсы)
3. **Review Session** (front + back states + buttons)

### Priority 2 (Core Functionality):
4. **Deck List** (empty state + populated)
5. **Card List** (empty state + populated)
6. **Card Create/Edit**

### Priority 3 (Secondary):
7. **Settings**
8. **Empty states** (various)

**Design Focus**:
- **Liquid Glass materials** — главное отличие от Anki
- **Teal/Green palette** — zen, calming
- **Dark Mode only** — упрощает MVP
- **Accessibility** — VoiceOver labels, contrast, Dynamic Type

**Deliverable**: `design_system.md` + screen mockups (SwiftUI Previews or Figma)

---

**MVP Philosophy**: "Do less, better" — Focus на core experience с beautiful execution, не feature bloat. 🎯
