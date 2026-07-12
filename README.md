# ALU Launch 

[![Flutter Build](https://img.shields.io/badge/Flutter-v3.33.0+-02569B?logo=flutter&logoColor=white)](#)
[![Firebase Backend](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFCA28?logo=firebase&logoColor=black)](#)
[![Supabase Storage](https://img.shields.io/badge/Supabase-Object%20Storage-3ECF8E?logo=supabase&logoColor=white)](#)
[![State Management](https://img.shields.io/badge/State-Riverpod-764ABC?logo=dart&logoColor=white)](#)
[![Routing](https://img.shields.io/badge/Routing-GoRouter-01579B?logo=flutter&logoColor=white)](#)

ALU Launch is a high-performance, cross-platform mobile and web application designed to connect African Leadership University (ALU) students with early-stage startups for internship placements.

---

## Overview

Finding and managing structured academic internships (4-month terms required by the ALU curriculum) is historically a complex process. Startups need vetted junior talent, students need relevant credit-aligned opportunities, and institutional admins need quality control.

ALU Launch provides a central matchmaking portal that replaces manual spreadsheet pipelines. The platform features secure role partitioning (Student, Founder, Admin), interactive application timelines, a real-time recruiter chat system, verification queues, and robust data isolation.

---

## Features

### Student Module
* **Institution Domain Sign-up:**
* **Explore Opportunities:** 
* **Application Tracker:** 
* **Interactive Profile:** 
* **Bookmarks:** 

### Startup Founder Module
* **Company Profiles:** 
* **Job Listing Creator:** 
* **Applicant Pipelines:** 
* **Account Verification:** 

### ALU Administrator Module
* **Listing Verification Queue:**
* **Startup Verification Queue:** 

### Real-time Communication
* **Recruiter-Candidate Chats:** 
* **Badges & Counters:** 

---

## Demo Video

[![ALU Launch Walkthrough Video](https://img.shields.io/badge/Walkthrough%20Video-Play%20on%20YouTube-red?style=for-the-badge&logo=youtube)](https://youtu.be/YOUR_VIDEO_LINK)

---

## Architecture

ALU Launch uses a decoupled **Feature-First** architecture. This structures files by functional features rather than technical layers, making it highly modular and scalable.

```
lib/
├── core/                         # Core infrastructure & global definitions
│   ├── config/                   # Config parameters (Firebase & Supabase)
│   ├── constants/                # App paths and collections names
│   ├── navigation/               # GoRouter paths, guards, layouts
│   ├── providers/                # Infrastructure Riverpod providers
│   ├── services/                 # Firebase and Supabase adapters
│   └── theme/                    # Color styling, borders, and margins
└── features/                     # Independent business feature modules
    ├── admin/                    # Admin queues presentation layer
    ├── applications/             # Application pipeline state, repositories, views
    ├── authentication/           # Sign-in, sign-up forms, domain validation
    ├── internships/              # Opportunities list, details, search
    ├── messages/                 # Live messaging model, repository, chat screens
    ├── notifications/            # Notification tracking & settings UI
    ├── profile/                  # Core profile upload controllers
    ├── settings/                 # Preferences, account deletion triggers
    ├── startup/                  # Profile forms, listing creator views
    └── student/                  # Home feeds, explore tabs, bookmarks
```


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Author

* **Name:** [Innocent Tito Muvunyi]
---

## Acknowledgements

* African Leadership University Career Development Team
* Flutter and Dart Developer Community
* Google Firebase and Supabase Teams
