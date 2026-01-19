# Example Workflow: Meditation App

Полный пример создания Meditation app через Fabrika.

## Входные Данные

**Идея**: "Create a meditation app like Calm with guided sessions, breathing exercises, progress tracking, and daily reminders"

**Режим**: Local (`--local`)

**Команда**:
```bash
./factory.sh start "Create a meditation app like Calm with guided sessions, breathing exercises, progress tracking, and daily reminders" --local
```

---

## Phase 1: Research (pm_lead)

### Действия
1. ✅ Поиск конкурентов: Calm, Headspace, Insight Timer, Ten Percent Happier
2. ✅ Анализ отзывов (1-star и 5-star)
3. ✅ Определение feature set
4. ✅ Создание user stories
5. ✅ Технические требования

### Результат: backlog.md

**Executive Summary**:
> MindfulMoments - приложение для ежедневной медитации, предлагающее guided sessions, breathing exercises, и персонализированный трекинг прогресса для снижения стресса и улучшения well-being.

**Конкурентный Анализ**:
- **Calm** (4.8⭐, 10M+ downloads): Ключевые фичи - sleep stories, breathing exercises, музыка
- **Headspace** (4.7⭐, 5M+ downloads): Gamification, streak tracking, courses
- **Insight Timer** (4.8⭐, 1M+ downloads): Community features, live sessions

**Feature Breakdown (MUST HAVE)**:
1. ✅ Guided Meditation Sessions (5, 10, 15, 20 min)
2. ✅ Breathing Exercises (Box Breathing, 4-7-8, etc.)
3. ✅ Progress Tracking (streak, total minutes, sessions completed)
4. ✅ Daily Reminders (push notifications)
5. ✅ Background Audio Support
6. ✅ Offline Mode (downloaded sessions)

**Technical Requirements**:
- SwiftData Models: User, Session, Progress, Reminder
- HealthKit: Mindful minutes logging
- AVFoundation: Audio playback with background support
- UserNotifications: Daily reminders
- CloudKit: Sync progress across devices

**Target Audience**:
- Primary: Busy professionals (25-45), высокий стресс, ищут quick relaxation
- Secondary: Beginners в meditation

---

## Phase 2: Design (ui_engineer)

### Действия
1. ✅ Создание calming color palette (soft blues, purples, pastels)
2. ✅ Liquid Glass cards для session selection
3. ✅ Design system с focus на tranquility
4. ✅ Accessibility planning (VoiceOver important для eyes-closed use)
5. ✅ Animations (breathing circle visualization)

### Результат: design_system.md

**Color System**:
```swift
// Primary - Calming blues
primaryColor = Color(hex: "#5B8FA3")    // Soft blue
secondaryColor = Color(hex: "#9D7BB7")  // Gentle purple

// Backgrounds - Light and airy
background = Color(hex: "#F8F9FA")
cardBackground = .regularMaterial  // Liquid Glass

// Accents
accentPositive = Color(hex: "#7BC99C")  // Gentle green for success
```

**Key Components**:
1. **SessionCard** - Liquid Glass card с session info
2. **BreathingCircle** - Animated breathing guide
3. **ProgressRing** - Streak и stats visualization
4. **AudioPlayer** - Custom player controls
5. **TimePicker** - Session duration selector

**Screen Specifications**:

**Home Screen**:
```
┌─────────────────────────────┐
│  Good morning, Alex 🌅      │
│                             │
│  [Current Streak: 7 days]   │  ← Progress Ring
│                             │
│  Quick Start                │
│  ┌───────────────────────┐  │
│  │  🧘 5-Min Morning     │  │  ← SessionCard
│  │  Meditation           │  │     (.regularMaterial)
│  └───────────────────────┘  │
│                             │
│  Breathing Exercises        │
│  ┌─────┐ ┌─────┐ ┌─────┐   │
│  │ Box │ │4-7-8│ │Calm │   │  ← Cards
│  └─────┘ └─────┘ └─────┘   │
│                             │
│  [Browse All Sessions]      │
└─────────────────────────────┘
   [Tab Bar: Home|Stats|Profile]
```

