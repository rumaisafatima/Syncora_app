# 📱 Syncora — Premium Flutter Multi-Screen App

> **Tagline:** Connected learning, simplified.

Syncora is a fully functional, production-quality Flutter mobile application built as a flagship academic project demonstrating mastery of modern Flutter development. It follows a clean **MVC + Provider** architecture with real-time state management, persistent local storage, advanced form validation, and a fully interactive course dashboard.

---

## 📋 Table of Contents

1. [Project Requirements](#-1-project-requirements)
2. [Tech Stack & Dependencies](#-2-tech-stack--dependencies)
3. [Project Structure](#-3-project-structure)
4. [File-by-File Breakdown](#-4-file-by-file-breakdown)
5. [Core Code Logic Explained](#-5-core-code-logic-explained)
6. [Screen Walkthrough](#-6-screen-walkthrough)
7. [How to Run Locally](#-7-how-to-run-locally)
8. [Git Repository](#-8-git-repository)

---

## ✅ 1. Project Requirements

This app satisfies every requirement from the academic Flutter evaluation rubric:

### Registration Screen
| Requirement | Status | Implementation |
|---|---|---|
| Full Name field | ✅ | `CustomTextField` with full name validator |
| Email with validation | ✅ | Regex: `^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$` |
| Password / Re-type Password | ✅ | Side-by-side validators with match check |
| Gender selection dropdown | ✅ | `DropdownButtonFormField<Gender>` using enum |
| Min 6 characters password | ✅ | `if (pw.length < 6)` check in `AppValidators` |
| At least 1 uppercase letter | ✅ | `RegExp(r'[A-Z]').hasMatch(pw)` |
| At least 1 special character | ✅ | `RegExp(r'[!@#\$%^&*...]').hasMatch(pw)` |
| All fields required | ✅ | `AppValidators.required()` on every field |
| Confirm password matching | ✅ | `AppValidators.confirmPassword()` |
| Success navigation to login | ✅ | `Navigator.pushReplacementNamed(context, '/login')` |

### Login Screen
| Requirement | Status | Implementation |
|---|---|---|
| Email field with validation | ✅ | `AppValidators.email()` |
| Password toggle (show/hide) | ✅ | Stateful `_showPassword` + eye icon `IconButton` |
| Remember Me checkbox | ✅ | Persists session to `SharedPreferences` |
| Login navigates to dashboard | ✅ | `Navigator.pushReplacementNamed(context, '/dashboard')` |

### Dashboard Screen
| Requirement | Status | Implementation |
|---|---|---|
| User name display with avatar | ✅ | `CircleAvatar` with initials from `UserModel.initials` |
| Dynamic subject list | ✅ | `Subject.values` enum mapped to cards |
| Tap gesture for navigation | ✅ | `GestureDetector` + `onTap` → `/detail` |
| Navigation to detail screen | ✅ | `Navigator.pushNamed()` with `arguments` payload |
| Logout button → login screen | ✅ | `OutlinedButton` with `_confirmLogout()` dialog |

### Detail Screen
| Requirement | Status | Implementation |
|---|---|---|
| Subject header displayed | ✅ | `SliverAppBar` with subject name |
| Banner image | ✅ | `CustomPainter` geometric gradient banner |
| Description | ✅ | Pulled from `Subject.description` enum field |
| Schedule details | ✅ | Live countdown timer + schedule string from enum |

### Core Architecture Requirements
| Requirement | Status | Implementation |
|---|---|---|
| Form validation | ✅ | `Form` + `GlobalKey<FormState>` + `autovalidateMode` |
| Custom Validator Class | ✅ | `lib/validators/app_validators.dart` |
| Enum Implementation | ✅ | `Gender`, `AuthState`, `Subject` enums |
| Controller Layer | ✅ | `AuthController extends ChangeNotifier` |
| Project on Git Repository | ✅ | [github.com/rumaisafatima/Syncora_app](https://github.com/rumaisafatima/Syncora_app) |

---

## 🛠 2. Tech Stack & Dependencies

```yaml
dependencies:
  flutter: sdk           # Core framework
  provider: ^6.1.2       # State management (ChangeNotifier pattern)
  shared_preferences: ^2.2.2  # Persistent local key-value storage
  google_fonts: ^8.0.2   # Premium typography (Inter font family)
  cupertino_icons: ^1.0.6  # iOS-style icon set
```

| Technology | Role |
|---|---|
| **Flutter 3.10+** | Cross-platform UI framework (Android + iOS) |
| **Dart 3.0+** | Programming language |
| **Provider** | Reactive state management via `ChangeNotifier` |
| **SharedPreferences** | Local device storage (Remember Me, Dark Mode, Bookmarks) |
| **Google Fonts** | Inter & Outfit typefaces for premium UI |

---

## 📁 3. Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart                    # App entry point, routing, theming
│   ├── controllers/
│   │   └── auth_controller.dart     # Business logic & state management
│   ├── enums/
│   │   └── app_enums.dart           # Gender, AuthState, Subject enums
│   ├── models/
│   │   └── user_model.dart          # User data class
│   ├── screens/
│   │   ├── splash_screen.dart       # Animated entry + auth guard
│   │   ├── login_screen.dart        # Login form + validation
│   │   ├── register_screen.dart     # Registration form + validation
│   │   ├── dashboard_screen.dart    # Course list + user profile
│   │   └── detail_screen.dart       # Course detail + tabs + timer
│   ├── validators/
│   │   └── app_validators.dart      # Static validation methods
│   └── widgets/
│       └── custom_text_field.dart   # Reusable input field component
├── android/                         # Android build configuration
├── ios/                             # iOS build configuration
├── pubspec.yaml                     # Dependency manifest
└── README.md                        # This file
```

---

## 📄 4. File-by-File Breakdown

---

### `lib/main.dart` — App Entry Point

**What it does:**
- Initializes `AuthController` **before** the UI launches using `WidgetsFlutterBinding.ensureInitialized()`
- Reads `SharedPreferences` on startup to restore saved sessions (Remember Me)
- Wraps the entire app in `ChangeNotifierProvider` so every widget tree can access auth state
- Defines all named routes: `/`, `/login`, `/register`, `/dashboard`, `/detail`
- Contains a **route guard** that blocks unauthorized users from accessing `/dashboard` or `/detail` without logging in — redirecting them to `/login`
- Defines both **Light Theme** and **Dark Theme** using `ColorScheme.fromSeed()` with custom indigo/violet color palette

**Key logic:**
```dart
// Route guard — prevents unauthenticated access
onGenerateRoute: (settings) {
  if (settings.name == '/dashboard' || settings.name == '/detail') {
    if (!isAuthenticated) {
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
  return null;
},
```

---

### `lib/enums/app_enums.dart` — Data Constraints

**What it does:**
Defines three enums that replace error-prone raw strings throughout the app.

#### `Gender` enum
```dart
enum Gender {
  male('Male'),
  female('Female'),
  other('Other'),
  preferNotToSay('Prefer not to say');
  final String label;
}
```
Used in the registration dropdown and stored/retrieved from `SharedPreferences`.

#### `AuthState` enum
```dart
enum AuthState { idle, loading, success, error }
```
Drives the `AuthController` state machine. The UI listens to this to show loading spinners or error messages.

#### `Subject` enum
The most complex enum — each Subject carries 7 typed fields:
```dart
enum Subject {
  mobileAppDevelopment(
    name: 'Mobile App Development',
    code: 'CS-401',
    schedule: 'Mon / Wed / Fri  —  9:00 AM – 10:30 AM',
    room: 'CYS Lab',
    instructor: 'Mam Rooshana Mughal',
    email: 'rooshana.mughal@gmail.com',
    credits: 3,
  ),
  // ... 4 more subjects
}
```

**Subjects included:**
| Code | Name | Instructor | Room |
|---|---|---|---|
| CS-401 | Mobile App Development | Mam Rooshana Mughal | CYS Lab |
| CS-402 | Software Re-engineering | Sir Conrad 'D Silva / Mam Noureen Anwar | Room 201 |
| CS-403 | Management Information Systems | Ahmed Qaiser | SF-240 |
| CS-404 | UI/UX Design and Development | Mam Raazia Sosan | ADV-Ai Lab |
| CS-499 | Final Year Project II | Dr. Kamran Khan | Project Lab |

---

### `lib/models/user_model.dart` — User Data Class

**What it does:**
A clean, immutable data model representing a logged-in user.

```dart
class UserModel {
  final String fullName;
  final String email;
  final Gender gender;
}
```

**Computed properties:**
- `firstName` — extracts the first word from `fullName` (e.g., "Rumaisa" from "Rumaisa Fatima")
- `initials` — extracts first letters of first + last name (e.g., "RF") for the avatar display

**Serialization:**
- `toMap()` → converts to `Map<String, dynamic>` for storage
- `fromMap()` → rebuilds a `UserModel` from stored data (used on app restart)

---

### `lib/validators/app_validators.dart` — Validation Logic

**What it does:**
A pure static class with zero UI dependencies. All validation logic lives here and is reused across both the login and registration screens.

```dart
class AppValidators {
  AppValidators._(); // Private constructor — prevents instantiation

  static String? required(String? value, {String fieldName = 'This field'})
  static String? fullName(String? value)
  static String? email(String? value)
  static String? password(String? value)
  static String? confirmPassword(String? value, String originalPassword)
  static String? gender(String? value)
}
```

**Password validation rules:**
```dart
if (pw.length < 6)           → "Password must be at least 6 characters"
if (!RegExp(r'[A-Z]')...)    → "Must contain at least 1 uppercase letter"
if (!RegExp(r'[!@#$...]')...) → "Must contain at least 1 special character"
```

**Email validation regex:**
```
^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$
```
This ensures `you@example.com` passes but `user@` or `@domain` fails.

---

### `lib/controllers/auth_controller.dart` — Business Logic

**What it does:**
The core controller extending `ChangeNotifier`. It is the **only** part of the app that reads/writes to `SharedPreferences`. The UI never directly touches storage.

**State it manages:**
```dart
AuthState _state         // idle | loading | success | error
UserModel? _currentUser  // null if logged out
bool _rememberMe         // persisted across restarts
bool _isDarkMode         // global theme toggle
List<String> _bookmarkedCourses  // bookmarked subject codes
List<String> _enrolledCourses    // enrolled subject codes
```

**Key methods:**

| Method | Description |
|---|---|
| `init()` | Called at app launch — restores session from SharedPreferences |
| `register()` | Saves new user to in-memory map + SharedPreferences |
| `login()` | Validates credentials, creates `UserModel`, persists session |
| `logout()` | Clears `_currentUser`, wipes session data |
| `toggleDarkMode()` | Flips theme, persists preference |
| `toggleBookmark()` | Adds/removes from bookmark list, persists |

**Remember Me logic:**
```dart
if (rememberMe) {
  await prefs.setString(_keyLoggedInEmail, normalised);
}
// On next app launch, init() reads this and auto-logs in
```

---

### `lib/widgets/custom_text_field.dart` — Reusable Input Widget

**What it does:**
A single reusable widget that replaces hundreds of lines of repeated `TextFormField` code. Every text input in the app (email, password, name) uses this component.

**Parameters:**
```dart
CustomTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData prefixIcon,
  String? Function(String?)? validator,
  bool obscureText = false,
  TextInputType keyboardType,
  Widget? suffixIcon,
  FocusNode? focusNode,
  FocusNode? nextFocusNode,  // Auto-advances focus on submit
})
```

**Behaviour:**
- `floatingLabelBehavior: FloatingLabelBehavior.never` — keeps the label inside the box at all times
- `autovalidateMode: AutovalidateMode.onUserInteraction` — shows errors as user types, not just on submit
- Auto-focus advancement: when the user presses "next" on the keyboard, focus jumps to the next field

---

### `lib/screens/splash_screen.dart` — Entry Animation

**What it does:**
- Shows an animated logo for ~2 seconds
- Checks `AuthController.isAuthenticated`
- If logged in → navigates to `/dashboard`
- If not → navigates to `/login`

---

### `lib/screens/login_screen.dart` — Login Screen

**What it does:**
- Full immersive purple gradient background (`LinearGradient` from `colorScheme.primary` to `colorScheme.tertiary`)
- `Form` with `GlobalKey<FormState>` for validation control
- Shows/hides password with `_showPassword` boolean state
- "Remember Me" checkbox wired to `AuthController.login(rememberMe: _rememberMe)`
- On success → `Navigator.pushReplacementNamed(context, '/dashboard')`
- On failure → `SnackBar` with error message from controller

---

### `lib/screens/register_screen.dart` — Registration Screen

**What it does:**
- Same immersive gradient background as Login
- `LinearProgressIndicator` at the top that fills as the user completes each field (calculated from `_formProgress` which evaluates each validator in real-time)
- Gender selection via `DropdownButtonFormField<Gender>`
- Password strength indicator (Weak / Fair / Strong) based on character complexity
- On success → navigates to `/login` after a 2-second delay

---

### `lib/screens/dashboard_screen.dart` — Course Dashboard

**What it does:**
- Displays the logged-in user's name, email, and gender in a gradient profile card
- Lists all subjects from `Subject.values` as interactive cards
- **Search bar** filters courses in real-time using `.where()` on the enum list
- **Skeleton loader** animates for 1.5 seconds on load (mimics real API call)
- **Pull-to-refresh** re-triggers the fake loading animation with haptic feedback
- **Bookmark toggle** on each card persists to `SharedPreferences`
- **Logout button** at the bottom opens a confirmation `AlertDialog` before clearing session

**Navigation to detail:**
```dart
Navigator.pushNamed(
  context,
  '/detail',
  arguments: {'subject': subject, 'color': color},
);
```

---

### `lib/screens/detail_screen.dart` — Course Detail Dashboard

**What it does:**
The most complex screen. Receives the subject via route arguments and renders a fully interactive course dashboard with 4 tabs.

#### Tabs:
| Tab | Content |
|---|---|
| **Overview** | About the course → Performance Analytics → Course Progress |
| **Assignments** | Course-specific assignment list with due dates; auto-marks overdue |
| **Schedule** | Live countdown timer to next class session |
| **Instructor** | Teacher name, room, email contact |

#### Live Countdown Timer Logic:
```dart
// Parses schedule string: "Mon / Wed / Fri — 9:00 AM – 10:30 AM"
// 1. Extracts day abbreviations → converts to weekday integers (Mon=1, Tue=2...)
// 2. Finds the nearest upcoming class day from DateTime.now().weekday
// 3. Calculates exact Duration until that class starts
// 4. Displays: "3d 4h" for long durations, "2h 15m 30s" for same-day
```

#### Assignment Auto-Status Logic:
```dart
// Each assignment has a DateTime dueDate
// If DateTime.now().isAfter(assignment.dueDate) → renders with strikethrough + green checkmark
// Otherwise → renders as pending
```

---

## 🔑 5. Core Code Logic Explained

### State Management Flow
```
User Action (button tap)
    ↓
Screen calls context.read<AuthController>().login()
    ↓
AuthController sets state = AuthState.loading → notifyListeners()
    ↓
UI rebuilds → shows CircularProgressIndicator
    ↓
AuthController validates → sets _currentUser → state = AuthState.success
    ↓
notifyListeners() → UI rebuilds → Navigator pushes to /dashboard
```

### Remember Me Persistence Flow
```
Login with Remember Me = true
    ↓
SharedPreferences.setBool('remember_me', true)
SharedPreferences.setString('logged_in_email', email)
    ↓
App closed / restarted
    ↓
main() calls authController.init()
    ↓
init() reads 'remember_me' = true from storage
    ↓
Reconstructs UserModel from stored email data
    ↓
SplashScreen sees isAuthenticated = true → routes to /dashboard
```

### Form Validation Flow
```
User types in field → AutovalidateMode.onUserInteraction triggers
    ↓
AppValidators.email(value) is called
    ↓
Regex match fails → returns error string
    ↓
TextFormField renders red border + error message below field
    ↓
User corrects input → validator returns null → error clears
    ↓
User taps Submit → _formKey.currentState!.validate() runs ALL validators
    ↓
All pass → controller.register() called
    ↓
Any fail → submit blocked, errors shown
```

---

## 📱 6. Screen Walkthrough

```
App Launch
    └── SplashScreen (2s animation)
         ├── Not logged in → LoginScreen
         │    └── Tap "Sign Up" → RegisterScreen
         │         └── Success → back to LoginScreen
         │
         └── Logged in (Remember Me) → DashboardScreen
              └── Tap Subject Card → DetailScreen
                   ├── Overview Tab
                   ├── Assignments Tab
                   ├── Schedule Tab (Live Timer)
                   └── Instructor Tab
```

---

## 🚀 7. How to Run Locally

### Prerequisites
- Flutter SDK 3.10 or higher
- Android Studio / Xcode
- An Android emulator or physical device

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/rumaisafatima/Syncora_app.git
cd Syncora_app

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Build APK (Android)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🌐 8. Git Repository

**Repository:** https://github.com/rumaisafatima/Syncora_app

```bash
# To push future changes
git add .
git commit -m "your message"
git push
```

---

## 👩‍💻 Developer

**Rumaisa Fatima**
- GitHub: [@rumaisafatima](https://github.com/rumaisafatima)

---

*Built with ❤️ using Flutter & Dart*
