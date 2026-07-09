# Drivest Mobile App

**Flutter-based cross-platform mobile application** for the Drivest platform. This app allows users to browse cars, get AI-powered recommendations, compare vehicles, and manage their subscriptions.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Screens & Features](#screens--features)
- [API Integration](#api-integration)
- [Build & Deployment](#build--deployment)

---

## 🎯 Overview

The Drivest mobile app is a comprehensive Flutter application that provides:

- Car browsing and search functionality
- AI-powered car analysis and recommendations
- Car comparison tools
- User profile management
- Subscription management
- Real-time notifications
- Favorite/saved cars

---

## ✨ Features

### Core Features

- ✅ **Authentication**
  - Email/Password login
  - Google Sign-In
  - Firebase authentication
  - Password reset

- ✅ **Car Browsing**
  - Browse car listings
  - Search and filter cars
  - View car details
  - Featured cars section
  - Top brands section

- ✅ **AI Features**
  - AI chat assistant
  - Car recommendations
  - Price analysis
  - Trade analysis

- ✅ **Car Comparison**
  - Compare multiple cars
  - Side-by-side comparison
  - Detailed specifications

- ✅ **User Features**
  - Profile management
  - Edit profile
  - Saved/favorite cars
  - Payment management
  - Invoice history

- ✅ **Additional Features**
  - Real-time notifications
  - Deep linking support
  - Image carousel
  - Push notifications

---

## 🛠️ Tech Stack

- **Framework:** Flutter 3.9.2+
- **Language:** Dart
- **State Management:** Provider, GetX
- **HTTP Client:** http package
- **Local Storage:** SharedPreferences
- **Authentication:** Google Sign-In, Firebase
- **Image Handling:** Image Picker
- **UI Components:** Material Design, Custom Widgets
- **Deep Linking:** App Links

---

## 📦 Installation

### Prerequisites

- Flutter SDK >= 3.9.2
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (IDE)

### Setup Steps

1. **Navigate to the directory:**
```bash
cd Drivest_final2
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Configure API endpoints:**
   - Update API base URL in service files
   - Configure Firebase (if using Firebase auth)

4. **Run the app:**
```bash
# For Android
flutter run

# For iOS (macOS only)
flutter run -d ios

# For specific device
flutter devices  # List available devices
flutter run -d <device-id>
```

---

## 📁 Project Structure

```
Drivest_final2/
├── lib/
│   ├── app/
│   │   ├── app.dart              # Main app widget
│   │   └── asset_paths.dart     # Asset path constants
│   ├── core/
│   │   └── services/
│   │       ├── network/
│   │       │   ├── car_provider.dart
│   │       │   ├── user_provider.dart
│   │       │   └── trade_analysis_api.dart
│   │       └── ...
│   ├── features/
│   │   ├── auth/
│   │   │   ├── screen/
│   │   │   │   ├── sign_in_screen.dart
│   │   │   │   ├── sign_up_screen.dart
│   │   │   │   └── forgot_password_screen.dart
│   │   │   └── services/
│   │   │       └── auth_service.dart
│   │   ├── notifications/
│   │   │   └── services/
│   │   │       └── notification_count_provider.dart
│   │   ├── onBoarding/
│   │   │   └── ui/screen/
│   │   │       └── splash_screen.dart
│   │   └── settings/
│   │       └── screen/
│   │           └── setting_screen.dart
│   ├── home/
│   │   ├── combined_home_page.dart
│   │   ├── controller/
│   │   │   └── saved_car_controller.dart
│   │   ├── model/
│   │   │   ├── brand_model.dart
│   │   │   └── car_model.dart
│   │   ├── pages/
│   │   │   ├── ai_chat_page.dart
│   │   │   ├── car_details_screen.dart
│   │   │   ├── compare_page.dart
│   │   │   ├── compare_selection_page.dart
│   │   │   ├── featured_car_list_page.dart
│   │   │   ├── filter_page.dart
│   │   │   ├── filtered_car_page.dart
│   │   │   ├── payment_page.dart
│   │   │   ├── saved_page.dart
│   │   │   ├── top_brands_page.dart
│   │   │   └── profile/
│   │   │       ├── profile_page.dart
│   │   │       ├── edit_profile.dart
│   │   │       ├── my_profile_page.dart
│   │   │       ├── invoice_screen.dart
│   │   │       ├── help_&_feedback_page.dart
│   │   │       ├── privacy_policy_screen.dart
│   │   │       ├── refund_policy.dart
│   │   │       └── teams_condition_screen.dart
│   │   └── widgets/
│   │       ├── ai_suggestion_card.dart
│   │       ├── car_image_carousel_slider.dart
│   │       ├── category_buttons.dart
│   │       ├── featured_car_section.dart
│   │       ├── recommended_section.dart
│   │       ├── search_and_filter.dart
│   │       ├── top_brands_section.dart
│   │       └── trade_analysis_widget.dart
│   ├── widgets/                 # Global widgets
│   ├── main.dart                # App entry point
│   └── main_bottom_nav_screen.dart  # Bottom navigation
├── assets/
│   └── images/                  # App images and icons
├── android/                     # Android-specific files
├── ios/                         # iOS-specific files
├── pubspec.yaml                 # Dependencies
└── README.md
```

---

## 📱 Screens & Features

### Main Navigation

The app uses a bottom navigation bar with 5 main sections:

1. **Home** - Browse cars, featured listings, top brands
2. **Compare** - Select and compare cars
3. **Saved** - Favorite/saved cars
4. **AI Chat** - AI-powered car recommendations
5. **Profile** - User profile and settings

### Key Screens

#### Home Screen (`combined_home_page.dart`)
- Featured car listings
- Top brands section
- Search and filter functionality
- Recommended cars
- AI suggestions

#### Car Details Screen (`car_details_screen.dart`)
- Car images carousel
- Detailed specifications
- Price information
- Favorite button
- Trade analysis

#### Compare Screen (`compare_selection_page.dart`, `compare_page.dart`)
- Select cars to compare
- Side-by-side comparison
- Detailed specifications comparison

#### AI Chat Screen (`ai_chat_page.dart`)
- Interactive AI chat interface
- Car recommendations
- Budget-based suggestions
- Needs-based filtering

#### Profile Screen (`profile_page.dart`)
- User information
- Edit profile
- Payment management
- Invoice history
- Help & feedback
- Settings

---

## 🔌 API Integration

### Base Configuration

The app connects to the backend API. Update the base URL in service files:

```dart
const String API_BASE_URL = 'https://api.drivestai.com';
```

### Authentication

```dart
// Sign in
final result = await AuthService().signIn(
  email: email,
  password: password,
  remember: rememberMe,
);

// Sign up
final result = await AuthService().signUp(
  email: email,
  password: password,
  name: name,
);

// Google Sign-In
final result = await AuthService().signInWithGoogle();
```

### API Services

#### Car Service
- `searchCars()` - Search cars
- `getCarDetails()` - Get car details
- `compareCars()` - Compare cars

#### User Service
- `getUserProfile()` - Get user profile
- `updateProfile()` - Update profile
- `getFavorites()` - Get saved cars

#### AI Service
- `getAISuggestions()` - Get AI recommendations
- `analyzeCar()` - Analyze car data

---

## 🎨 UI Components

### Custom Widgets

- **CarImageCarouselSlider** - Image carousel for car photos
- **FeaturedCarSection** - Featured cars display
- **TopBrandsSection** - Top brands grid
- **SearchAndFilter** - Search and filter bar
- **AISuggestionCard** - AI recommendation cards
- **TradeAnalysisWidget** - Trade analysis display

### Styling

- Material Design 3
- Custom color scheme (Primary: `#015093`)
- Responsive layouts
- Custom bottom navigation bar

---

## 🔗 Deep Linking

The app supports deep linking:

```
drivest://ride/{carId}
drivest:///ride/{carId}
```

Deep links are handled in `main.dart` using the `app_links` package.

---

## 🚀 Build & Deployment

### Android Build

1. **Generate keystore:**
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. **Configure `android/key.properties`:**
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>
```

3. **Build APK:**
```bash
flutter build apk --release
```

4. **Build App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```

### iOS Build

1. **Open Xcode:**
```bash
open ios/Runner.xcworkspace
```

2. **Configure signing:**
   - Select your team in Xcode
   - Configure bundle identifier

3. **Build:**
```bash
flutter build ios --release
```

### Build Configuration

Update `pubspec.yaml` for app version:
```yaml
version: 1.0.0+1  # version+buildNumber
```

---

## 📦 Dependencies

Key dependencies in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.7.2                    # State management
  provider: ^6.1.5+1              # State management
  http: ^1.5.0                    # HTTP client
  shared_preferences: ^2.5.3      # Local storage
  google_sign_in: ^6.2.1         # Google authentication
  image_picker: ^1.2.0            # Image selection
  carousel_slider: ^5.1.1         # Image carousel
  flutter_svg: ^2.2.1            # SVG support
  app_links: ^6.4.1               # Deep linking
  webview_flutter: ^4.13.0        # WebView
  url_launcher: ^6.3.2            # URL launcher
```

---

## 🔐 Environment Configuration

### Android

Update `android/app/build.gradle`:
- Application ID
- Version code/name
- Signing configuration

### iOS

Update `ios/Runner/Info.plist`:
- Bundle identifier
- App name
- Permissions

---

## 🐛 Troubleshooting

### Common Issues

1. **Build errors:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **iOS build issues:**
   - Run `pod install` in `ios/` directory
   - Clean Xcode build folder

3. **Android build issues:**
   - Check `android/local.properties` for SDK path
   - Verify Gradle version

4. **API connection issues:**
   - Check network permissions in AndroidManifest.xml
   - Verify API base URL
   - Check CORS settings on backend

---

## 📝 Notes

- The app uses Provider for state management
- GetX is used for navigation and dependency injection
- Deep linking is configured for car details
- Image caching is handled automatically
- Push notifications require Firebase setup

---

## 🔗 Related Documentation

- [Backend API Documentation](../drivest-ai/README.md)
- [AI Service Documentation](../Car-Price-Analysis-and-Buy-Recommendations/README.md)
- [Main Project README](../README.md)

---

**Built with Flutter & Dart**