**Breathing Exercise Screen**:
```
┌─────────────────────────────┐
│  Box Breathing              │
│                             │
│        Breathe In           │  ← Instruction
│                             │
│      ┌─────────┐            │
│      │    ●    │            │  ← Animated circle
│      │         │            │     (expands/contracts)
│      └─────────┘            │
│                             │
│      4 seconds              │  ← Timer
│                             │
│  [Pause] [Stop]             │
└─────────────────────────────┘
```

**Accessibility**:
- All SessionCards have descriptive labels: "5-minute morning meditation, beginner level"
- BreathingCircle has audio cues + VoiceOver descriptions
- Dynamic Type support везде
- High contrast mode для text over Liquid Glass

---

## Phase 3: Build (swift_dev)

### Действия
1. ✅ Xcode проект создан: "MindfulMoments"
2. ✅ DesignSystem.swift реализован
3. ✅ SwiftData модели + CloudKit
4. ✅ Audio playback с background support
5. ✅ HealthKit integration
6. ✅ Push notifications
7. ✅ Breathing animation с async/await
8. ✅ App Intents ("Start meditation")

### Результат: Xcode Project

**Structure**:
```
MindfulMoments/
├── App/
│   └── MindfulMomentsApp.swift
├── Models/
│   ├── User.swift (@Model)
│   ├── Session.swift (@Model)
│   ├── Progress.swift (@Model)
│   └── Reminder.swift (@Model)
├── Views/
│   ├── Home/
│   │   ├── HomeView.swift
│   │   └── SessionCard.swift
│   ├── Breathing/
│   │   ├── BreathingView.swift
│   │   └── BreathingCircle.swift
│   ├── Stats/
│   │   └── StatsView.swift
│   └── Components/
│       ├── ProgressRing.swift
│       └── AudioPlayer.swift
├── Services/
│   ├── AudioService.swift (actor)
│   ├── HealthKitService.swift (actor)
│   └── NotificationService.swift (actor)
├── Utilities/
│   └── DesignSystem.swift
└── Resources/
    ├── Assets.xcassets
    └── Audio/ (meditation mp3s)
```

**Key Implementation Details**:

**SwiftData Models**:
```swift
@Model
final class Session {
    @Attribute(.unique) var id: UUID
    var title: String
    var duration: Int  // seconds
    var audioFileName: String
    var category: SessionCategory
    var difficulty: Difficulty

    init(title: String, duration: Int, audioFileName: String, ...) {
        // ...
    }
}

@Model
final class Progress {
    @Attribute(.unique) var id: UUID
    var date: Date
    var sessionCompleted: Session?
    var meditationMinutes: Int

    var user: User?

    init(date: Date, sessionCompleted: Session, minutes: Int) {
        // ...
    }
}
```

**AudioService (Actor for thread-safety)**:
```swift
actor AudioService {
    private var audioPlayer: AVAudioPlayer?

    func play(session: Session) async throws {
        // Configure audio session for background
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)

        // Load and play audio
        guard let url = Bundle.main.url(forResource: session.audioFileName, withExtension: "mp3") else {
            throw AudioError.fileNotFound
        }

        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
    }

    func pause() {
        audioPlayer?.pause()
    }
}
```

**Breathing Animation (async/await)**:
```swift
struct BreathingCircle: View {
    @State private var scale: CGFloat = 1.0
    @State private var phase: BreathingPhase = .inhale

    var body: some View {
        Circle()
            .fill(DesignSystem.Colors.primary.gradient)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
            .overlay {
                Text(phase.instruction)
                    .font(.title2)
                    .foregroundStyle(.white)
            }
            .task {
                await runBreathingCycle()
            }
    }

    @MainActor
    func runBreathingCycle() async {
        while true {
            // Inhale (4s)
            phase = .inhale
            withAnimation(.easeInOut(duration: 4)) {
                scale = 1.5
            }
            try? await Task.sleep(for: .seconds(4))

            // Hold (4s)
            phase = .hold
            try? await Task.sleep(for: .seconds(4))

            // Exhale (4s)
            phase = .exhale
            withAnimation(.easeInOut(duration: 4)) {
                scale = 1.0
            }
            try? await Task.sleep(for: .seconds(4))

            // Hold (4s)
            phase = .holdEmpty
            try? await Task.sleep(for: .seconds(4))
        }
    }
}
```

