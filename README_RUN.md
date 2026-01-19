# Fabrika - Руководство по Использованию

Полная инструкция по работе с Mobile App Factory.

## Содержание

1. [Установка](#установка)
2. [Быстрый Старт](#быстрый-старт)
3. [Режимы Работы](#режимы-работы)
4. [Агенты](#агенты)
5. [5-Фазный Workflow](#5-фазный-workflow)
6. [Примеры](#примеры)
7. [Troubleshooting](#troubleshooting)

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
