# EmotionMap

A location-based emotion sharing platform where users can pin their emotions on a map and explore how others feel around them. Built for the NTU campus community.

## Tech Stack

| Layer    | Technology                              |
|----------|-----------------------------------------|
| Frontend | Flutter 3 + Google Maps SDK             |
| Backend  | Spring Boot 3 · Java 17 · MyBatis-Plus |
| Database | MySQL 8                                 |
| Cache    | Redis 7                                 |
| Infra    | Docker Compose                          |

## Project Structure

```
EmotionMap/
├── src/main/java/            # Spring Boot Java source code
├── src/main/resources/
│   ├── application.yml       # App configuration
│   └── db/
│       ├── schema.sql        # Database schema
│       └── seed.sql          # Test seed data
├── pom.xml                   # Maven build file
├── Dockerfile                # Backend Docker build
├── frontend/                 # Flutter mobile app
│   ├── lib/                  # Dart source code
│   ├── android/              # Android platform files
│   ├── ios/                  # iOS platform files
│   └── pubspec.yaml
├── docker-compose.yml
└── README.md
```

## Prerequisites

- **Java 17** (or higher)
- **Maven 3.8+**
- **Flutter 3.x** with Dart SDK
- **Docker & Docker Compose**
- **Google Maps API Key** (for the Flutter frontend)

## Getting Started

### 1. Start Infrastructure

```bash
docker-compose up -d mysql redis
```

This starts MySQL 8 and Redis 7. The database schema and seed data are automatically loaded on first run.

### 2. Run Backend

**Option A — Local Maven:**

```bash
mvn spring-boot:run
```

**Option B — Docker:**

```bash
docker-compose up backend
```

The API will be available at `http://localhost:8080`.

### 3. Run Frontend

```bash
cd frontend
flutter pub get
flutter run
```

## API Endpoints

### Authentication

| Method | Path                 | Auth     | Description            |
|--------|----------------------|----------|------------------------|
| POST   | `/api/auth/register` | No       | Register a new user    |
| POST   | `/api/auth/login`    | No       | Login and get JWT      |

### Emotion Records

| Method | Path                     | Auth     | Description                                |
|--------|--------------------------|----------|--------------------------------------------|
| POST   | `/api/emotions`          | Optional | Submit an emotion record (anonymous OK)    |
| GET    | `/api/emotions/nearby`   | No       | Get emotions within radius (`lat`, `lng`, `radius`) |
| GET    | `/api/emotions/heatmap`  | No       | Get heatmap aggregation data               |
| GET    | `/api/emotions/trends`   | No       | Get emotion trends over time (`lat`, `lng`, `days`) |
| GET    | `/api/emotions/my`       | Yes      | Get current user's emotion history         |

### Comments

| Method | Path                              | Auth | Description              |
|--------|-----------------------------------|------|--------------------------|
| GET    | `/api/emotions/{id}/comments`     | No   | List comments for record |
| POST   | `/api/emotions/{id}/comments`     | Yes  | Add a comment            |

## Google Maps API Key Setup

1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a project (or select an existing one) and enable the **Maps SDK for Android** and **Maps SDK for iOS**.
3. Create an API key with appropriate restrictions.

### Android

Edit `frontend/android/app/src/main/AndroidManifest.xml` and add inside the `<application>` tag:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
```

### iOS

Edit `frontend/ios/Runner/AppDelegate.swift` and add:

```swift
GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

## Database Schema

The database contains three tables:

- **users** — registered user accounts
- **emotion_records** — emotion pins with type, location, optional note, and optional user association
- **comments** — user comments on emotion records

Supported emotion types: `HAPPY`, `SAD`, `ANGRY`, `ANXIOUS`, `CALM`.

See `src/main/resources/db/schema.sql` for the full DDL.

## Seed Data

Running `docker-compose up` for the first time automatically loads seed data including:

- 5 test users (`alice`, `bob`, `charlie`, `diana`, `edward`) — password: `password123`
- 60+ emotion records scattered across NTU campus locations
- 12 sample comments

This data is useful for development and demonstration purposes.