**App Intents**:
```swift
import AppIntents

struct StartMeditationIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Meditation"
    static var description = IntentDescription("Start a meditation session")

    @Parameter(title: "Duration")
    var duration: Int

    func perform() async throws -> some IntentResult {
        // Start meditation session
        return .result()
    }
}
```

---

## Phase 4: Hard Audit (qa_audit)

### Действия

#### 1. Memory Audit
```bash
/prescan-memory
```
**Findings**:
- ⚠️ Retain cycle in AudioService callback
- ⚠️ NotificationCenter observer not removed

**Fixes Applied**:
```swift
// ❌ Before
Task {
    self.audioService.play(session)
}

// ✅ After
Task { [weak self] in
    guard let self else { return }
    await self.audioService.play(session)
}

// Observer removal in deinit
deinit {
    NotificationCenter.default.removeObserver(self)
}
```

**Result**: ✅ 0 memory leaks

#### 2. Accessibility Audit
```bash
/audit-accessibility
```
**Findings**:
- ⚠️ SessionCard missing accessibility labels
- ⚠️ BreathingCircle animation не описывается для VoiceOver
- ⚠️ AudioPlayer controls не имеют hints

**Fixes Applied**:
```swift
SessionCard(session: session)
    .accessibilityLabel("\(session.title), \(session.duration / 60) minutes, \(session.difficulty.rawValue) level")
    .accessibilityHint("Double tap to start meditation session")

BreathingCircle()
    .accessibilityElement()
    .accessibilityLabel("Breathing guide")
    .accessibilityValue(phase.description)
    .accessibilityHint("Follow the audio cues to breathe")
```

**Result**: ✅ WCAG AA compliant

#### 3. Liquid Glass Audit
```bash
/audit-liquid-glass
```
**Findings**:
- ✅ SessionCards using .regularMaterial appropriately
- ✅ No material layering >2
- ✅ Performance good on iPhone 13

**Result**: ✅ Optimal usage

#### 4. Performance Testing

**Instruments Results**:
- Launch time: 0.9s ✅ (target <2s)
- Memory idle: 38 MB ✅
- Memory peak: 95 MB ✅ (during audio playback)
- Scrolling: 60fps ✅
- Audio latency: <50ms ✅

#### 5. Unit & UI Tests

**Unit Tests Written** (Coverage: 78%):
- `ProgressCalculatorTests`
- `SessionModelTests`
- `BreathingTimerTests`
- `AudioServiceTests` (mocked)

**UI Tests Written**:
- `testCompleteSessionFlow()`
- `testBreathingExerciseStartAndStop()`
- `testProgressTracking()`
- `testNotificationPermission()`

### Результат: Production-Ready Build

**Audit Reports**:
- MEMORY_AUDIT.md - ✅ PASSED
- ACCESSIBILITY_AUDIT.md - ✅ PASSED (WCAG AA)
- LIQUID_GLASS_AUDIT.md - ✅ PASSED
- PERFORMANCE_AUDIT.md - ✅ PASSED
- Test coverage: 78% ✅

**Known Limitations**:
- None critical
- Minor: Audio files currently bundled (no streaming for v1.0)

---

## Phase 5: Delivery (aso_expert)

### Действия

#### 1. App Store Metadata

**App Name**: "MindfulMoments - Meditate"  (29 chars)
**Subtitle**: "Daily Calm & Mindfulness" (24 chars)

**Keywords** (100 chars):
```
meditation,mindfulness,calm,stress,anxiety,breathing,sleep,relax,zen,peace,guided,wellness,health
```

**Description** (Excerpt):
```
MindfulMoments помогает занятым профессионалам найти спокойствие за считанные минуты каждый день.

Всего 5 минут ежедневной медитации могут снизить стресс на 32% и улучшить качество сна.

✨ ЧТО ВЫ ПОЛУЧАЕТЕ:
• Guided медитации от 5 до 20 минут
• Breathing exercises для мгновенного расслабления
• Трекинг прогресса с streak system
• Daily reminders для постоянства
• Работает offline

🎯 КЛЮЧЕВЫЕ ФУНКЦИИ:
• 20+ guided sessions для разных ситуаций
• Box Breathing, 4-7-8 дыхание и другие техники
• Визуальный breathing guide с анимацией
• HealthKit интеграция - логируем mindful minutes
• CloudKit sync - ваш прогресс на всех устройствах

♿ ДОСТУПНОСТЬ:
• Полная поддержка VoiceOver
• Dynamic Type для всех размеров текста
• Высокий контраст (WCAG AA)

🔒 ПРИВАТНОСТЬ:
• Никакого сбора личных данных
• Всё хранится локально на вашем устройстве
• Optional CloudKit sync (под вашим контролем)

📲 НАЧНИТЕ СВОЙ ПУТЬ К СПОКОЙСТВИЮ СЕГОДНЯ!
```

