# AI Meal Planner

Приложение для создания персонализированных планов питания с использованием искусственного интеллекта для мобильных устройств.

## Описание проекта

AI Meal Planner - это мобильное приложение на Flutter, которое использует OpenAI API для генерации персонализированных планов питания на основе профиля пользователя. Приложение позволяет пользователям создать профиль с персональными параметрами, указать диетические ограничения и аллергии, после чего получать индивидуальные планы питания с детальной информацией о блюдах, калориях и макронутриентах.

## Что было сделано

- Создана структура проекта с разделением на экраны, виджеты, модели, сервисы, утилиты, константы и навигацию
- Реализована аутентификация через Google Sign In с использованием Firebase Auth
- Создан экран профиля пользователя с полями для личной информации, физических параметров, уровня активности, целей, диетических ограничений и аллергий
- Реализован автоматический расчет суточной нормы калорий на основе формулы Миффлина-Сан Жеора (BMR) с учетом уровня активности и целей пользователя
- Интегрирован OpenAI API для генерации персонализированных планов питания
- Создан экран генерации плана питания с возможностью выбора продолжительности (1-14 дней)
- Реализован экран отображения плана питания с группировкой по дням и типам блюд (завтрак, обед, ужин, перекусы)
- Добавлено отображение детальной информации о каждом блюде: название, описание, калории, белки, углеводы, жиры, ингредиенты и рецепт
- Реализовано сохранение планов питания в Cloud Firestore для доступа к истории
- Создан экран списка сохраненных планов питания с возможностью просмотра
- Реализован главный экран с навигацией между разделами приложения
- Организованы виджеты по экранам: виджеты для экрана профиля, генерации плана, отображения плана
- Созданы переиспользуемые UI-компоненты (кнопка, карточки, формы)
- Вынесены все цвета приложения в отдельный файл констант с поддержкой светлых вариантов цветов
- Реализована обработка ошибок с понятными сообщениями для пользователя
- Добавлена поддержка состояния загрузки при генерации планов питания
- Реализована поддержка адаптивного дизайна с SingleChildScrollView для разных размеров экранов
- Добавлено извлечение всех функций из верстки в методы класса для лучшей организации кода
- Настроено название приложения "AI Meal Planner" для Android
- Добавлена иконка приложения для Android
- Интегрирована аналитика: Firebase Analytics, AppMetrica, AppsFlyer
- Создан единый сервис аналитики для управления всеми системами
- Добавлены кастомные события аналитики для отслеживания действий пользователей
- Интегрирована реклама AdMob с баннерными объявлениями
- Настроено автоматическое отслеживание экранов через RouteObserver

## Используемые пакеты

- `flutter` - основной фреймворк
- `firebase_core` - базовая функциональность Firebase
- `firebase_auth` - аутентификация пользователей
- `cloud_firestore` - облачная база данных для хранения профилей и планов питания
- `google_sign_in` - вход через Google аккаунт
- `http` - HTTP-запросы к OpenAI API
- `flutter_dotenv` - загрузка переменных окружения из .env файла
- `logger` - логирование действий и ошибок
- `cupertino_icons` - иконки для iOS стиля
- `firebase_analytics` - аналитика Firebase
- `appmetrica_plugin` - аналитика AppMetrica
- `appsflyer_sdk` - аналитика и атрибуция AppsFlyer
- `google_mobile_ads` - реклама AdMob
- `flutter_lints` - линтеры для проверки кода (dev dependency)
- `flutter_launcher_icons` - генерация иконок приложения (dev dependency)

## Архитектура

Проект следует принципам SOLID и KISS. Код организован в следующие директории:

- `lib/screens/` - экраны приложения (авторизация, главный экран, профиль пользователя, генерация плана питания, отображение плана, список планов)
- `lib/widgets/` - переиспользуемые виджеты, организованные по экранам
  - `lib/widgets/user_profile_screen/` - виджеты для экрана профиля пользователя
  - `lib/widgets/meal_plan_generation_screen/` - виджеты для экрана генерации плана питания
  - `lib/widgets/meal_plan_display_screen/` - виджеты для экрана отображения плана питания
  - `lib/widgets/ui/` - переиспользуемые UI-компоненты (кнопки и т.д.)
  - `lib/widgets/layouts/` - виджеты компоновки (общий layout для экранов)
- `lib/models/` - модели данных (UserProfile, Meal, MealPlan)
- `lib/services/` - бизнес-логика и интеграции
  - `init_in_start_service.dart` - сервис инициализации всех сервисов при старте приложения
  - `auth_service.dart` - сервис аутентификации через Firebase
  - `firestore_service.dart` - сервис для работы с Cloud Firestore
  - `meal_plan_service.dart` - сервис генерации планов питания
  - `openai_service.dart` - сервис интеграции с OpenAI API
  - `analytics/` - сервисы аналитики
    - `analytics_service.dart` - единый сервис аналитики
    - `firebase_analytics_service.dart` - обертка для Firebase Analytics
    - `appmetrica_service.dart` - обертка для AppMetrica
    - `appsflyer_service.dart` - обертка для AppsFlyer
  - `ads/` - сервисы рекламы
    - `ad_service.dart` - сервис управления рекламой AdMob
