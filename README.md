# ALU Launch 

ALU Launch is a high-performance, cross-platform mobile and web application designed to connect African Leadership University (ALU) students with early-stage startups for internship placements.

---

## Architecture


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

* **Name:** Innocent Tito Muvunyi
