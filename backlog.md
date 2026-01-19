# Product Backlog: ZenCards 2.0

## Executive Summary

**ZenCards 2.0** — современное iOS-приложение для spaced repetition flashcards, созданное с использованием Swift 6 и Liquid Glass design. Мы решаем ключевые проблемы существующих решений: **устаревший UI** (Anki), **слабая статистика** (Mochi), и **отсутствие интерактивных виджетов** (все конкуренты). ZenCards использует современный алгоритм **FSRS** вместо устаревшего SM-2, предлагает **AI auto-creation** карточек через OCR, и поддерживает **интерактивный виджет** с App Intents.

## Open Source Foundation

> **Research-First Approach**: Максимально используем проверенные Open Source решения вместо написания кода с нуля.

### Components We're Using

#### 1. **FSRS Algorithm Implementation**
- **Source**: [open-spaced-repetition/swift-fsrs](https://github.com/open-spaced-repetition/swift-fsrs)
- **Version**: v5.0.0 (latest stable release)
- **License**: MIT
- **Usage**: Официальный Swift Package для FSRS spaced repetition scheduler
- **Rationale**:
  - Проверенная реализация FSRS v5 backed by academic literature
  - 76 GitHub stars, активная поддержка от Open Spaced Repetition org
  - Нет смысла реализовывать сложный алгоритм с нуля
- **Modifications**:
  - Обёртка для интеграции с нашими SwiftData models
  - Адаптация параметров для context-first learning

**Alternative Considered**:
- [4rays/swift-fsrs](https://github.com/4rays/swift-fsrs) — идиоматичная реализация с short-term/long-term schedulers
- [bootuz/SwiftFSRS](https://swiftpackageregistry.com/bootuz/SwiftFSRS) — FSRS-6 с type-safe API

**Why open-spaced-repetition/swift-fsrs**: Официальный package, наиболее актуальный и поддерживаемый.

#### 2. **SwiftData Models Reference**
- **Source**: [vaIerika/Flashcards](https://github.com/vaIerika/Flashcards) (SwiftUI flashcard app)
- **License**: Open Source (проверить при использовании)
- **Usage**: Reference для data model структуры (Card, Deck, Study Session)
- **Rationale**:
  - Современное SwiftUI/SwiftData приложение с gamification
  - Уже решённые проблемы persistence и relationships
- **Modifications**:
  - Добавим `context` field для AI-generated examples
  - Добавим `audioURL` для TTS pronunciation
  - FSRS scheduling metadata вместо простого Leitner system

#### 3. **Interactive Widget Pattern**
- **Source**:
  - [chockenberry/Intentional](https://github.com/chockenberry/Intentional) — complex interactive widget example
  - [pawello2222/WidgetExamples](https://github.com/pawello2222/WidgetExamples) — различные типы WidgetKit примеров
- **License**: Open Source (проверить)
- **Usage**: Reference для App Intents integration и widget interactivity
- **Rationale**:
  - Intentional показывает best practices для model sharing между app и widget
  - iOS 18 AppIntents integration patterns
- **Modifications**:
  - Flip animation для card reveal
  - Easy/Hard buttons через AppIntent actions
  - AppGroupSharedContainer для shared data

### Research Sources

#### Clone Wars
- **Checked**: [GorvGoyl/Clone-Wars](https://github.com/GorvGoyl/Clone-Wars) (100+ open-source clones)
- **Finding**: Нет прямого flashcard/Anki клона в списке
- **Action**: Мы создадим один из первых современных Anki-inspired clones с open source в Clone-Wars style

#### Axiom Skills Applied
Мы будем следовать battle-tested iOS patterns от [CharlesWiltgen/Axiom](https://github.com/CharlesWiltgen/Axiom):
- **axiom-liquid-glass** — современные iOS 26 materials для дифференциации от flat design конкурентов
- **axiom-swift-concurrency** — предотвращение data races в Swift 6 strict concurrency
- **axiom-swiftdata** — best practices для persistence и CloudKit sync
- **accessibility-debugging** — WCAG AA compliance (контраст, VoiceOver, Dynamic Type)

#### Reddit Insights (User Pain Points)

**From Anki Users** ([Anki Forums](https://forums.ankiweb.net/t/really-hate-where-anki-is-going-with-its-new-design/3651), [Hacker News](https://news.ycombinator.com/item?id=24957999)):
- 😡 **"The UI is ugly light grey... feels like it's from 2010"**
  - **→ Our Solution**: Liquid Glass design с iOS 26 modern materials
- 😡 **"Clunky, ugly, and kind of a part-time job"**
  - **→ Our Solution**: Context-first approach, AI auto-creation снижает manual work
- 😡 **"Slow card creation, manual management"**
  - **→ Our Solution**: OCR для быстрого создания, TTS для авто-pronunciation
- 😡 **"AnkiMobile hasn't been designed by a professional designer"**
  - **→ Our Solution**: Professional Liquid Glass design system

**From Mochi Users** ([First Impressions](https://borretti.me/article/first-impressions-mochi), App Reviews):
- 😡 **"Spartan stats page, very anemic compared to Anki"**
  - **→ Our Solution**: Rich statistics с FSRS insights (predicted retention, optimal intervals)
- 😡 **"No extension support or shared decks"**
  - **→ Won't Have в v1.0** (focus на core experience)
- 😡 **"Only two buttons (Forgot/Remembered) vs multiple options"**
  - **→ Our Solution**: Следуем FSRS best practice: Easy/Hard/Again (3 buttons достаточно)
- 😡 **"Android app is disappointing with import problems"**
  - **→ Out of Scope** (iOS-only для v1.0)
- ✅ **"Beautiful UI, beats Anki absolutely"**
  - **→ We'll match**: Liquid Glass ещё лучше
- ✅ **"Templates are game-changer for uniform structure"**
  - **→ Must Have**: Card templates feature

#### GitHub Topics Explored
- [github.com/topics/flashcards?l=swift](https://github.com/topics/flashcards?l=swift) — 20 Swift repos
- [github.com/topics/appintents](https://github.com/topics/appintents) — iOS 18 widget examples
- [github.com/topics/spaced-repetition?l=swift](https://github.com/topics/spaced-repetition?l=swift) — алгоритмы повторений

### What We're Building From Scratch

1. **AI Auto-Creation (OCR → Card)**
   - **Обоснование**: Unique differentiation, нет готового flashcard-specific OCR workflow
   - **Components**: Vision framework OCR → LLM для context/example → TTS для pronunciation

2. **Context-First Card Design**
   - **Обоснование**: Новый UX паттерн (front: context, back: word + definition + example)
   - **Why unique**: Все конкуренты используют traditional front/back format

3. **Liquid Glass Design System**
   - **Обоснование**: Нужен custom design для differentiation
   - **Framework**: axiom-liquid-glass skills + SwiftUI modern materials

## Market Analysis

### Competitive Landscape

#### 1. **Anki Mobile** (⭐ 4.5, $24.99, #1 в Education)
- **Strengths**:
  - Мощная desktop версия с extensions
  - Огромная база shared decks
  - Бесплатная на Android/desktop
- **Weaknesses**:
  - Устаревший UI ("feels like 2010")
  - Clunky UX, steep learning curve
  - SM-2 алгоритм (не современный FSRS)
  - Медленное создание карточек
- **Our Advantage**: Liquid Glass UI, FSRS, AI auto-creation, интерактивный виджет

#### 2. **Mochi** (⭐ 4.6, $5/month subscription, mochi.cards)
- **Strengths**:
  - Beautiful UI ("beats Anki absolutely")
  - Markdown support, note linking
  - Keyboard shortcuts emphasis
  - Templates для uniform structure
  - Недавно добавили FSRS (beta)
- **Weaknesses**:
  - Слабая статистика
  - Нет extension support
  - Только 2 кнопки (Forgot/Remembered)
  - Android app с проблемами
  - Нет interactive widget
- **Our Advantage**: Rich statistics, 3-button FSRS review, native iOS interactive widget, better mobile experience

#### 3. **Quizlet** (⭐ 4.8, Freemium, широкая аудитория)
- **Strengths**:
  - Огромная библиотека готовых карточек
  - Игровые режимы (Match, Gravity)
  - Social features, классы
- **Weaknesses**:
  - Не spaced repetition focused (больше cramming)
  - Heavy monetization (ads, premium features)
  - Не FSRS
- **Our Advantage**: True spaced repetition с FSRS, focus на long-term retention, не monetization-heavy

#### 4. **RemNote** (⭐ 4.6, Freemium, note-taking + flashcards)
- **Strengths**:
  - Integrated note-taking и flashcards
  - Spaced repetition built-in
- **Weaknesses**:
  - Сложный для новичков (knowledge graph overwhelming)
  - Не mobile-first
- **Our Advantage**: Простота, mobile-first design, focus только на flashcards

### Key Findings

**Opportunities:**
1. **Design Gap**: Anki имеет самую большую user base, но ужасный UI
2. **Algorithm Gap**: Большинство используют SM-2, не современный FSRS
3. **Mobile Gap**: Нет качественного mobile-first flashcard app с modern iOS features (widgets, Siri)
4. **AI Gap**: Никто не использует OCR + LLM для auto-creation карточек

**Market Position**:
- ZenCards = **"The Anki Killer"** — функциональность Anki + дизайн Mochi + AI auto-creation + modern iOS

## Target Audience

### Primary Persona: **Language Learner Lisa**
- **Age**: 22-35
- **Background**: Изучает иностранный язык (японский, корейский, европейские)
- **Tech Savvy**: Активный iOS user, любит красивые apps
- **Pain Points**:
  - Anki слишком ugly и clunky
  - Вручную создавать карточки долго
  - Хочет учиться "в моменте" (OCR текста из книг/сайтов)
- **Goals**:
  - Запоминать vocabulary эффективно
  - Минимум ручной работы (AI помощь)
  - Красивое приложение, которое приятно открывать

### Secondary Persona: **Student Sam**
- **Age**: 16-24
- **Background**: Школьник/студент, готовится к экзаменам
- **Tech Savvy**: iPhone native, любит shortcuts и widgets
- **Pain Points**:
  - Quizlet слишком много ads и distractions
  - Хочет real spaced repetition, не cramming
  - Нужен quick access (виджет для повторений на экране)
- **Goals**:
  - Long-term retention для экзаменов
  - Gamification (study streaks)
  - Быстрые reviews через виджет

### Болевые Точки (Общие)
1. **Ugly/Outdated UI** — большинство spaced repetition apps выглядят как desktop software портированное на mobile
2. **Manual Card Creation** — создание карточек вручную отнимает время
3. **No Mobile Optimization** — desktop-first apps плохо работают на iPhone
4. **Lack of Context** — traditional front/back format не даёт контекст использования слова

## Feature Breakdown

### MUST HAVE (Обязательные для MVP)

#### 1. **FSRS Spaced Repetition Algorithm**
- **Описание**: Используем современный FSRS вместо устаревшего SM-2 алгоритма
- **Ценность для пользователя**:
  - Более точные intervals → лучше retention
  - Адаптируется к индивидуальной памяти пользователя
  - Backed by academic research
- **Технические требования**:
  - Swift Package: `open-spaced-repetition/swift-fsrs` (v5.0.0)
  - SwiftData для хранения review history
  - Metadata: stability, difficulty, last_review, due_date
- **Примеры из конкурентов**:
  - Mochi недавно добавили FSRS (beta), но implementation закрытый
  - Anki использует SM-2 (1987 год)
- **Acceptance Criteria**:
  - [ ] FSRS package интегрирован
  - [ ] Review intervals рассчитываются корректно
  - [ ] Metadata сохраняется после каждого review
  - [ ] Unit tests для scheduling logic

#### 2. **Card Management (CRUD)**
- **Описание**: Создание, редактирование, удаление, организация flashcards
- **Ценность для пользователя**: Основа приложения — управление контентом
- **Технические требования**:
  - SwiftData Models:
    - `Card` (id, front, back, context, audioURL, createdAt, deckID)
    - `Deck` (id, name, color, icon, cards: [Card])
    - `ReviewRecord` (cardID, rating, reviewedAt, interval, stability)
  - SwiftUI CRUD экраны:
    - Card List (grouped by deck)
    - Card Detail/Edit
    - Deck Manager
- **Acceptance Criteria**:
  - [ ] Создать/редактировать/удалить карточки
  - [ ] Организовать в decks
  - [ ] Search/filter карточки
  - [ ] Drag-to-reorder в decks

#### 3. **Review Session (Study Mode)**
- **Описание**: Режим повторения карточек с FSRS scheduling
- **Ценность для пользователя**: Core experience — эффективное запоминание
- **Технические требования**:
  - SwiftUI Review View:
    - Flip animation (tap to reveal back)
    - 3 buttons: Again (forgot), Hard, Easy
    - Progress indicator (N cards due today)
  - FSRS Integration:
    - Fetch due cards (where due_date <= today)
    - Update scheduling после каждого review
    - Calculate next review date
- **UI Reference**:
  - Mochi's clean review interface (но с 3 кнопками вместо 2)
  - Flip animation reference: [WidgetExamples](https://github.com/pawello2222/WidgetExamples)
- **Acceptance Criteria**:
  - [ ] Due cards отображаются корректно
  - [ ] Flip animation плавная
  - [ ] FSRS scheduling работает после каждого rating
  - [ ] Показывается remaining cards count

#### 4. **Context-First Card Design** ⭐
- **Описание**: Новый UX паттерн для language learning
  - **Front**: Context sentence (пример использования слова)
  - **Back**: Word + Definition + Romanization (для CJK) + Audio pronunciation
- **Ценность для пользователя**:
  - Контекст помогает запоминать usage, не просто перевод
  - Решает проблему "I know the word but don't know how to use it"
- **Технические требования**:
  - Card Model fields:
    - `context: String` — example sentence
    - `word: String` — target word
    - `definition: String` — meaning
    - `pronunciation: String?` — romanization для японского/корейского/китайского
    - `audioURL: URL?` — TTS pronunciation
  - UI Design:
    - Context sentence на front (target word highlighted)
    - Full info на back
- **Дифференциация**: Все конкуренты используют simple front/back, мы — context-first
- **Acceptance Criteria**:
  - [ ] Context field в Card model
  - [ ] Context отображается на front
  - [ ] Target word highlighted в context
  - [ ] Back показывает word + definition + pronunciation + audio

#### 5. **AI Auto-Creation (OCR → Card)** ⭐
- **Описание**: Сфотографируй текст → AI создаёт карточку
  1. User фотографирует страницу книги/экран с текстом
  2. Vision framework OCR извлекает текст
  3. User выделяет слово/фразу → тапает "Create Card"
  4. LLM генерирует: context (example sentence), definition, pronunciation
  5. TTS генерирует audio pronunciation
  6. Card готова
- **Ценность для пользователя**:
  - **Убийца-фича**: создание карточек за 5 секунд вместо 2 минут manual work
  - "Learn in the moment" — увидел слово в книге → сразу создал карточку
- **Технические требования**:
  - Vision framework для OCR (VNRecognizeTextRequest)
  - LLM API:
    - **Option 1**: Apple Intelligence (on-device, iOS 18.1+) — бесплатно, приватно
    - **Option 2**: OpenAI API (fallback для iOS < 18.1) — платно, нужен API key
  - AVSpeechSynthesizer для TTS (системный, бесплатно)
  - Camera capture UI + text selection overlay
- **Competitors Don't Have This**: Unique differentiation
- **Acceptance Criteria**:
  - [ ] Camera capture с OCR работает
  - [ ] User может выделить слово/фразу в OCR тексте
  - [ ] LLM генерирует context + definition
  - [ ] TTS audio генерируется
  - [ ] Card создаётся автоматически в выбранный deck

#### 6. **Interactive Widget (iOS 17+)** ⭐
- **Описание**: Home Screen виджет для быстрых reviews
  - Показывает due card (front side)
  - Tap для flip → показывает back
  - Easy/Hard buttons через App Intents
  - Live progress bar (N cards due today)
- **Ценность для пользователя**:
  - Quick reviews без открытия app
  - Увеличивает engagement (виджет на Home Screen напоминает)
  - Решает проблему "I forget to review"
- **Технические требования**:
  - WidgetKit + App Intents
  - AppGroupSharedContainer для shared data между app и widget
  - Reference: [chockenberry/Intentional](https://github.com/chockenberry/Intentional)
  - Widget sizes: Small (1 card), Medium (1 card + stats), Large (multiple cards)
  - App Intents:
    - `FlipCardIntent` — flip card в виджете
    - `RateCardIntent(rating: Rating)` — Easy/Hard/Again
    - `RefreshWidgetIntent` — показать next due card
- **Competitors**: **Никто не имеет interactive review widget**
- **Acceptance Criteria**:
  - [ ] Widget отображает due card
  - [ ] Tap flip работает через AppIntent
  - [ ] Easy/Hard buttons обновляют FSRS и показывают next card
  - [ ] Widget updates автоматически
  - [ ] Timeline provider корректно работает

#### 7. **Liquid Glass Design** ⭐
- **Описание**: Применить iOS 26 Liquid Glass materials для modern look
  - Translucent backgrounds
  - Fluid animations
  - Depth через layering
  - Следуем Apple HIG + axiom-liquid-glass skill
- **Ценность для пользователя**:
  - **Решает главную жалобу на Anki**: "ugly UI from 2010"
  - Приятно использовать → higher engagement
- **Технические требования**:
  - SwiftUI `.glass()` materials
  - Color palette: не Anki's blues, не Mochi's purples
    - **Предложение**: Teals/Greens для "zen" theme (calming, focus)
  - Typography: SF Pro Rounded для softer look
  - Iconography: SF Symbols 6
  - Следуем axiom-liquid-glass principles
- **Дифференциация**: Anki flat и grey, Mochi modern но не Liquid Glass
- **Acceptance Criteria**:
  - [ ] Все экраны используют Liquid Glass materials
  - [ ] Color palette определена (teals/greens)
  - [ ] Animations fluid и не janky
  - [ ] Dark Mode поддерживается
  - [ ] Accessibility: min contrast 4.5:1 (WCAG AA)

### SHOULD HAVE (Желательные для v1.0)

#### 1. **Statistics Dashboard**
- **Описание**: Rich stats для tracking прогресса
  - Total cards reviewed (today/week/month/all-time)
  - Study streak (consecutive days)
  - Retention rate (% cards remembered)
  - FSRS insights: predicted retention, optimal intervals
  - Chart: reviews over time
- **Ценность**: Решает жалобу на Mochi "spartan stats page"
- **Technical**: SwiftUI Charts framework
- **Acceptance Criteria**:
  - [ ] Dashboard с основными metrics
  - [ ] Study streak tracking
  - [ ] Chart reviews over time

#### 2. **Card Templates**
- **Описание**: Predefined card templates для uniform structure
  - Language Learning (context-first)
  - Vocabulary (simple front/back)
  - Cloze Deletion (fill-in-the-blank)
- **Ценность**: Mochi users highlight "templates are game-changer"
- **Acceptance Criteria**:
  - [ ] 3 templates available
  - [ ] User выбирает template при создании карточки
  - [ ] Templates можно customise (advanced)

#### 3. **Search & Filter**
- **Описание**: Поиск карточек по тексту, фильтр по deck/tag/due date
- **Ценность**: Управление большой коллекцией (100+ cards)
- **Technical**: SwiftUI searchable(), SwiftData predicates
- **Acceptance Criteria**:
  - [ ] Search bar в Card List
  - [ ] Filter по deck
  - [ ] Filter по "due today" / "new" / "learned"

#### 4. **Daily Reminder Notifications**
- **Описание**: Push notification "You have 10 cards due today!"
- **Ценность**: Consistency → better retention
- **Technical**: UNUserNotificationCenter, scheduled local notifications
- **Acceptance Criteria**:
  - [ ] User выбирает reminder time в Settings
  - [ ] Notification показывает cards due count
  - [ ] Tap открывает Review Session

### COULD HAVE (Можно добавить позже)

#### 1. **CloudKit Sync**
- **Описание**: Синхронизация decks/cards между iPhone/iPad/Mac
- **Ценность**: Multi-device learning
- **Why Later**: Complexity, можно добавить в v1.1

#### 2. **Siri Integration**
- **Описание**: "Hey Siri, start my flashcard review"
- **Technical**: App Intents для Siri
- **Why Later**: Widget более критично для v1.0

#### 3. **Shared Decks / Community**
- **Описание**: Browse и download decks от других users
- **Why Later**: Требует backend, moderation — большой scope

#### 4. **Markdown Support**
- **Описание**: Rich text formatting в карточках
- **Why Later**: Context-first cards в v1.0 достаточно simple text

### WON'T HAVE (Не включаем в этот релиз)

#### 1. **Android Version**
- **Обоснование**: iOS-only для focused MVP
- **Future**: Если успешно, рассмотрим Android

#### 2. **Desktop App**
- **Обоснование**: Mobile-first approach
- **Future**: iPad support более вероятен чем full macOS app

#### 3. **Browser Extension**
- **Обоснование**: Как Anki's AnkiConnect — out of scope
- **Future**: Возможно v2.0

#### 4. **Extension/Plugin System**
- **Обоснование**: Mochi users хотят, но слишком complex для v1.0
- **Future**: Если community растёт

## User Stories

### Core Flow: Creating Cards

#### Story 1: AI Auto-Creation (Key Differentiator)
**Как** language learner, **я хочу** сфотографировать страницу из книги и создать карточку за 5 секунд, **чтобы** не тратить время на manual typing.

**Критерии приёмки**:
- [ ] Я могу открыть camera из app
- [ ] OCR извлекает текст из фото
- [ ] Я могу выделить слово/фразу в OCR тексте
- [ ] Тап "Create Card" запускает AI generation
- [ ] AI генерирует context, definition, pronunciation
- [ ] TTS audio добавляется автоматически
- [ ] Карточка создаётся и добавляется в выбранный deck
- [ ] Весь процесс занимает < 10 секунд

#### Story 2: Manual Card Creation
**Как** student, **я хочу** вручную создать карточку с custom content, **чтобы** иметь полный контроль над форматом.

**Критерии приёмки**:
- [ ] Я могу открыть "New Card" screen
- [ ] Я ввожу front (context или question)
- [ ] Я ввожу back (word + definition)
- [ ] Я выбираю deck
- [ ] Я опционально добавляю pronunciation text
- [ ] Я опционально добавляю TTS audio
- [ ] Карточка сохраняется в SwiftData

### Core Flow: Reviewing Cards

#### Story 3: Daily Review Session
**Как** language learner, **я хочу** повторить due cards с FSRS scheduling, **чтобы** запоминать vocabulary long-term.

**Критерии приёмки**:
- [ ] Я открываю Review Session
- [ ] Я вижу due cards count (например "10 cards due today")
- [ ] Front side показывает context (target word highlighted)
- [ ] Я тапаю → flip animation → back side показывает word + definition + audio
- [ ] Я слышу pronunciation (auto-play или tap speaker icon)
- [ ] Я оцениваю: Again (red), Hard (yellow), Easy (green)
- [ ] FSRS рассчитывает next review date
- [ ] Next card показывается автоматически
- [ ] Session завершается когда все due cards reviewed

#### Story 4: Widget Quick Review
**Как** busy student, **я хочу** повторять карточки прямо с Home Screen через виджет, **чтобы** делать quick reviews без открытия app.

**Критерии приёмки**:
- [ ] Виджет на Home Screen показывает due card (front)
- [ ] Я тапаю виджет → flip animation → показывается back
- [ ] Я тапаю Easy или Hard button
- [ ] Виджет обновляется и показывает next due card
- [ ] Progress bar обновляется (remaining cards count)
- [ ] Если due cards закончились, виджет показывает "All done! 🎉"

### Core Flow: Tracking Progress

#### Story 5: View Statistics
**Как** motivated learner, **я хочу** видеть мой прогресс (reviews count, streak, retention), **чтобы** stay motivated.

**Критерии приёмки**:
- [ ] Я открываю Statistics tab
- [ ] Я вижу: total cards reviewed today/week/month
- [ ] Я вижу: study streak (consecutive days)
- [ ] Я вижу: retention rate (%)
- [ ] Я вижу: chart с reviews over time
- [ ] Я вижу: FSRS insights (predicted retention)

### Edge Cases

#### Story 6: Handling Failed AI Generation
**Как** user, **я хочу** fallback option если AI не может сгенерировать карточку, **чтобы** не терять OCR текст.

**Критерии приёмки**:
- [ ] Если LLM API fail → показывается error alert
- [ ] OCR текст сохраняется в clipboard
- [ ] Я могу открыть Manual Card Creation и paste текст
- [ ] Или retry AI generation

## Technical Requirements

### Platform
- **Минимальная версия iOS**: 17.0
  - Обоснование: Interactive widgets требуют iOS 17+ (App Intents)
  - Trade-off: Исключаем iOS 16 users (~15% market), но critical для key feature
- **Поддерживаемые устройства**: iPhone (обязательно), iPad (nice-to-have для v1.1)
- **Ориентации**: Portrait (primary), Landscape (optional support)

### Data Persistence

#### SwiftData Models

```swift
@Model
class Card {
    @Attribute(.unique) var id: UUID
    var front: String  // Context sentence
    var back: String   // Word + definition
    var word: String   // Target word (for highlighting)
    var context: String  // Full context sentence
    var definition: String
    var pronunciation: String?  // Romanization
    var audioURL: URL?  // TTS audio file
    var createdAt: Date
    var deck: Deck?
    var reviewRecords: [ReviewRecord]

    // FSRS Metadata
    var stability: Double
    var difficulty: Double
    var lastReview: Date?
    var dueDate: Date
    var interval: Int  // days
}

@Model
class Deck {
    @Attribute(.unique) var id: UUID
    var name: String
    var color: String  // Hex color
    var icon: String   // SF Symbol name
    var cards: [Card]
    var createdAt: Date
}

@Model
class ReviewRecord {
    @Attribute(.unique) var id: UUID
    var card: Card
    var rating: Rating  // Again = 1, Hard = 2, Easy = 4
    var reviewedAt: Date
    var interval: Int
    var stability: Double
}

enum Rating: Int, Codable {
    case again = 1
    case hard = 2
    case easy = 4
}
```

#### CloudKit Sync
- **v1.0**: Local-only (SwiftData on device)
- **v1.1**: Add CloudKit sync для multi-device support

### APIs & Integrations

#### Apple Frameworks
- **SwiftUI** — UI framework
- **SwiftData** — data persistence (replacement Core Data)
- **WidgetKit** — home screen widgets
- **App Intents** — widget interactivity + Siri (future)
- **Vision** — OCR для photo text recognition (VNRecognizeTextRequest)
- **AVFoundation** — TTS pronunciation (AVSpeechSynthesizer)
- **PhotosUI** — camera capture (PhotosPicker)
- **Swift Charts** — statistics visualizations

#### External APIs
- **LLM для AI generation**:
  - **Primary**: Apple Intelligence (iOS 18.1+, on-device, free)
  - **Fallback**: OpenAI API (iOS < 18.1, requires API key from user)
  - Prompt: "Generate a flashcard: word: [word], context: [sentence], definition: [definition], pronunciation: [romanization if CJK]"

#### Third-party SDKs
- **FSRS**: `open-spaced-repetition/swift-fsrs` (v5.0.0)
  - SPM: `https://github.com/open-spaced-repetition/swift-fsrs`

### Modern Tech Stack (Our Advantage vs Competitors)

**ZenCards (2026)**:
- ✅ Swift 6 strict concurrency → thread-safety без crashes
- ✅ SwiftData → modern persistence (vs Anki's старый Core Data)
- ✅ Liquid Glass materials → contemporary iOS 26 UI
- ✅ @Observable → efficient state management (vs old ObservableObject)
- ✅ Actor-based architecture → правильный concurrency (axiom-swift-concurrency)
- ✅ FSRS algorithm → better retention than SM-2
- ✅ App Intents → native iOS integration (widgets, Siri future)

**Anki Mobile (legacy)**:
- ❌ Objective-C/старый Swift
- ❌ Core Data
- ❌ UIKit + outdated design
- ❌ SM-2 algorithm (1987)

**Mochi (modern but closed)**:
- ✅ Modern stack но proprietary
- ❌ No widget support
- ❌ Weak stats

### Permissions Required
- [x] **Camera** — для OCR photo capture
- [x] **Photos** — save OCR images (optional)
- [x] **Notifications** — daily reminders для review
- [ ] ~~HealthKit~~ — не нужен
- [ ] ~~Location~~ — не нужен

### Axiom Skills Integration

Следуем battle-tested patterns:

#### axiom-liquid-glass
- Liquid Glass materials для всех экранов
- Translucency, depth, fluid animations
- Avoid flat design (как Anki)

#### axiom-swift-concurrency
- Strict concurrency для Swift 6
- Actors для shared mutable state
- async/await для FSRS calculations, LLM API calls

#### axiom-swiftdata
- Best practices для SwiftData models
- Relationships: Card → Deck, Card → ReviewRecords
- Efficient queries для due cards

#### accessibility-debugging
- VoiceOver support для всех UI elements
- Dynamic Type для текста
- Minimum contrast 4.5:1 (WCAG AA)
- Reduce Motion support для animations

## Success Criteria

### Metrics (KPIs)

#### Launch Goals (First Month)
- **Downloads**: 1,000 users
- **DAU/MAU**: 40% (спaced repetition требует daily use)
- **App Store Rating**: 4.5⭐+
- **Review Completion Rate**: 70% (users complete daily reviews)

#### Retention
- **Day 1 Retention**: 70%
- **Day 7 Retention**: 40%
- **Day 30 Retention**: 25%
- **Benchmark**: Выше чем typical education app (20% D30)

#### Engagement
- **Average Session Length**: 3-5 minutes (quick reviews)
- **Sessions per Day**: 2-3 (morning, lunch, evening)
- **Cards per Session**: 10-20 cards
- **Widget Usage**: 30% of users use widget weekly

#### Qualitative
- **User Feedback**: "This is the Anki I always wanted"
- **Common Praise**: UI design, AI auto-creation, widget
- **NPS (Net Promoter Score)**: 50+ (excellent)

### Launch Goals
- [ ] Ship to TestFlight beta: 50-100 beta testers
- [ ] Get 20+ reviews with 4.5⭐ average
- [ ] Featured in "New Apps We Love" (reach out to Apple editorial)
- [ ] Post on Reddit r/languagelearning, r/Anki (community feedback)
- [ ] Submit to ProductHunt

## Risks & Assumptions

### Risks

#### 1. **LLM API Dependency**
- **Risk**: OpenAI API может быть дорого для frequent auto-creation
- **Вероятность**: Средняя
- **Влияние**: Высокое (core feature)
- **Mitigation**:
  - Primary: Use Apple Intelligence (free, on-device) для iOS 18.1+
  - Fallback: User provides own OpenAI API key
  - Limit: Max 10 AI generations per day для free tier (future monetization: unlimited AI as premium)

#### 2. **Widget Complexity**
- **Risk**: Interactive widgets могут быть buggy (iOS 18 новые issues)
- **Вероятность**: Средняя
- **Влияние**: Среднее (не блокирует core app)
- **Mitigation**:
  - Reference proven examples (Intentional repo)
  - Test на multiple iOS versions (17.0, 18.0, 18.1)
  - Fallback: Non-interactive widget если AppIntents fail

#### 3. **FSRS Complexity**
- **Risk**: Users могут не понимать FSRS intervals ("Why is this card due in 3 days?")
- **Вероятность**: Низкая (алгоритм proven)
- **Влияние**: Низкое
- **Mitigation**:
  - Onboarding explaining FSRS benefits
  - "Trust the algorithm" messaging
  - Advanced settings для tweaking (only for power users)

#### 4. **Market Saturation**
- **Risk**: Flashcard app market crowded (Anki, Mochi, Quizlet, RemNote)
- **Вероятность**: Высокая
- **Влияние**: Высокое
- **Mitigation**:
  - Clear differentiation: Liquid Glass UI + AI + Widget (никто не имеет все 3)
  - Target Anki's unhappy users (biggest market с worst UX)
  - Position as "Anki Killer" — bold marketing

### Assumptions

#### Technical Assumptions
- ✅ FSRS Swift package работает как expected (76⭐ repo, actively maintained)
- ✅ Vision OCR достаточно accurate для CJK languages (Japanese/Korean/Chinese)
- ✅ TTS quality достаточна для pronunciation (AVSpeechSynthesizer improvement в iOS 17+)
- ✅ App Intents stable в iOS 17+ (mature API)

#### Market Assumptions
- ✅ Существует demand для modern Anki alternative (Reddit complaints подтверждают)
- ✅ Users готовы платить за premium (Anki $25, Mochi $5/mo successful)
- ✅ Language learners — largest segment для flashcards (80%+ use case)
- ✅ Mobile-first подход правильный (smartphone usage > desktop для learning)

#### User Behavior Assumptions
- ✅ Users хотят AI help (не просто manual work)
- ✅ Context-first format будет полезен (hypothesis — нужно validate в beta)
- ✅ Widget увеличит engagement (data from других productivity apps)

## App Store Considerations

### Category
- **Primary Category**: Education → Languages
- **Secondary Category**: Education → Study Aids

### Monetization

**v1.0 Strategy: Freemium**

#### Free Tier
- Unlimited local decks/cards
- Unlimited reviews (FSRS scheduling)
- Basic AI auto-creation: 10 cards per day
- Widget access
- Local storage only (no sync)

#### Premium Tier: "ZenCards Pro" ($4.99/month or $39.99/year)
- Unlimited AI auto-creation
- CloudKit sync (multi-device)
- Advanced statistics (retention predictions)
- Premium card templates
- Early access to new features

**Why Freemium**:
- Low barrier для trial (vs Anki's $25 upfront)
- Competitive с Mochi ($5/mo)
- AI cost covered by subscriptions
- Free tier достаточен для casual users

**Alternative Considered**:
- One-time purchase $9.99 — проще, но less sustainable для AI API costs
- Completely free — не sustainable (нужно покрывать LLM costs)

### Privacy & Compliance

#### Data Collection
- **Local Data**:
  - Flashcards content (text, audio files)
  - Review history (timestamps, ratings)
  - FSRS metadata (stability, difficulty)
- **Not Collected**:
  - No analytics tracking (privacy-first)
  - No email/account required (local-first app)
- **Cloud Sync (Premium)**:
  - CloudKit (Apple-hosted, end-to-end encrypted)
  - User owns data

#### Privacy Policy
- **Required**: Yes (App Store requirement)
- **Content**:
  - Disclose camera usage для OCR
  - Disclose LLM API usage (OpenAI fallback sends text to external server)
  - Emphasize: data stays on device unless user enables CloudKit sync

#### Age Rating
- **Age Rating**: **4+** (Education, no objectionable content)
- **Justification**:
  - No violence, mature themes, gambling
  - User-generated content (карточки) но no social features
  - Follows Apple Family Sharing guidelines

### App Store Optimization (ASO)

#### App Name
- **Primary**: "ZenCards: Smart Flashcards"
- **Subtitle**: "AI-Powered Spaced Repetition"

#### Keywords
Primary: flashcards, anki, spaced repetition, study, learning, memorize, vocabulary, language learning, FSRS

#### Screenshots Focus
1. **Hero**: Beautiful Liquid Glass UI (vs Anki's ugly grey)
2. **AI Auto-Creation**: "Create cards in 5 seconds" — show OCR → AI flow
3. **Interactive Widget**: "Review from your Home Screen"
4. **Statistics**: Rich dashboard (vs Mochi's "spartan stats")
5. **Context-First Cards**: Show context learning advantage

#### App Preview Video (30s)
1. Open app → gorgeous Liquid Glass UI
2. Tap camera → OCR text → AI generates card → done in 5s
3. Review session: flip animation, FSRE scheduling
4. Widget demo: quick review on Home Screen
5. Stats dashboard: streaks, retention
6. End: "The Anki You Always Wanted"

---

## Summary: Why ZenCards Will Win

### The Perfect Storm
1. **Anki** has 80% market share but **ugly UI** — we steal their users with Liquid Glass
2. **Mochi** has beautiful UI but **weak stats & no widget** — we offer better features
3. **Nobody** has **AI auto-creation** — we're first to market with OCR → Card flow
4. **Nobody** has **interactive review widget** — unique iOS-native advantage

### Our Advantages (Summarized)
✅ **Design**: Liquid Glass (iOS 26) vs Anki's 2010 UI
✅ **Algorithm**: FSRS (2024) vs Anki's SM-2 (1987)
✅ **AI**: Auto-creation с OCR + LLM (unique)
✅ **Mobile**: Widget + App Intents (iOS-native, competitors don't have)
✅ **UX**: Context-first cards (better than traditional front/back)
✅ **Stats**: Rich dashboard (better than Mochi's "spartan" stats)
✅ **Open Source Foundation**: Built on proven packages (swift-fsrs, Intentional patterns)

### Target Launch
**Q1 2026** — TestFlight beta → App Store submission

---

**Next Phase**: UI Engineer создаёт Design System с Liquid Glass 🎨
