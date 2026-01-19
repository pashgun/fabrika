# Master PRD: ZenCards 2.0 — "Anki Killer"

**Для кого:** Product-агент (PM/CTO).
**Цель:** Развернуть MVP приложения для iOS, которое сделает запоминание бесшовным и эстетичным.

## 1. Концепция и Философия

- **Context-First**: Каждая карточка должна быть привязана к источнику (цитата из книги, скриншот видео, URL статьи).
- **Zero-UI Friction**: Создание карты не должно прерывать поток обучения.
- **Privacy & Ownership**: Данные хранятся локально (SwiftData). Никаких обязательных подписок.

## 2. Ключевые Функции (Для Разработчика)

### Алгоритм FSRS (Free Spaced Repetition Scheduler)
Использовать современный стандарт вместо старого SM-2. Он точнее предсказывает вероятность забывания и сокращает количество ненужных повторений.

### Интерактивный Виджет (iOS 17/18+)
- Реализовать через App Intents
- Функции: Переворот карты тапом и оценка (Easy/Hard) прямо на главном экране

### AI Auto-Creation
- Интеграция с системным OCR для сканирования текста с фото
- Авто-генерация примера и озвучки (TTS) через API

### Multi-Sided Cards
Поддержка 3+ полей (например: Иероглиф — Чтение — Перевод)

## 3. Дизайн-система (Для Дизайнера)

**Стиль:** Liquid Glass (стеклянный морфизм с глубокими тенями) и Bento-сетка.

| Элемент | Референс / Идея |
|---------|-----------------|
| Режим обучения | Минимум кнопок. Управление жестами (свайп, лонг-пресс) |
| Виджеты | Динамические обложки колодок, индикатор "стрика" обучения |
| Анимация | Плавный "flip" карты и микро-отклик (haptic) при оценке |

## 4. Inspiration Board (Что и у кого копируем)

| Приложение | Что заимствуем | Ссылка |
|------------|----------------|--------|
| Mochi | Чистый интерфейс и поддержку Markdown | mochi.cards |
| NeuraCache | Идею создания карт из внешних заметок (Obsidian/Notion) | neuracache.com |
| Anki | Мощь алгоритма и возможность импорта колодок (.apkg) | apps.ankiweb.net |
| FlashRecall | Мобильную скорость создания карт из PDF и YouTube | flashrecall.app |
| RemNote | Вложенность знаний и иерархическую структуру | remnote.com |

## 5. Технические Требования

### Архитектура
- **SwiftData** для хранения карточек и прогресса
- **AppGroupSharedContainer** для обмена данными между основным приложением и виджетом
- **App Intents** для интерактивного виджета
- **TimelineProvider** для фонового обновления виджета

### Основные Entity
- **Card**: front, back, context (source URL/text), FSRS parameters, review history
- **Deck**: collection of cards, statistics, settings
- **ReviewSession**: tracking learning progress
- **FSRSScheduler**: implementation of FSRS algorithm

### Интеграции
- VisionKit для OCR
- AVFoundation для TTS
- WidgetKit для виджетов
- ShareExtension для быстрого добавления из других приложений

## 6. Фазы Разработки

### Phase 1: Core Learning Engine
- SwiftData модели (Card, Deck, ReviewSession)
- FSRS алгоритм реализация
- Базовый UI для создания и просмотра карточек
- Review flow с оценкой (Easy/Hard/Again)

### Phase 2: Context & Sources
- Привязка источников к карточкам
- ShareExtension для создания карточек из Safari/других приложений
- OCR integration для сканирования текста

### Phase 3: Widget & Notifications
- Интерактивный виджет через App Intents
- Daily review reminders
- Streak tracking

### Phase 4: AI Features (Optional для MVP)
- TTS для озвучки карточек
- Auto-generation examples

### Phase 5: Polish & Launch
- Liquid Glass дизайн refinement
- Performance optimization
- Accessibility (VoiceOver, Dynamic Type)
- App Store submission

## 7. Success Metrics

- **Retention D7**: >40% (пользователи возвращаются через неделю)
- **Cards Created per User**: >20 за первый день
- **Review Completion Rate**: >70% (пользователи завершают daily reviews)
- **App Store Rating**: >4.5⭐

## 8. Competitors Analysis Required

Agents should analyze:
- Mochi (https://mochi.cards)
- Anki Mobile (https://apps.apple.com/app/ankimobile-flashcards/id373493387)
- Quizlet (https://apps.apple.com/app/quizlet-flashcards/id546473125)
- RemNote (https://apps.apple.com/app/remnote/id1470303166)

## 9. Design Inspiration

- Liquid Glass materials
- Bento grid layouts
- Gesture-first interactions
- Minimal chrome
- Focus on content

## 10. Key Differentiators

1. **FSRS Algorithm** - More efficient than Anki's SM-2
2. **Context-First** - Every card linked to source
3. **Zero Friction** - Widget + gestures for quick reviews
4. **Privacy** - Local-first, no mandatory cloud sync
5. **Modern iOS** - Liquid Glass, widgets, haptics
