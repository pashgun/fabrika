# Fabrika - Руководство по Использованию

Полная инструкция по работе с Mobile App Factory.

## Содержание

1. [Установка](#установка)
2. [Быстрый Старт](#быстрый-старт)
3. [Клонирование Приложений](#клонирование-приложений)
4. [Режимы Работы](#режимы-работы)
5. [Агенты](#агенты)
6. [5-Фазный Workflow](#5-фазный-workflow)
7. [6-Фазный Workflow (Клонирование)](#6-фазный-workflow-клонирование)
8. [Примеры](#примеры)
9. [Troubleshooting](#troubleshooting)

---

## Установка

### Prerequisites

**1. Claude Code CLI**
```bash
# Установите Claude Code
# Инструкции: https://claude.ai/code

# Проверьте установку
claude --version
```

**2. Axiom Skills**
```bash
# Запустите Claude Code
claude code

# В интерфейсе Claude Code:
/plugin marketplace add CharlesWiltgen/Axiom

# Проверьте установку
/help
# Должны увидеть Axiom skills в списке
```

**3. Xcode 15.0+**
```bash
# Проверьте версию
xcodebuild -version
# Должно быть: Xcode 15.0 или выше
```

**4. Git**
```bash
git --version
```

### Установка Fabrika

```bash
# Clone репозиторий
git clone <repository-url>
cd fabrika

# Сделайте factory.sh исполняемым
chmod +x factory.sh

# Проверьте что всё работает
./factory.sh help
```

---

## Быстрый Старт

### Создать первое приложение

```bash
# 1. Запустите фабрику с идеей
./factory.sh start "Создай meditation app с guided sessions и progress tracking"

# 2. Следуйте инструкциям (5 фаз)
# После каждой фазы просматривайте результаты и продолжайте

# 3. В конце получите готовое приложение! 🎉
```

**Результат:**
- `backlog.md` - Требования и user stories
- `design_system.md` - Дизайн-система
- `ProjectName.xcodeproj` - Xcode проект
- Test suite + audit reports
- App Store submission package

---

## Клонирование Приложений

Fabrika может анализировать существующие приложения из App Store и создавать их современные клоны с улучшенным дизайном.

### Быстрый старт с клонированием

```bash
# 1. Запустите клонирование с URL приложения
./factory.sh clone "https://apps.apple.com/us/app/calm/id571800810"

# 2. Следуйте инструкциям (6 фаз)
# Phase 0: Анализ оригинального приложения
# Phase 1-5: Обычный workflow с учётом анализа

# 3. В конце получите современный клон! 🎉
```

### Что происходит при клонировании?

**Phase 0: App Analysis**
- 🔍 Анализируется App Store listing
- 🔍 Собираются отзывы пользователей
- 🔍 Изучаются видео-обзоры на YouTube
- 🔍 Анализируются статьи и Reddit обсуждения
- 📝 Создаётся детальный `app_analysis.md`

**Phase 1: Research (с app_analysis.md)**
- pm_lead использует анализ вместо самостоятельного исследования
- Структурирует features в MoSCoW приоритеты
- Добавляет улучшения на основе жалоб пользователей
- Создаёт `backlog.md` для клона

**Phase 2: Design (современный iOS дизайн)**
- ui_engineer создаёт **визуально отличающийся** дизайн
- Применяет Liquid Glass материалы
- Использует современную цветовую палитру (не как у оригинала)
- SF Symbols 6, минималистичная эстетика
- Создаёт `design_system.md` с дифференциацией

**Phase 3-5: Build, Audit, Delivery**
- Стандартный workflow с современным кодом (Swift 6)

### Функциональность vs Дизайн

**✅ Клонируем (Функционально):**
- Все ключевые features оригинала
- Навигационную структуру (если она хороша)
- User flows и логику
- Core value proposition

**🎨 Дифференцируем (Визуально):**
- Цветовая схема (современные тренды 2026)
- Liquid Glass материалы (вместо flat backgrounds)
- Типографика (SF Pro с иерархией)
- Иконки (SF Symbols 6)
- Spacing и layout (больше white space)
- Анимации (iOS 26 APIs)

**✨ Улучшаем (UX):**
- Исправляем жалобы из reviews
- Добавляем запрошенные features
- Убираем UX friction
- Современные iOS patterns

### Пример: Клон Calm

```bash
./factory.sh clone "https://apps.apple.com/us/app/calm/id571800810" --local
```

**Что вы получите:**

**1. app_analysis.md** (~5000 строк)
```markdown
# App Analysis: Calm

## Feature Inventory
- Core Features: Meditation sessions, Sleep stories, Breathing exercises...
- Secondary Features: Progress tracking, Daily reminders...
- Premium Features: Masterclasses, Music tracks...

## UI Patterns Observed
- Navigation: Bottom Tab Bar (4 tabs)
- Design Style: Deep blue (#1E3A8A), gradients, nature photos
- Components: Card-based layout, hero images...

## User Feedback
- Top Praise: Great content library, helps with sleep
- Top Complaints: Too expensive ($69.99/year), limited free content...

## Differentiation Strategy
- Color: Use Soft Lavender + Warm Peach (not blue)
- Materials: Apply Liquid Glass (Calm uses flat)
- Features: Add free trial period, more free content
```

**2. backlog.md** (на основе анализа)
```markdown
# Product Backlog: ZenFlow (Inspired by Calm)

## MUST HAVE
1. Guided Meditation Sessions (like Calm, but with categories)
2. Sleep Stories with audio (improve on Calm's limited free stories)
3. Breathing Exercises (add more techniques than Calm)
4. Progress Tracking (better visualization than Calm)

## Design Philosophy
Modern iOS 26 aesthetic, differentiates from Calm's older flat design
```

**3. design_system.md** (современный дизайн)
```markdown
# Design System: ZenFlow

## Comparison with Original (Calm)

| Aspect       | Calm                          | ZenFlow (Our Design)         |
|--------------|-------------------------------|------------------------------|
| Primary Color| Deep Blue (#1E3A8A)          | Soft Lavender (#B4A7D6)      |
| Materials    | Flat solid backgrounds        | Liquid Glass (.ultraThinMaterial) |
| Navigation   | Bottom Tab Bar                | Floating Tab Bar with blur   |
| Typography   | Custom serif headings         | SF Pro with Dynamic Type     |

## Color System
Primary: Soft Lavender - calming but contemporary
Accent: Warm Peach - for CTAs
Background: Dynamic gradient (white → deep purple in dark mode)
```

**4-6. Обычные фазы**
- Xcode проект с Swift 6 + SwiftData
- Tests + audits
- App Store package

### Только анализ (без разработки)

Если нужен только анализ приложения без создания клона:

```bash
./factory.sh app_analyzer --url "https://apps.apple.com/app/headspace/id493145008"
```

**Результат:**
- `app_analysis.md` создан
- Можно изучить features, UI, отзывы
- Потом запустить `./factory.sh pm_lead` чтобы продолжить

### Когда использовать клонирование?

**✅ Хорошие сценарии:**
- Обучение (понять как устроено популярное приложение)
- Создание конкурента (с улучшениями)
- Создание нишевой версии (например, "Calm для детей")
- Портирование концепции в другую область

**⚠️ Важно:**
- Не копируйте контент (тексты, audio, изображения)
- Не используйте имя оригинала
- Не копируйте иконку или брендинг
- Фокус на функциональности, а не на пиксель-идеальном копировании

---

## Режимы Работы

Fabrika поддерживает 3 режима создания проектов:

### 1. Локальные Проекты (--local)

**Когда использовать:** Прототипирование, обучение, несколько мелких проектов

**Преимущества:**
- ✅ Все проекты в одном месте
- ✅ Общий git репозиторий
- ✅ Легко переключаться между проектами

**Недостатки:**
- ❌ Все проекты в одном git repo
- ❌ Не подходит для production

**Пример:**
```bash
./factory.sh start "Todo app" --local

# Создаст структуру:
fabrika/
├── projects/
│   └── TodoApp/
│       ├── backlog.md
│       ├── design_system.md
│       └── TodoApp.xcodeproj
```

### 2. Отдельный Репозиторий (--repo <path>)

**Когда использовать:** Production приложения, open source проекты

**Преимущества:**
- ✅ Независимый git репозиторий
- ✅ Можно публиковать на GitHub
- ✅ Чистая структура проекта

**Недостатки:**
- ❌ Нужно создавать директорию вручную

**Пример:**
```bash
./factory.sh start "Fitness tracker" --repo /home/user/FitnessApp

# Создаст структуру:
/home/user/FitnessApp/
├── .git/
├── .gitignore
├── backlog.md
├── design_system.md
└── FitnessApp.xcodeproj

# Автоматически инициализирует git и создаст .gitignore для iOS
```

### 3. Существующий Проект (--existing)

**Когда использовать:** Добавление функций, рефакторинг, улучшения

**Преимущества:**
- ✅ Работает с текущим проектом
- ✅ Не создаёт новые директории
- ✅ Можно запускать отдельные фазы

**Недостатки:**
- ❌ Может конфликтовать с существующим кодом

**Пример:**
```bash
# Перейдите в существующий проект
cd /path/to/ExistingApp

# Запустите агента
/path/to/fabrika/factory.sh swift_dev --existing

# Или полный pipeline
/path/to/fabrika/factory.sh start "Add dark mode support" --existing
```

---

## Агенты

### app_analyzer - App Store Intelligence Analyst

**Что делает:**
- Анализирует существующие приложения из App Store
- Изучает App Store листинг (screenshots, reviews, description)
- Собирает и анализирует видео-обзоры (YouTube)
- Читает статьи, посты, Reddit обсуждения
- Создаёт детальный отчёт о features, UI/UX, отзывах

**Вход:** App Store URL

**Выход:** `app_analysis.md` с comprehensive анализом

**Пример вызова:**
```bash
./factory.sh app_analyzer --url "https://apps.apple.com/us/app/calm/id571800810"
```

**Что будет в app_analysis.md:**
- App Store Information (title, rating, category, price)
- Feature Inventory (Core/Secondary/Premium features)
- UI/UX Patterns Observed (navigation, screens, design style, colors)
- User Feedback Analysis (top praise, top complaints, feature requests)
- Insights from Video Reviews & Tutorials
- Insights from Articles & Posts
- Technical Requirements (inferred data models, APIs, frameworks)
- Competitive Context
- Differentiation Strategy for Clone

**Когда использовать:**
- Хотите создать клон существующего приложения
- Нужен competitive analysis конкретного приложения
- Планируете улучшить существующее приложение
- Изучаете best practices популярных apps

---

### pm_lead - Product Marketing Manager

**Что делает:**
- Анализирует конкурентов в App Store
- Создаёт детальные требования
- Приоритизирует функции (MoSCoW: Must/Should/Could/Won't)
- Пишет user stories с критериями приёмки

**Вход:** Идея приложения или название конкурента

**Выход:** `backlog.md` со структурированными требованиями

**Пример вызова:**
```bash
./factory.sh pm_lead --input "Clone of Duolingo for learning Spanish"
```

**Что будет в backlog.md:**
- Executive Summary
- Конкурентный анализ (3-5 приложений)
- Feature breakdown (Must/Should/Could/Won't)
- User stories с acceptance criteria
- Технические требования (SwiftData модели, API, SDK)
- Success criteria

---

### ui_engineer - SwiftUI Designer

**Что делает:**
- Создаёт дизайн-систему (цвета, typography, spacing)
- Проектирует SwiftUI компоненты
- Применяет Liquid Glass материалы
- Обеспечивает HIG соответствие
- Планирует accessibility

**Вход:** `backlog.md`

**Выход:** `design_system.md` с компонентами

**Axiom Skills:** axiom-liquid-glass, axiom-swiftui-26-ref, accessibility-debugging

**Пример вызова:**
```bash
./factory.sh ui_engineer
```

**Что будет в design_system.md:**
- Color System (light & dark mode)
- Typography Scale
- Spacing & Layout Grid
- Liquid Glass Material Hierarchy
- Component Library (Buttons, Cards, TextFields, etc.)
- Navigation Patterns
- Animations
- Accessibility Requirements
- Screen Specifications

---

### swift_dev - Swift Developer

**Что делает:**
- Создаёт Xcode проект
- Реализует дизайн-систему и компоненты
- Пишет SwiftData модели
- Интегрирует SDK (HealthKit, MapKit, etc.)
- Использует Swift 6 concurrency (async/await, actors)

**Вход:** `design_system.md`, `backlog.md`

**Выход:** Полный Xcode проект

**Axiom Skills:** axiom-swift-concurrency, axiom-swiftdata, axiom-swiftui-performance, axiom-liquid-glass, axiom-app-intents-ref

**Пример вызова:**
```bash
./factory.sh swift_dev
```

**Что будет создано:**
- Xcode проект с правильной структурой
- DesignSystem.swift (константы)
- SwiftUI Views и ViewModels
- SwiftData Models
- Service Layer (NetworkService, DataService)
- App Intents (Siri/Shortcuts)
- IMPLEMENTATION.md (документация)

---

### qa_audit - QA Engineer

**Что делает:**
- Пишет Unit и UI тесты
- Запускает memory leak detection
- Проверяет accessibility compliance
- Профилирует performance
- Исправляет критические баги

**Вход:** Xcode проект

**Выход:** Production-ready build + test suite + audit reports

**Axiom Skills:** axiom-memory-debugging, accessibility-debugging, axiom-liquid-glass, axiom-ui-testing

**Commands:**
```bash
/prescan-memory          # Memory leak detection
/audit-accessibility     # WCAG AA compliance
/audit-liquid-glass      # Material usage validation
```

**Пример вызова:**
```bash
./factory.sh qa_audit
```

**Что будет создано:**
- Unit tests (>70% coverage)
- UI tests для critical flows
- MEMORY_AUDIT.md
- ACCESSIBILITY_AUDIT.md
- LIQUID_GLASS_AUDIT.md
- PERFORMANCE_AUDIT.md
- BUGS_FIXED.md

**Quality Gates:**
- ✅ No memory leaks
- ✅ >70% test coverage
- ✅ WCAG AA compliance
- ✅ <2s launch time
- ✅ 60fps scrolling

---

### aso_expert - ASO Specialist

**Что делает:**
- Оптимизирует App Store metadata
- Создаёт compelling описание
- Подбирает keywords
- Специфицирует screenshots и icon
- Готовит App Store Connect guide

**Вход:** Production build, `backlog.md`, quality metrics

**Выход:** App Store submission package

**Пример вызова:**
```bash
./factory.sh aso_expert
```

**Что будет создано:**
- APP_STORE_LISTING.md (metadata)
- VISUAL_ASSETS_SPEC.md (screenshots, icon)
- APP_STORE_CONNECT_GUIDE.md (submission steps)
- LAUNCH_STRATEGY.md (marketing plan)

---

## 5-Фазный Workflow

### Phase 1: Research (2-4 часа)

**Агент:** pm_lead

**Задачи:**
1. Поиск конкурентов в App Store
2. Анализ top 3-5 похожих приложений
3. Изучение отзывов пользователей
4. Определение feature set (Must/Should/Could/Won't)
5. Создание user personas
6. Документирование технических требований

**Выход:**
- `backlog.md` - Полный набор требований

**Handoff:** Design requirements готовы для ui_engineer

**Команда:**
```bash
./factory.sh pm_lead --input "Your app idea"
```

---

### Phase 2: Design (4-6 часов)

**Агент:** ui_engineer

**Задачи:**
1. Определение color palette (semantic colors)
2. Создание typography scale
3. Проектирование component library
4. Планирование Liquid Glass материалов
5. Спецификация navigation patterns
6. Проектирование для accessibility
7. Создание SwiftUI component specs

**Выход:**
- `design_system.md` - Полная дизайн-система

**Handoff:** Design system готова для implementation

**Команда:**
```bash
./factory.sh ui_engineer
```

---

### Phase 3: Build (8-16 часов)

**Агент:** swift_dev

**Задачи:**
1. Создание Xcode проекта
2. Реализация design system компонентов
3. Построение SwiftUI views
4. Создание SwiftData моделей
5. Реализация business logic
6. Интеграция SDK
7. Добавление App Intents
8. Реализация async/await паттернов
9. Начальное тестирование

**Выход:**
- Полный Xcode проект
- IMPLEMENTATION.md

**Handoff:** Buildable app готов к тестированию

**Команда:**
```bash
./factory.sh swift_dev
```

---

### Phase 4: Hard Audit (4-8 часов)

**Агент:** qa_audit

**Задачи:**
1. Запуск `/prescan-memory`
2. Исправление memory leaks и retain cycles
3. Запуск `/audit-accessibility`
4. Исправление accessibility violations
5. Запуск `/audit-liquid-glass`
6. Оптимизация material performance
7. Написание unit tests (>70% coverage)
8. Написание UI tests для critical paths
9. Профилирование с Instruments
10. Исправление всех critical bugs
11. Тестирование на нескольких устройствах
12. Валидация Dark Mode

**Выход:**
- Production-ready build
- Test suite
- Audit reports

**Quality Gates:**
- All audits passing
- No memory leaks
- Test coverage >70%
- No critical bugs

**Handoff:** Production build approved

**Команда:**
```bash
./factory.sh qa_audit
```

---

### Phase 5: Delivery (3-5 часов)

**Агент:** aso_expert

**Задачи:**
1. Research competitor keywords
2. Написание app name и subtitle
3. Оптимизация keyword list
4. Написание app description
5. Проектирование screenshot layouts
6. Спецификация app icon
7. Конфигурация App Store Connect
8. Подготовка App Review notes
9. Создание TestFlight плана
10. Документирование launch strategy

**Выход:**
- App Store metadata
- Visual asset specifications
- Submission checklist
- Launch plan

**Final State:** READY FOR SUBMISSION

**Команда:**
```bash
./factory.sh aso_expert
```

---

## 6-Фазный Workflow (Клонирование)

Когда вы запускаете `./factory.sh clone <url>`, система проходит 6 фаз вместо 5.

### Phase 0: App Analysis (1-2 часа)

**Агент:** app_analyzer

**Задачи:**
1. Анализ App Store листинга (screenshots, reviews, description)
2. Поиск и анализ YouTube видео-обзоров
3. Поиск и чтение статей о приложении
4. Анализ Reddit обсуждений и форумов
5. Извлечение feature list из всех источников
6. Анализ UI/UX patterns из screenshots
7. Анализ user sentiment (praise vs complaints)
8. Идентификация технических требований
9. Поиск конкурентов и сравнение
10. Создание differentiation strategy

**Выход:**
- `app_analysis.md` - Comprehensive анализ (~5000 строк)

**Handoff:** app_analysis.md готов для pm_lead

**Команда:**
```bash
./factory.sh app_analyzer --url "https://apps.apple.com/us/app/calm/id571800810"
```

**Что содержит app_analysis.md:**
```markdown
# App Analysis: Calm

## App Store Information
- Title: Calm: Sleep & Meditation
- Rating: 4.8⭐ (500,000+ ratings)
- Category: Health & Fitness
- Price: Free (IAP: $69.99/year)

## Feature Inventory
### Core Features (Must Have)
1. Guided Meditation Sessions
   - Evidence: Seen in screenshots 1,2,3; mentioned in 90% of reviews
   - User Value: "Helps me relax after work" (top praise)
   - Frequency: Daily usage reported

2. Sleep Stories
   - Evidence: Featured in YouTube reviews, 50+ mentions
   - User Value: "Finally can fall asleep" (2nd most praised)

### Top Complaints
1. "Too expensive" (~30% of negative reviews)
   - Opportunity: Offer lower-tier subscription
2. "Limited free content" (~25% of negative reviews)
   - Opportunity: More generous free tier

## Differentiation Strategy
- Color: Use Soft Lavender + Warm Peach (not Calm's deep blue)
- Materials: Apply Liquid Glass (Calm uses flat backgrounds)
- Features: More free content, lower pricing tier
```

---

### Phase 1: Research with Analysis (1 час)

**Агент:** pm_lead (в режиме клонирования)

**Отличия от обычного workflow:**
- ✅ **НЕ нужно** искать конкурентов (уже в app_analysis.md)
- ✅ **НЕ нужно** анализировать features (уже задокументированы)
- ✅ **НЕ нужно** собирать отзывы (уже собраны)

**Задачи:**
1. Прочитать app_analysis.md
2. Структурировать features в MoSCoW приоритеты
3. Создать user stories с acceptance criteria
4. Добавить улучшения на основе complaints
5. Определить technical stack (Swift 6, SwiftData, etc.)
6. Задокументировать differentiation approach

**Выход:**
- `backlog.md` - на основе app_analysis.md

**Handoff:** Requirements готовы, с фокусом на дифференциацию

**Команда:**
```bash
# Вызывается автоматически после Phase 0
./factory.sh pm_lead
```

**Пример backlog.md:**
```markdown
# Product Backlog: ZenFlow (Inspired by Calm)

## Executive Summary
Modern iOS meditation app inspired by Calm, but with:
- Liquid Glass design (Calm uses flat)
- More generous free tier (address #1 complaint)
- Lower pricing option (address #2 complaint)

## Feature Breakdown
### MUST HAVE
1. Guided Meditation Sessions
   - Description: From app_analysis.md - core feature
   - Differentiation: Better categorization than Calm
   - Technical: SwiftData models for sessions, AVAudioPlayer
```

---

### Phase 2: Design with Differentiation (3-4 часа)

**Агент:** ui_engineer (в режиме клонирования)

**Отличия от обычного workflow:**
- ✅ Читает app_analysis.md секцию "UI Patterns Observed"
- ✅ Понимает оригинальный дизайн
- ✅ **Обязательно дифференцируется** визуально

**Задачи:**
1. Прочитать "UI Patterns Observed" из app_analysis.md
2. Определить навигационную структуру (может быть похожей)
3. Выбрать **другую** цветовую палитру (не как у оригинала)
4. Применить Liquid Glass материалы
5. Использовать SF Symbols 6 (не копировать иконки оригинала)
6. Создать minimalist, современный дизайн
7. Добавить UI улучшения на основе complaints

**Выход:**
- `design_system.md` с секцией "Comparison with Original"

**Handoff:** Modern design differentiated от оригинала

**Команда:**
```bash
# Вызывается автоматически после Phase 1
./factory.sh ui_engineer
```

**Пример design_system.md:**
```markdown
# Design System: ZenFlow

## Comparison with Original (Calm)

| Aspect       | Calm                    | ZenFlow                 |
|--------------|-------------------------|-------------------------|
| Primary Color| Deep Blue (#1E3A8A)    | Soft Lavender (#B4A7D6) |
| Materials    | Flat solid backgrounds  | Liquid Glass (.ultraThinMaterial) |
| Typography   | Custom serif            | SF Pro Dynamic Type     |

## Rationale
- Lavender: Calming (like blue) but contemporary (2026 trend)
- Liquid Glass: Modern iOS 26 aesthetic, Calm feels dated
- SF Pro: Native, excellent accessibility support
```

---

### Phase 3-5: Build, Audit, Delivery

Эти фазы идентичны обычному workflow. Различие только в том, что:
- Build реализует **дифференцированный** дизайн
- Features соответствуют **оригиналу** функционально
- Code использует **современный** Swift 6 stack

---

### Полный Timeline для Клонирования

| Phase | Duration | Agent | Output |
|-------|----------|-------|--------|
| 0     | 1-2 часа | app_analyzer | app_analysis.md |
| 1     | 1 час    | pm_lead | backlog.md |
| 2     | 3-4 часа | ui_engineer | design_system.md |
| 3     | 8-16 часов | swift_dev | Xcode Project |
| 4     | 4-8 часов | qa_audit | Production Build |
| 5     | 3-5 часов | aso_expert | App Store Package |
| **Total** | **20-36 часов** | **6 agents** | **Ready to Ship** |

---

## Примеры

### Пример 1: Meditation App (Локальный)

```bash
# Запуск
./factory.sh start "Create a meditation app with guided sessions, timers, and progress tracking" --local

# Phase 1: pm_lead
# ✓ Анализирует Calm, Headspace, Insight Timer
# ✓ Создаёт backlog.md с 15 user stories

# Phase 2: ui_engineer
# ✓ Создаёт успокаивающую color palette (blues, purples)
# ✓ Проектирует Liquid Glass cards для sessions
# ✓ Создаёт дизайн-систему

# Phase 3: swift_dev
# ✓ Реализует SwiftData модели: User, Session, Progress
# ✓ Создаёт timer с background support
# ✓ Интегрирует App Intents для Siri ("Start meditation")

# Phase 4: qa_audit
# ✓ Пишет tests (75% coverage)
# ✓ Проверяет accessibility (WCAG AA ✅)
# ✓ Профилирует (1.1s launch time ✅)

# Phase 5: aso_expert
# ✓ Keywords: meditation,mindfulness,calm,stress,anxiety
# ✓ Создаёт screenshots с peaceful imagery
# ✓ Пишет description focusing on benefits

# Результат:
fabrika/projects/MeditationApp/
├── backlog.md
├── design_system.md
├── MeditationApp.xcodeproj
├── MeditationApp/
│   ├── Models/ (SwiftData)
│   ├── Views/ (SwiftUI)
│   ├── Services/
│   └── Resources/
├── Tests/
├── MEMORY_AUDIT.md
├── ACCESSIBILITY_AUDIT.md
└── APP_STORE_LISTING.md
```

---

### Пример 2: Fitness Tracker (Отдельный Repo)

```bash
# Запуск
./factory.sh start "Fitness tracking app with workout logging, nutrition tracking, and HealthKit integration" --repo ~/FitnessTracker

# Phase 1: pm_lead
# ✓ Анализирует MyFitnessPal, Strong, Fitbod
# ✓ Определяет Must Have: workout logging, nutrition, HealthKit
# ✓ Создаёт backlog с HealthKit permissions

# Phase 2: ui_engineer
# ✓ Энергичная color palette (oranges, reds)
# ✓ Charts для визуализации прогресса
# ✓ Designing workout cards

# Phase 3: swift_dev
# ✓ HealthKit integration (workouts, nutrition, heart rate)
# ✓ SwiftData: Workout, Exercise, Meal, User
# ✓ Charts framework для графиков
# ✓ CloudKit sync

# Phase 4: qa_audit
# ✓ Tests включая HealthKit mocking
# ✓ Performance testing (списки 1000+ workouts)
# ✓ Accessibility для charts

# Phase 5: aso_expert
# ✓ Highlights HealthKit integration
# ✓ Screenshots показывают charts
# ✓ Privacy policy для health data

# Результат:
~/FitnessTracker/
├── .git/
├── .gitignore
├── backlog.md
├── design_system.md
├── FitnessTracker.xcodeproj
└── [полная структура проекта]

# Можно публиковать на GitHub!
git remote add origin https://github.com/username/FitnessTracker.git
git push -u origin main
```

---

### Пример 3: Добавление Функции (Existing Project)

```bash
# Перейти в существующий проект
cd ~/MyExistingApp

# Запустить только нужные фазы
~/fabrika/factory.sh pm_lead --input "Add Apple Watch companion app with workout tracking" --existing

# Просмотреть backlog.md (добавлены новые requirements)

# Phase 2: Design для Watch
~/fabrika/factory.sh ui_engineer --existing

# Phase 3: Реализация WatchOS app
~/fabrika/factory.sh swift_dev --existing

# Phase 4: Testing
~/fabrika/factory.sh qa_audit --existing

# Результат: WatchOS app добавлен к существующему проекту
```

---

## Утилиты

### Показать Статус

```bash
./factory.sh status

# Выход:
# 🏭 Factory Status
# Local Projects:
#   ▸ MeditationApp
#   ▸ FitnessTracker
# Agents Available:
#   ▸ pm_lead
#   ▸ ui_engineer
#   ▸ swift_dev
#   ▸ qa_audit
#   ▸ aso_expert
```

### Список Проектов

```bash
./factory.sh list

# Выход:
# 🏭 Projects List
# 1. MeditationApp
#    └─ backlog.md exists
#    └─ design_system.md exists
#    └─ Xcode project exists
# 2. FitnessTracker
#    └─ backlog.md exists
```

---

## Troubleshooting

### Factory не запускается

**Проблема:** `./factory.sh: command not found`

**Решение:**
```bash
# Сделайте файл исполняемым
chmod +x factory.sh

# Или запустите через bash
bash factory.sh help
```

---

### Claude Code не найден

**Проблема:** `claude: command not found`

**Решение:**
```bash
# Установите Claude Code
# https://claude.ai/code

# Проверьте установку
claude --version

# Если установлен но не в PATH:
export PATH=$PATH:/path/to/claude
```

---

### Axiom команды не работают

**Проблема:** `/prescan-memory: command not found`

**Решение:**
```bash
# Переустановите Axiom
claude code
/plugin remove CharlesWiltgen/Axiom
/plugin marketplace add CharlesWiltgen/Axiom

# Проверьте
/help
# Должны увидеть Axiom skills
```

---

### Memory leaks не исправляются

**Проблема:** `/prescan-memory` находит leaks но не ясно как исправить

**Решение:**
1. Проверьте qa_audit report для конкретных leak patterns
2. Обратитесь к Axiom memory debugging документации
3. Используйте Instruments вручную:
   ```bash
   open -a Instruments
   # Select "Leaks" template
   # Profile your app
   ```
4. Распространённые причины:
   - Strong self в closures → используйте `[weak self]`
   - Strong delegates → делайте `weak`
   - Не удалённые observers → removeObserver в deinit

---

### Accessibility audit failures

**Проблема:** `/audit-accessibility` находит violations

**Решение:**
1. Проверьте ACCESSIBILITY_AUDIT.md для деталей
2. Тестируйте вручную с VoiceOver (Cmd+F5)
3. Используйте Accessibility Inspector:
   ```bash
   # Xcode → Open Developer Tool → Accessibility Inspector
   ```
4. Распространённые проблемы:
   - Missing labels → добавьте `.accessibilityLabel()`
   - Poor contrast → используйте Contrast Checker
   - Small touch targets → минимум 44x44pt

---

### Build errors в Phase 3

**Проблема:** Xcode проект не компилируется

**Решение:**
1. Проверьте Swift 6 concurrency compliance
2. Проверьте версию Xcode (нужна 15.0+)
3. Clean build folder (Cmd+Shift+K)
4. Прочитайте IMPLEMENTATION.md для архитектуры
5. Проверьте error messages:
   - "Call to main actor-isolated" → добавьте @MainActor
   - "Cannot pass ... across actor boundary" → используйте Sendable

---

## Best Practices

### Для Phase 1 (pm_lead)
- ✅ Анализируйте минимум 3 конкурента
- ✅ Будьте специфичны в technical requirements
- ✅ Включайте визуальные референсы
- ✅ Думайте о App Store guidelines с самого начала

### Для Phase 2 (ui_engineer)
- ✅ Начинайте с HIG как базы
- ✅ Используйте Liquid Glass экономно
- ✅ Проектируйте Dark Mode с самого начала
- ✅ Планируйте accessibility с самого начала

### Для Phase 3 (swift_dev)
- ✅ Следуйте Swift 6 best practices
- ✅ Используйте @Observable (не ObservableObject)
- ✅ Всегда используйте actors для thread-safety
- ✅ Пишите код для testability

### Для Phase 4 (qa_audit)
- ✅ Тестируйте на реальных устройствах
- ✅ Исправляйте leaks немедленно
- ✅ Тестируйте с VoiceOver реально
- ✅ Профилируйте на старых устройствах

### Для Phase 5 (aso_expert)
- ✅ Исследуйте keywords тщательно
- ✅ Лидируйте с сильнейшей фичей
- ✅ Фокусируйтесь на benefits, не features
- ✅ Тестируйте разные screenshot orders

---

## Дополнительные Ресурсы

- **Axiom**: https://github.com/CharlesWiltgen/Axiom
- **Claude Code**: https://claude.ai/code
- **Apple HIG**: https://developer.apple.com/design/human-interface-guidelines/
- **Swift**: https://swift.org/documentation/
- **App Store Guidelines**: https://developer.apple.com/app-store/review/guidelines/

---

**Happy Building! 🏭**

*От идеи до App Store за часы, не недели* 🚀
