
```markdown
# 🎓 Gestion de Stage – Flutter & Firebase Application

## 📌 Overview
**Gestion de Stage** is a cross-platform mobile and desktop application built with **Flutter** and **Firebase**, designed to manage internship processes in an academic environment.  
The system connects **students**, **doctors (supervisors)**, **administrators (doyen)**, and **institutions** through a role-based architecture.

The project follows **Clean Architecture** principles to ensure scalability, maintainability, and clear separation of concerns.

---

## 🚀 Features

### 👩‍🎓 Student
- Authentication & profile management
- Browse available internships
- Apply for internships
- Upload and manage documents
- Track application status

### 👨‍⚕️ Doctor (Supervisor)
- View assigned students
- Review student applications
- Access student details and documents

### 🏛️ Administrator / Doyen
- Manage internships
- Manage users (students, doctors)
- Monitor applications and statuses

### 🏥 Institutions (Établissements)
- Create and manage internship offers
- View internship applicants
- Manage internship lifecycle

---

## 🧱 Architecture

The project follows **Clean Architecture**:

```


````

Each feature is divided into:
- **data** → models, data sources, repositories
- **domain** → entities, repositories, use cases
- **presentation** → UI, providers, screens

---

## 🔐 Authentication
- Firebase Authentication
- Role-based navigation (Student / Doctor / Admin / Institution)
- Secure access to features based on user role

---

## 🛠️ Tech Stack

- **Flutter** (Dart)
- **Firebase**
  - Authentication
  - Firestore
  - Storage
- **State Management**: Provider
- **Architecture**: Clean Architecture
- **Platforms**:
  - Android
  - iOS
  - Windows
  - Linux
  - macOS

---

## ⚙️ Installation & Setup

### Prerequisites
- Flutter SDK
- Firebase project
- Android Studio / VS Code
- Git

### Steps
```bash
git clone https://github.com/lilyKhad/gestion-de-stage.git
cd gestion-de-stage
flutter pub get
flutter run
````

---

## 🔥 Firebase Configuration

1. Create a Firebase project
2. Add Android / iOS / Web / Desktop apps
3. Download and place:

   * `google-services.json`
   * `GoogleService-Info.plist`
4. Enable:

   * Authentication
   * Firestore
   * Storage

---

---

## 📈 Future Improvements

* Notifications (Firebase Cloud Messaging)
* Advanced role permissions
* Internship evaluation system
* Admin analytics dashboard

---

## 👩‍💻 Author

**Bourzama khadidja**
Software Engineering Student
📍 Algeria

---

## 📄 License

This project is for academic and educational purposes.


