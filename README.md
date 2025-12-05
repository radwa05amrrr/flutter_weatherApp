# 🌤️ Flutter Weather App
A clean and modern Flutter application that displays real-time weather information using the **OpenWeatherMap Current Weather API**.
The app includes multiple screens, favorites management, and user temperature unit preferences.

---

## 🚀 Key Features

### Search

* Search for any city
* Fetch real-time weather data
* Navigate to detailed weather view

### Weather Details

* City name
* Temperature in °C / °F
* Weather description
* Feels like
* Humidity
* Wind speed
* Sunrise & Sunset
* Add/remove from favorites

### Favorites

* View list of saved cities
* Tap any city for full weather details
* Stored locally with **SharedPreferences**

### Settings

* Switch between **Celsius** and **Fahrenheit**
* Instant UI updates using **Provider**


## 📁 Project Structure

```
lib/
  config/
    api_config.dart             # Your real API key (ignored in Git)
    api_config_example.dart     # Safe example pushed to GitHub
  models/
    weather_model.dart
    settings_model.dart
  services/
    api_service.dart
  pages/
    home_page.dart
    weather_details_page.dart
    favorites_page.dart
    settings_page.dart
  main.dart
```



##  API Key Setup

1. Copy the example config:

```
lib/config/api_config_example.dart → lib/config/api_config.dart
```

2. Add your actual API key:

```dart
const String openWeatherApiKey = 'YOUR_REAL_API_KEY';
```

 `api_config.dart` is included in `.gitignore` to keep the key private.



## Run the App

Install packages:

```bash
flutter pub get
```

Run on device/emulator:

```bash
flutter run
```

Build release APK:

```bash
flutter build apk --release
```

APK output:

```
build/app/outputs/flutter-apk/app-release.apk
```



## Tech Stack

* Flutter 3.x
* Dart
* Provider (state management)
* HTTP API requests
* SharedPreferences
* OpenWeatherMap API




