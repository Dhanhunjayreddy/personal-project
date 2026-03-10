# Flutter Posts & Notes App

A clean, responsive Flutter application demonstrating API integration, state management, and clean architecture. Built as a technical assignment.

## 📱 Screenshots

*(Note to reviewer: Screenshots of the application running in both Light and Dark modes are located in the `ScreenShots/` folder of this repository).*

## ✨ Features
- **Authentication:** Secure login with local token persistence.
- **CRUD Operations:** Create, Read, Update, and Delete posts via the public DummyJSON API.
- **Pagination & Infinite Scrolling:** Smoothly loads posts in batches of 10 when scrolling to the bottom.
- **Pull-to-Refresh:** Swipe down on the list to fetch the latest data.
- **Dark Mode Support:** Automatically adapts to the system's theme, plus a manual toggle in the AppBar.
- **Offline Handling:** Dynamic network listener that prevents state loss if the internet connection drops.
- **Clean Architecture:** Strict separation of UI (Screens), State (Provider), and Network (Services) layers.

## 🛠 Tech Stack
- **Framework:** Flutter (Stable)
- **State Management:** Provider
- **Networking:** HTTP package
- **Local Storage:** Shared Preferences
- **Network State:** Connectivity Plus

## 🚀 Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone <YOUR_GITHUB_REPO_LINK_HERE>
2. cd notetaking_app


3. flutter pub get


4.flutter run