#### 2. Visual Assets Spec

**App Icon**:
- Concept: Простой круг с градиентом (blue → purple)
- В центре: минималистичная иконка meditation pose
- Style: Flat, modern, calming

**Screenshots** (5 шт):
1. **Hero**: Home screen с streak, text overlay "Start your mindfulness journey"
2. **Feature 1**: Breathing exercise in action, text: "Guided breathing exercises"
3. **Feature 2**: Session playing, text: "5-20 minute guided meditations"
4. **Feature 3**: Stats screen, text: "Track your progress"
5. **Social Proof**: "Join 10,000+ users finding calm" (после launch)

#### 3. App Store Configuration

**Category**: Health & Fitness
**Age Rating**: 4+ (no objectionable content)
**Monetization**: Free (v1.0), Freemium planned for v2.0
**Privacy**: No data collection in v1.0

**Demo Account**: N/A (no login required)

**Review Notes**:
```
MindfulMoments - Daily Meditation App

KEY FEATURES TO TEST:
1. Home Screen → Select any guided session → Play audio
2. Breathing tab → Select Box Breathing → Watch animation
3. Stats tab → View progress tracking

TECHNICAL HIGHLIGHTS:
- Swift 6, SwiftUI
- SwiftData with CloudKit sync
- Full VoiceOver support (WCAG AA)
- HealthKit integration (optional)

PERMISSIONS:
- Notifications (optional, for daily reminders)
- HealthKit (optional, for mindful minutes logging)

App works fully without granting any permissions.

Thank you for reviewing!
```

#### 4. Launch Strategy

**Week 1 Goals**:
- 1,000 downloads
- 4.5+ App Store rating
- 50+ reviews

**Marketing Channels**:
- Product Hunt launch
- Post in r/meditation, r/mindfulness
- Email to beta testers
- Social media (Twitter, Instagram)

### Результат: App Store Package

**Deliverables**:
- APP_STORE_LISTING.md ✅
- VISUAL_ASSETS_SPEC.md ✅
- APP_STORE_CONNECT_GUIDE.md ✅
- LAUNCH_STRATEGY.md ✅

---

## Final Result

### 🎉 Factory Complete!

**Timeline**:
- Phase 1: 3 hours
- Phase 2: 5 hours
- Phase 3: 12 hours
- Phase 4: 6 hours
- Phase 5: 4 hours
- **Total**: ~30 hours (от идеи до готовности к App Store!)

**Deliverables**:
```
fabrika/projects/MindfulMoments/
├── backlog.md
├── design_system.md
├── MindfulMoments.xcodeproj
├── MindfulMoments/ (source code)
├── MindfulMomentsTests/
├── IMPLEMENTATION.md
├── MEMORY_AUDIT.md
├── ACCESSIBILITY_AUDIT.md
├── LIQUID_GLASS_AUDIT.md
├── PERFORMANCE_AUDIT.md
├── APP_STORE_LISTING.md
├── VISUAL_ASSETS_SPEC.md
├── APP_STORE_CONNECT_GUIDE.md
└── LAUNCH_STRATEGY.md
```

**Quality Metrics**:
- ✅ Swift 6 strict concurrency compliant
- ✅ 78% test coverage
- ✅ WCAG AA accessibility
- ✅ 0 memory leaks
- ✅ <1s launch time
- ✅ 60fps scrolling
- ✅ 0 compiler warnings

**Next Steps**:
1. Create app icon (1024x1024)
2. Create screenshots following spec
3. Upload to App Store Connect
4. Submit for review
5. Execute launch strategy

**Estimated Review Time**: 1-3 days

---

**От идеи до готовности к запуску за 30 часов! 🚀**
