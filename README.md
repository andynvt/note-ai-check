# Notes App

A modern, cross-platform note-taking app built with Flutter using MVVM architecture, Provider for state management, Hive for local storage, and Firebase Messaging for push notifications.

---

## 📁 Project Structure (MVVM)

```
lib/
├── models/             # Note model, Hive adapter
├── view_models/        # ViewModels using Provider
├── views/              # UI (screens, widgets)
├── services/           # API service, database service, notification service
├── utils/              # Helpers, constants, enums
└── main.dart           # App entry point
```

---

## 🛠️ Tech Stack & Libraries

- **Flutter**: UI toolkit for building natively compiled apps
- **MVVM**: Clean architecture for separation of concerns
- **Provider**: State management and dependency injection
- **Hive**: Lightweight, fast local NoSQL database
- **hive_flutter**: Hive integration for Flutter
- **Dio**: Powerful HTTP client for Dart
- **firebase_core**: Core Firebase initialization
- **firebase_messaging**: Push notifications
- **image_picker**: Pick images from gallery/camera
- **permission_handler**: Request runtime permissions
- **flutter_local_notifications**: Local notifications
- **path_provider**: File system paths
- **uuid**: Generate unique IDs for notes

---

## 🌐 Mock API

- **Endpoints (simulated in NoteService):**
  - `GET /notes` — Fetch all notes
  - `GET /notes/:id` — Fetch a single note
  - `POST /notes` — Create a new note
  - `PUT /notes/:id` — Update a note
- **Implementation:**
  - The app uses a mock API via Dio in `lib/services/note_service.dart`.
  - For real API integration, replace the mock endpoints with your backend URLs and implement response parsing.

---

## 🚀 Features
- Offline-first: All notes are stored locally with Hive
- Sync: Notes are synced with the (mock) API on app launch and when receiving push notifications
- Add, edit, delete notes
- Attach images from gallery or camera
- Custom note background colors
- Push notifications (Firebase Messaging)
- Clean, testable MVVM codebase

---

## 🧪 Testing
- Unit tests for ViewModel and NoteService in `test/`
- Run tests with: `flutter test`

---

## 📦 Getting Started
1. Install dependencies: `flutter pub get`
2. (Optional) Set up Firebase for push notifications (see Firebase docs)
3. Run the app:
   - Android: `flutter run -d emulator-5554` (or your device ID)
   - macOS: `flutter run -d macos`
   - iOS: `flutter run -d ios` (after configuring Firebase and Xcode)

---

## 📄 License
MIT
