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
<img width="200" height="600" alt="Screenshot_1752447256" src="https://github.com/user-attachments/assets/846b6447-9f77-4880-84a7-9426556d8d69" />
<img width="200" height="600" alt="Screenshot_1752447240" src="https://github.com/user-attachments/assets/10749527-86e7-4c92-bc21-ea1e22ca0082" />
<img width="200" height="600" alt="Screenshot_1752447226" src="https://github.com/user-attachments/assets/8823e468-6091-4c1e-902d-6b1006df8f83" />
<img width="200" height="600" alt="Screenshot_1752447224" src="https://github.com/user-attachments/assets/7d8c0d06-b448-4385-b4ea-bd7c0e7bbaf2" />
<img width="200" height="600" alt="Screenshot_1752447217" src="https://github.com/user-attachments/assets/53daaff1-2fd4-45ba-ae8b-4dbb79ac6f63" />
<img width="200" height="600" alt="Screenshot_1752447209" src="https://github.com/user-attachments/assets/af0459bc-1893-4ec3-8749-605059716f83" />
<img width="200" height="600" alt="Screenshot_1752447206" src="https://github.com/user-attachments/assets/95ed166a-20cf-424e-8794-d07285a8553c" />
<img width="200" height="600" alt="Screenshot_1752447200" src="https://github.com/user-attachments/assets/88396f1a-1da4-439e-beb4-270533780054" />


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
