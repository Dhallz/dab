---
trigger: glob
description: Rules for UI Styling (Colors, Typography, Spacing, Icons) and Localization
globs: dab_app/lib/presentation/**/*.dart
---

# UI Styling & Localization Rules

These rules ensure design consistency across `dab_app` by enforcing the use of the centralized design system and localization framework. Hardcoding visual values or strings is strictly forbidden. 

The naming conventions follow **Material 3 (M3)** strictly.

---

## 🎨 Design System Components

All UI elements must use constants from `lib/presentation/core/styles/`.

| Style Category | Tool / Class | Never Use |
|---|---|---|
| **Colors** | `AppColors.xxx` | `Color(0xFF...)`, `Colors.xxx`, `Colors.xxx.withOpacity()` |
| **Typography** | `AppTextStyles.[role]` | `TextStyle(...)` with manual numeric values |
| **Spacing / Gap** | `AppSpacing.xxx` | `SizedBox(height: 24)`, `EdgeInsets.all(16.0)` |
| **Layout / Radius** | `AppLayout.[role]` | `BorderRadius.circular(12)`, `blur: 30` |
| **Icons** | `AppIcons.xxx` | `Icons.xxx` |

### 🖋️ Typography roles (M3)
Use roles like `displayLarge`, `headlineSmall`, `titleMedium`, `bodyLarge`, `labelSmall`, etc.

### 📐 Shape roles (M3)
Use roles like `radiusSmall`, `radiusMedium`, `radiusLarge`, `radiusExtraLarge`.

### Usage Examples

```dart
// ✅ Correct
Padding(
  padding: EdgeInsets.all(AppSpacing.m),
  child: Text(
    context.l10n.title,
    style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
  ),
)

// ❌ Wrong
Padding(
  padding: EdgeInsets.all(16.0),
  child: Text(
    'Title',
    style: TextStyle(fontSize: 32, color: Colors.blue),
  ),
)
```

---

## 🌐 Localization (L10n)

All user-facing strings must be localized using `.arb` files.

- **Mandatory**: Use the `context.l10n` extension (defined in `l10n_extension.dart`).
- **Pattern**: `context.l10n.yourKeyName`.
- **Exceptions**: Technical IDs, debug logs, or dynamic data from domain entities.

```dart
// ✅ Correct
Text(context.l10n.dashboardTitle)

// ❌ Wrong
Text('Dashboard')
```

---

## 📏 Spacing & Layout Guidelines

- Use `AppSpacing` for all margins, paddings, and `SizedBox` gaps.
- Use `AppLayout` for `BorderRadius`, `BoxShadow` blur, and shared layout dimensions.
- If a specific value is missing, **add it to the style class first** instead of using a literal.

---

## 🚫 Forbidden Patterns

- No `const Color(0x...)` outside of `AppColors`.
- No `const EdgeInsets.all(...)` with numeric literals.
- No direct usage of the `Material` `Icons` library in feature widgets (proxy via `AppIcons`).
- No hardcoded strings in `StatelessWidget` or `StatefulWidget` build methods.
