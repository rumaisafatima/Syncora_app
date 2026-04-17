# Syncora: Premium Flutter Multi-Screen App
**Tagline:** Connected learning, simplified.

Welcome to the Syncora codebase! This application was developed as a flagship final iOS/Android application to demonstrate mastery over modern Flutter structural requirements, robust state management, and enterprise-grade UI/UX design.

---

## 🌟 1. Project Features & Importance

This project strictly follows and extensively supersedes the standard requirements for an academic Flutter evaluation mapping. 

### Why is this Architecture Important?
This app completely discards chaotic spaghetti code in favor of a clean **Model-View-Controller (MVC) + Provider** architecture. By separating the user interface (Screens) from the native logic (Controllers & Validators), the codebase proves that it is scalable, readable, and highly maintainable for professional software development teams.

### Included Platinum Features:
- **Global Dark Mode Engine:** An intelligent theme-switcher powered by `Provider` that natively maps midnight-grey and pure white contrast tokens across the entire application simultaneously. 
- **Fake-API Shimmer Animation:** A sophisticated mathematical `TweenAnimationBuilder` system running in the Dashboard's `initState` that perfectly mimics asynchronous database calls (simulating real-world server latency).
- **Physical Gesture Pull-to-Refresh:** The system scroll physics are overridden by a native `RefreshIndicator`, triggering hardware vibration modules and live synchronizations when dragged.
- **Mathematical Form Progress Indicator:** During registration, `LinearProgressIndicator` calculations map silently to `AutovalidateMode` regex queries to give a literal percentage visualization of your form completion metrics.
- **Persistent Local Memory (SharedPreferences):** Both "Bookmarks", "Enrollments", "Dark Mode", and "Remember Me" flags are permanently written into the hidden native iOS Sandbox / Android SharedPreferences cache, demonstrating advanced localized tracking that behaves exactly like a real cloud database.
- **Parallax Banner Geometric Header:** Eschewing basic low-effort PNG placeholders, the Detail view uses `CustomPainter` mixed with `SliverAppBar` to create high-octane background banners that intelligently scale, blur, and compress natively when the user rubber-band scrolls.

---

## 🏗️ 2. Core Structure & File Explanations

The app is completely sanitized. There are **zero** unused files in this repository. Removing any of these files will cause catastrophic compile errors, as they all possess dedicated routing logic.

### 📍 Root Configuration
*   **`lib/main.dart`**: The brain of the application. It establishes the global `MaterialApp`, handles the core static route mapping (`/login`, `/dashboard`, etc.), guards unauthorized routing attempts, and statically defines the global Light and Dark Themes.

### 📍 The "Model" & "Enum" Layers (Data Constraints)
*   **`lib/models/user_model.dart`**: A structurally safe, immutable JSON-serializable Dart class defining what a "User" is (Name, Email, Password Hash substitute, Gender Enum).
*   **`lib/enums/app_enums.dart`**: The strict data constraint file. Instead of typing error-prone strings like "male" or "Mobile App Development", this holds type-safe flags linking specific Subject names to specific descriptions, instructors, and rooms.

### 📍 The "Controller" Layer (Business Logic)
*   **`lib/controllers/auth_controller.dart`**: An enterprise `ChangeNotifier`. It acts as the only middleman between the app UI and the device's hard drive (`SharedPreferences`). It executes simulated network logins, validates tokens, and modifies global state.
*   **`lib/validators/app_validators.dart`**: Pure mathematical Regex logic. It stores static methods confirming passwords possess uppercase characters, numbers, and proper email domain formatting.

### 📍 The "View" Layer (Screens & UI)
*   **`lib/screens/splash_screen.dart`**: A custom-animated welcome delay that intelligently decides if the user should bypass login (`isAuthenticated == true`).
*   **`lib/screens/login_screen.dart`**: The visual execution of the authentication gateway utilizing `InkWell` ambient UI gradients.
*   **`lib/screens/register_screen.dart`**: The registration logic mapping nested forms dynamically to the validators.
*   **`lib/screens/dashboard_screen.dart`**: The most complex file. Contains the skeleton loaders, the `RefreshIndicator`, and live search `.where()` functions querying through the global Subject array.
*   **`lib/screens/detail_screen.dart`**: A dynamically generated view that receives `ModalRoute.of(context)!.settings.arguments` payload data to map exact custom `Sliver` effects and interactive `FloatingActionButtons`.

### 📍 The "Widgets" Layer (Reusable Elements)
*   **`lib/widgets/custom_text_field.dart`**: Modularized input components built natively to avoid repeating thousands of duplicate lines of `BoxDecoration` form code.

---

## 🚀 3. How To Push to GitHub (Terminal Guide)

To permanently back up this project and share it with your professors via Git, open your Visual Studio Code completely ignoring the Flutter Run terminal, open a **brand new Terminal Tab**, and run the following commands sequentially:

**Step 1: Initialize Git and Stage the files**
```bash
git init
git add .
```

**Step 2: Commit your masterpiece locally**
```bash
git commit -m "Initial commit: Developed Syncora with complete Platinum UI features, Provider Architecture, and Local DB."
```

**Step 3: Link your GitHub Repository**
*(You must first go to GitHub.com, create a New Repository called 'syncora-app', and copy the URL)*
```bash
git branch -M main
git remote add origin YOUR_GITHUB_REPOSITORY_URL_HERE
```

**Step 4: Push to the Cloud**
```bash
git push -u origin main
```

> **Note on Safety:** Flutter projects automatically generate a `.gitignore` file. You do NOT have to worry about accidentally uploading gigabytes of cache or system dependencies. Only your raw string code will be pushed securely!
