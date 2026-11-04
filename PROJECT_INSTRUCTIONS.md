# 📋 Doctor Hunt — Project Architecture & Engineering Guidelines

This document outlines the core architecture principles, engineering standards, and coding conventions established for the **Doctor Hunt** Flutter codebase. All contributors and AI coding assistants must adhere to these guidelines.

---

## 🏛️ 1. Architecture & Layer Separation

Doctor Hunt follows **Feature-First Clean Architecture** with strict unidirection data flow:

```
[Presentation Layer] (Screens, Widgets)
        │  ▲
        ▼  │ (States)
[Business Logic] (BLoC / Cubit Controllers)
        │  ▲
        ▼  │ (Entities / Models / Failures)
[Repository Layer] (Data abstraction, cache management, user-scoping)
        │  ▲
        ▼  │ (DTOs / Raw JSON)
[Data Sources / Services] (Supabase Client, REST APIs, SharedPreferences)
```

### Critical Rules:
1. **Never bypass layers**: UI screens and widgets must **never** call `Supabase.instance.client`, `HttpClient`, or Repositories directly. All operations and state mutations must flow through a `Cubit` or `Bloc`.
2. **Domain Models Purity**: Domain models in `data/models/` must not contain UI presentation properties (such as localized display labels, color mappings, or icons). UI-specific presentation properties must be implemented via Dart extensions in `presentation/extensions/` or separate view models.
3. **Module Grouping**: Code is organized under `lib/features/` into clear role and functional domains:
   - `features/admin/`: Doctor management, scheduling availability, appointment controls.
   - `features/patient/`: Doctor discovery, profiles, booking flow, appointments, favorites.
   - `features/common/`: Authentication, splash screen, onboarding, role selection.

---

## 💉 2. Centralized Dependency Injection (`GetIt`)

