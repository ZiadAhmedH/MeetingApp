# 📞 MeetingApp

A modern Flutter-based video meeting application powered by [ZegoCloud](https://www.zegocloud.com/) and [Supabase](https://supabase.com/) for authentication and backend. MeetingApp is built for fast, secure, and efficient real-time video communication.

<br/>

![Flutter](https://img.shields.io/badge/Flutter-3.22-blue?logo=flutter&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-Auth%20%7C%20DB-green?logo=supabase)
![ZegoCloud](https://img.shields.io/badge/ZegoCloud-Video%20SDK-blueviolet)
![License](https://img.shields.io/github/license/ZiadAhmedH/MeetingApp)

---

## 🚀 Features

- 🔐 **User Authentication**
  - Email and Password login
  - WhatsApp-based OTP verification using Supabase Auth (Phone OTP login)

- 🎥 **Video Meetings**
  - Create and join meetings with unique Meeting IDs
  - Toggle camera and microphone during sessions
  - Meeting session tracked in Supabase `meetings` table

- 👤 **User Profile**
  - View and update your profile
  - Upload profile image
  - Stores additional user info like username, job title, and location

- 📅 **Meeting History**
  - Stores details of ended meetings: duration, host, camera & mic status

- 💬 **Chat (via ZegoCloud)**
  - Real-time messaging within the meeting interface

---

## 🧠 Architecture

- **Flutter** for cross-platform frontend
- **Supabase** for backend database, authentication, and storage
- **ZegoCloud SDK** for real-time video & audio communication
- **Cubit (flutter_bloc)** for state management
- **MVVM** pattern for clean separation of concerns

---

## 📸 Screenshots

| Login | Home | Meeting |
|-------|------|---------|
| ![login](screenshots/login.png) | ![home](screenshots/home.png) | ![meeting](screenshots/meeting.png) |

---

## 🛠️ Getting Started

### Prerequisites
- Flutter 3.22 or higher
- ZegoCloud account and App credentials
- Supabase project with Auth, DB, and Storage configured

### Installation

1. **Clone the repo**
```bash
git clone https://github.com/ZiadAhmedH/MeetingApp.git
cd MeetingApp
```
## 📁 Folder Structure


<!DOCTYPE html>
<div class="folder">
  <details open>
    <summary>📁 <code>model/</code></summary>
    <div class="folder">
      <!-- Add file names here if desired -->
      <p>Data models (<code>UserModel</code>, <code>MeetingModel</code>, etc.)</p>
    </div>
  </details>

  <details open>
    <summary>📁 <code>services/</code></summary>
    <div class="folder">
      <p>Supabase and ZegoCloud integration logic</p>
    </div>
  </details>

  <details open>
    <summary>📁 <code>view/</code></summary>
    <div class="folder">
      <p>All UI screens and widgets</p>
    </div>
  </details>

  <details open>
    <summary>📁 <code>viewModel/</code></summary>
    <div class="folder">
      <p>Cubits and state management logic</p>
    </div>
  </details>

  <details open>
    <summary>📁 <code>utils/</code></summary>
    <div class="folder">
      <p>App colors, constants, and helper functions</p>
    </div>
  </details>

  <p>📄 <code>main.dart</code> – App entry point</p>
</div>

</body>
</html>