- `lib/utils/` - утилиты (калькулятор калорий)
- `lib/constants/` - константы (цвета приложения, Ad Unit ID)
- `lib/navigation/` - навигация и маршруты приложения
  - `route_observer.dart` - автоматическое отслеживание экранов для аналитики

---

# AI Meal Planner

AI-powered personalized meal planning application for mobile devices.

## Project Description

AI Meal Planner is a Flutter mobile application that uses OpenAI API to generate personalized meal plans based on user profile. The application allows users to create a profile with personal parameters, specify dietary restrictions and allergies, and then receive individual meal plans with detailed information about dishes, calories, and macronutrients.

## What Was Done

- Created project structure with separation into screens, widgets, models, services, utilities, constants, and navigation
- Implemented authentication through Google Sign In using Firebase Auth
- Created user profile screen with fields for personal information, physical parameters, activity level, goals, dietary restrictions, and allergies
- Implemented automatic daily calorie calculation based on Mifflin-St Jeor formula (BMR) considering activity level and user goals
- Integrated OpenAI API for generating personalized meal plans
- Created meal plan generation screen with duration selection (1-14 days)
- Implemented meal plan display screen with grouping by days and meal types (breakfast, lunch, dinner, snacks)
- Added detailed information display for each meal: name, description, calories, proteins, carbs, fats, ingredients, and recipe
- Implemented meal plan saving to Cloud Firestore for history access
- Created saved meal plans list screen with viewing capability
- Implemented main screen with navigation between app sections
- Organized widgets by screens: widgets for profile screen, plan generation, plan display
- Created reusable UI components (button, cards, forms)
- Extracted all application colors into a separate constants file with support for light color variants
- Implemented error handling with clear user messages
- Added loading state support during meal plan generation
- Implemented adaptive design support with SingleChildScrollView for different screen sizes
- Added extraction of all functions from layout to class methods for better code organization
- Configured application name "AI Meal Planner" for Android
- Added application icon for Android
- Integrated analytics: Firebase Analytics, AppMetrica, AppsFlyer
- Created unified analytics service for managing all analytics systems
- Added custom analytics events for tracking user actions
- Integrated AdMob advertising with banner ads
- Configured automatic screen tracking through RouteObserver

## Used Packages

- `flutter` - main framework
- `firebase_core` - Firebase core functionality
- `firebase_auth` - user authentication
- `cloud_firestore` - cloud database for storing profiles and meal plans
- `google_sign_in` - Google account sign in
- `http` - HTTP requests to OpenAI API
- `flutter_dotenv` - loading environment variables from .env file
- `logger` - logging actions and errors
- `cupertino_icons` - icons for iOS style
- `firebase_analytics` - Firebase Analytics
- `appmetrica_plugin` - AppMetrica analytics
- `appsflyer_sdk` - AppsFlyer analytics and attribution
- `google_mobile_ads` - AdMob advertising
- `flutter_lints` - linters for code checking (dev dependency)
- `flutter_launcher_icons` - application icon generation (dev dependency)

## Architecture

The project follows SOLID and KISS principles. Code is organized into the following directories:

- `lib/screens/` - application screens (authentication, main screen, user profile, meal plan generation, plan display, plans list)
- `lib/widgets/` - reusable widgets, organized by screens
  - `lib/widgets/user_profile_screen/` - widgets for user profile screen
  - `lib/widgets/meal_plan_generation_screen/` - widgets for meal plan generation screen
  - `lib/widgets/meal_plan_display_screen/` - widgets for meal plan display screen
  - `lib/widgets/ui/` - reusable UI components (buttons, etc.)
  - `lib/widgets/layouts/` - layout widgets (common layout for screens)
- `lib/models/` - data models (UserProfile, Meal, MealPlan)
- `lib/services/` - business logic and integrations
  - `init_in_start_service.dart` - service for initializing all services at app startup
  - `auth_service.dart` - authentication service via Firebase
  - `firestore_service.dart` - service for working with Cloud Firestore
  - `meal_plan_service.dart` - meal plan generation service
  - `openai_service.dart` - OpenAI API integration service
  - `analytics/` - analytics services
    - `analytics_service.dart` - unified analytics service
    - `firebase_analytics_service.dart` - Firebase Analytics wrapper
    - `appmetrica_service.dart` - AppMetrica wrapper
    - `appsflyer_service.dart` - AppsFlyer wrapper
  - `ads/` - advertising services
    - `ad_service.dart` - AdMob advertising management service
- `lib/utils/` - utilities (calorie calculator)
- `lib/constants/` - constants (application colors, Ad Unit IDs)
- `lib/navigation/` - application navigation and routes
  - `route_observer.dart` - automatic screen tracking for analytics