All services, repositories, and global utilities are registered in a single, centralized service locator: [`lib/core/di/service_locator.dart`](file:///lib/core/di/service_locator.dart).

- **Global Singletons**: Use `sl.registerLazySingleton<T>()` for stateless services, client wrappers, storage managers (`SessionManager`, `SupabaseStorageService`, `SharedPreferences`), and repositories.
- **Stateful Controllers**: Use `sl.registerFactory<T>()` for Blocs/Cubits that have screen-dependent lifecycles.
- **No Direct Instantiation**: Never instantiate repositories or services directly inside widget classes (`StatefulWidget`/`StatelessWidget`). Always resolve via `sl<T>()` or inject via `BlocProvider(create: (_) => sl<T>())`.

---

## 🔄 3. State Management (BLoC / Cubit)

- **BLoC / Cubit for Business Logic**: All asynchronous states (loading, success, empty, failure) must be encapsulated in immutable states extending `Equatable`.
- **Right-Sized State**: Do not over-engineer simple local widget states (e.g., page index in an onboarding carousel, password visibility toggles, or search field focus). Use `StatefulWidget` with local `setState` for purely localized widget interactions.
- **Explicit Error Handling**: Always pass strongly-typed failure messages or custom exception types to UI states rather than hiding errors.

---

## 🧪 4. Testing Standards (200 Automated Tests)

Every feature must maintain comprehensive automated tests covering:
- **Unit Tests**: Blocs/Cubits, Repositories, Domain models, and Core utilities (`Debouncer`, `SessionManager`, `LocaleHelper`).
- **Edge Cases**: Network timeouts, null/empty responses, duplicate booking conflicts, session expirations.
- **Widget Tests**: Key UI components, forms, dialogs, and drawer navigation.
- **Run command**:
  ```bash
  flutter test
  ```

---

## 🛡️ 5. Booking Flow & Double-Booking Prevention

Preventing double bookings is critical to healthcare operations:
1. **Frontend Availability Engine**: The patient appointment booking screen dynamically filters out already booked slots by cross-referencing doctor appointments and schedule limits.
2. **Backend Integrity**: The database schema and repository enforce unique slot reservations.
3. **User-Scoped Persistence**: Favorites, appointments, and user history are strictly linked to the authenticated `currentUserId` and persisted via Supabase or SharedPreferences, ensuring data persists across app restarts.

---

## 🎨 6. Design System & Reusable Widgets

- **Centralized Colors**: Zero hardcoded hex colors in screens. Use [`AppColors`](file:///lib/core/themes/app_colors.dart) exclusively (`AppColors.primary`, `AppColors.coral`, `AppColors.background`, etc.).
- **Centralized Typography**: Zero inline `TextStyle(fontSize: ..., color: ...)` duplication. Use [`AppTextStyles`](file:///lib/core/themes/app_text_styles.dart) for titles, subtitles, body text, buttons, and captions.
- **Shared Components**: Reuse global components from `lib/core/widgets/`:
  - `CustomButton`: Consistent primary and outlined buttons.
  - `CustomTextField`: Styled input with debouncing support, prefix/suffix icons, and error indicators.
  - `LogoHeader`: Standardized branding header for auth and onboarding screens.
- **Live Search Debouncing**: Always debounce search query input using [`Debouncer`](file:///lib/core/utils/debouncer.dart) (~300ms) to avoid unnecessary queries and UI lag.

---

## 🌐 7. Type-Safe Localization (`slang`)

- Zero hardcoded Arabic or English text in presentation widgets. All user-facing strings must use the compile-time type-safe getter `t.<module>.<key>`.
- Language files:
  - English: `assets/i18n/strings.i18n.json`
  - Arabic (RTL): `assets/i18n/strings_ar.i18n.json`
- Real-time Language Switching: Use `LocaleSettings.setLocale(AppLocale.ar)` or `LocaleSettings.setLocale(AppLocale.en)`. All screens update reactively with proper RTL layout direction.
- Generate translations:
  ```bash
  dart run slang
  ```

---

## 🚦 8. Routing & Route Guards (`GoRouter`)

- **Consistent Navigation**: Always use `context.pushNamed`, `context.goNamed`, `context.pop()`, or `context.push()`. Avoid mixing raw `Navigator.push`.
- **Session & Role Route Guards**: [`SessionManager`](file:///lib/core/services/session_manager.dart) tracks onboarding completion, active authentication sessions, and user roles (`patient` vs `admin`).
- **Safe Route Parameters**: Never force-unwrap route parameters or IDs with `!`. Always provide safe fallback objects or gracefully handle missing IDs.

---

## ⚡ 9. Performance & Flutter Optimizations

- **Targeted MediaQueries**: Prefer `MediaQuery.sizeOf(context)`, `MediaQuery.paddingOf(context)`, and `MediaQuery.viewInsetsOf(context)` over `MediaQuery.of(context)` to prevent unnecessary widget rebuilds when unrelated window metrics change.
- **Resource Cleanup**: Always cancel and dispose `TextEditingController`, `FocusNode`, `ScrollController`, `AnimationController`, and `Debouncer` instances in `State.dispose()`.

---

## 🏷️ 10. Type Safety & Leveled Logging

- **Enums Over Magic Strings**: Use strongly-typed enums (`UserRole.patient`, `UserRole.admin`, `PatientAppointmentStatus`, `AdminAppointmentStatus`).
- **Structured Logging**: Use [`AppLogger`](file:///lib/core/utils/app_logger.dart) with level differentiation (`info`, `warning`, `error`). Raw `print()` or unconstrained `debugPrint()` calls in production are prohibited.

---

## 🤖 11. AI Pair-Programming & Automated Audit Protocol

When using AI tools (Antigravity, Cursor, GitHub Copilot) to audit or extend the project:
1. **Self-Audit**: Automatically scan for hardcoded strings, unreferenced colors, duplicated UI blocks, typos, and missing edge case tests.
2. **Simple Fixes**: For straightforward fixes (styling, shared widgets, translation keys, bug fixes), implement directly and verify with `flutter analyze` and `flutter test`.
3. **Architectural Decisions**: For major structural or business logic alterations, articulate the problem, trade-offs, and proposed solution clearly before applying changes.

