# 📝 ToDo List App

A modern and clean Flutter app for managing your daily tasks with ease.  
This project is designed to help users stay organized by adding, tracking, and completing tasks efficiently.

---

## 📸 Screenshots

| Home (Empty) | Add Task | Task Added |
|--------------|----------|------------|
| ![Home](screenshots/home_empty.png) | ![Add Task](screenshots/add_task.png) | ![Task Added](screenshots/task_added.png) |

---

## 🚀 Features

- ✔️ Add, update, and delete tasks.
- 📅 Track progress with a visual indicator.
- 🧠 Real-time UI updates using `Provider`.
- 💾 Persistent storage with `SQLite`.
- 🌙 Beautiful and smooth UI in Arabic.

---

## 🛠️ Tech Stack

- Flutter
- Dart
- SQLite
- Provider (State Management)
- Material Design

---

## 📁 Project Structure

```bash
lib/
├── model/             # Task model
├── util/              # SQLite database helper
├── provider/          # TaskProvider (ChangeNotifier)
├── screens/           # UI screens
├── widgets/           # Shared/reusable components
└── main.dart          # App entry point

Getting Started 🔊
To run this app locally, use the following commands:
   -git clone https://github.com/AlBaraaSobh/ToDo_list.git
   -cd ToDo_list
   -flutter pub get
   -flutter run

🤝 Contributions
Have a suggestion or found a bug?
Feel free to open an issue or submit a pull request!


👤 Author
Al Baraa A. M. Sobh
📧 albaraasobh@gmail.com


📄 License
This project is licensed under the MIT License.
