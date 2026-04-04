# Gym Cheloper - Fitness Training App

A comprehensive **fitness training application** built with Flutter that helps users track workouts, manage nutrition, monitor progress, and achieve their fitness goals through personalized training and meal plans.

<p align="center">
  <strong>Workout Tracking</strong> • 
  <strong>Meal Planning</strong> • 
  <strong>Weight Tracking</strong> • 
  <strong>Macro Management</strong> • 
  <strong>Progress Analytics</strong>
</p>

---

## 📱 Features

### 🏋️ Workout Management
- **Custom Training Plans** - Create and manage personalized workout routines
- **Exercise Library** - Browse and add exercises to your training days
- **Set/Rep/Weight Tracking** - Log detailed exercise metrics
- **Exercise History** - View past workouts and track progress over time
- **Rest Timer** - Built-in timer between exercise sets
- **Training Day Management** - Add, pin, and organize training days
- **Exercise Swap** - Flexibility to modify workouts on the fly

### 🥗 Nutrition & Meal Planning
- **Daily Meal Tracking** - Log meals with calorie and macro breakdown
- **Macro Goals** - Track carbohydrates, protein, fat, and calories
- **Water Intake Monitoring** - Daily hydration tracking
- **Weekly Calendar View** - Navigate and manage meals by date
- **Calorie Streak Counter** - Gamified tracking with fire icon
- **Custom Meal Types** - Default and custom meal categorization
- **Shopping List** - Supermarket list for meal planning

### 📊 Weight & Progress Tracking
- **Weight Chart** - Visual line chart showing weight trends (powered by fl_chart)
- **Body Measurements** - Track body fat, waist, neck, arm, calves, and thigh measurements
- **Progress Analytics** - Visual progress indicators with circular and linear progress bars

### 🔐 Authentication & Onboarding
- **Multiple Sign-In Options** - Email, Google, and Apple authentication
- **Password Recovery** - OTP-based password reset flow
- **Fitness Questionnaire** - 5-screen onboarding to understand user goals
- **Profile Setup** - Collect name, gender, age, height, and weight
- **Macro Calculation** - Automatic calorie and macro goal calculation (Imperial/Metric units)
- **Language Selection** - Choose between English and Spanish during onboarding

### 💳 Subscription & Payments
- **Subscription Plans** - Monthly and 3-month pricing tiers
- **Free Trial** - 5-day free trial option
- **Promo Codes** - Redeem coupon codes for discounts
- **Stripe Integration** - Secure payment processing
- **Card Management** - Save and manage payment methods

### ⚙️ Settings & Profile
- **Profile Management** - Edit personal information and profile image
- **Password Change** - Update account credentials
- **Multi-Language Support** - Switch between English and Spanish
- **Privacy & Terms** - Access to Privacy Policy and Terms of Service
- **Account Deletion** - Option to delete account

---

## 🏗️ Architecture

### State Management
- **GetX** - Primary state management, dependency injection, and navigation
- Reactive programming with `.obs` (observable) variables
- `Obx` widgets for reactive UI updates
- Controller-per-screen pattern for clean separation

### Routing
- **GoRouter** - Declarative routing with named routes
- Structured navigation flow for all app features
- Route guards and redirect logic for authentication states

### API Integration
- **RESTful API** - Backend at `https://fitness-training-be.vercel.app/api/v1`
- Centralized `ApiClient` with Bearer token authentication
- Support for GET, POST, PUT, PATCH, DELETE, and multipart file uploads
- 30-second timeout with error handling and response parsing

### Project Structure
```
lib/
├── controller/              # GetX controllers
│   └── auth/               # Authentication controllers
├── daily_marcos/           # Daily macro calculations
├── global widget/          # Reusable UI components
├── helpers/                # Utility helpers (DI, prefs, toast, image picker)
├── models/                 # Data models (Language, Subscription, etc.)
├── routes/                 # GoRouter configuration
├── services/               # API clients and services
├── themes/                 # Light and dark theme configurations
├── utils/                  # Constants, colors, dimensions, styles, assets
└── viwes/                  # All screens and widgets
    ├── screens/            # Main app screens
    │   ├── auths/          # Authentication flow
    │   ├── navbar/         # Bottom navigation
    │   ├── question/       # Fitness questionnaire
    │   └── workout/        # Workout, meal, weight tracking screens
    └── workout/            # Feature-specific screens
        ├── exercise/       # Exercise management
        ├── meal_plan/      # Meal planning
        ├── weight_tracking/# Weight and measurements
        ├── settings/       # Settings screens
        ├── subscription_packages/ # Subscription flow
        └── stripe_payment/ # Payment integration
```

---

## 📦 Dependencies

### Core
- **get** (4.6.6) - State management, DI, and navigation
- **go_router** (16.1.0) - Declarative routing
- **http** - REST API communication
- **shared_preferences** - Local data persistence

### UI Components
- **flutter_screenutil** (5.9.3) - Responsive UI (design: 393x852)
- **flutter_svg** (2.0.10) - SVG rendering
- **percent_indicator** (4.2.2) - Circular/linear progress indicators
- **carousel_slider** (5.0.0) - Onboarding carousel
- **pin_code_fields** (8.0.1) - OTP input fields
- **flutter_slidable** (3.1.2) - Swipe actions on lists
- **shimmer** (3.0.0) - Loading skeleton animations
- **cached_network_image** (3.4.1) - Cached network images
- **flutter_spinkit** (5.2.1) - Loading spinners
- **flutter_animate** (4.3.0) - Animation utilities
- **smooth_page_indicator** (1.2.0+3) - Page indicators
- **flutter_widget_from_html** (0.15.2) - HTML rendering
- **country_flags** (2.0.0) - Country flag display
- **cupertino_icons** (1.0.8) - iOS-style icons

### Charts & Media
- **fl_chart** - Charts and graphs (weight tracking)
- **video_player** (2.5.0) - Video playback
- **image_picker** - Camera/gallery access

### Payments & Notifications
- **flutter_stripe** - Stripe payment processing
- **fluttertoast** - Toast notifications
- **intl** - Internationalization and date formatting

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK (>=3.8.1)
- Android Studio / VS Code with Flutter extensions
- A code editor (VS Code recommended)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd gymcheloper
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   - Update API base URL in `lib/services/api_constants.dart` if needed
   - Configure Stripe publishable key in `lib/utils/app_constant.dart`

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android:**
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 🎨 Theming

The app supports both light and dark themes:
- **Primary Color:** `#F70300` (Red)
- **Light Theme:** White scaffold with custom text styles
- **Dark Theme:** Configured but not actively used (can be enabled)

Theme files are located in `lib/themes/` with centralized color definitions in `lib/utils/app_colors.dart`.

---

## 🌍 Localization

The app supports **English** and **Spanish** with JSON-based translations stored in `assets/language/`. Users can switch languages during onboarding or from settings.

---

## 🔑 Key Features Implementation

### Authentication Flow
```
Splash → (has token?) → Home (CustomNavBar)
                      → Onboarding → Fitness Questions (5 screens) 
                      → Sign In/Sign Up → Basic Info → Macro Calculation 
                      → Congratulations → Home
```

### Subscription Flow
```
Subscription Packages → Choose Card Screen → Pay Now (Stripe) → Success
                      → Redeem Code → Code Validation
                      → Free Trial → Home (clears navigation stack)
```

### Workout Tracking
- Training days with add/pin/delete functionality
- Exercise completion checkboxes
- Sets/reps/weight logging
- Rest timer popup between sets
- Exercise history viewing

### Meal Planning
- Weekly date selector with calendar navigation
- Daily/weekly calorie tracking with circular progress
- Macro breakdown (Carbs, Protein, Fat) with progress bars
- Water intake tracking with +/- controls
- Meal management (add, pin, delete, expand)
- Calorie streak counter with fire icon

---

## 📱 Screens Overview

### Authentication
- Splash Screen
- Onboarding Screen (with language toggle)
- Fitness Questionnaire (5 screens)
- Select Screen (auth provider choice)
- Sign In / Sign Up Screens
- Forget Password / OTP Verification / Reset Password
- Basic Info Screen
- Calculate Macros Screen
- Congratulations Screen

### Main App (Bottom Navigation)
1. **Workout Screen** - Training days and exercises
2. **Meal Plan Screen** - Weekly meal tracking and macros
3. **Weight Tracking Screen** - Weight chart and body measurements
4. **Settings** - Profile, preferences, legal, account management

### Additional Screens
- Exercise Management
- Subscription Packages
- Choose Your Card
- Subscription Code (Redeem)
- Add Coupon
- Settings Profile
- Privacy Policy / Terms of Service
- Custom Training Plans

---

## 🛠️ Development

### Code Style
The project follows Flutter best practices with:
- Feature-based folder structure
- Controller-per-screen pattern (GetX)
- Centralized API client
- Reusable global widgets
- Consistent naming conventions

### Responsive Design
All UI uses `flutter_screenutil` based on 393x852 design specifications for consistent rendering across different screen sizes.

### API Endpoints
All API endpoints are defined in `lib/services/api_constants.dart`:
- Users authentication and profile
- Meals and nutrition
- Workouts and exercises
- Macros calculations
- Progress bars and tracking
- Subscriptions and coupons
- Terms, Privacy, and About content

---

## 📝 TODO / Future Enhancements

- [ ] Implement Apple/Google OAuth (placeholders exist)
- [ ] Complete dark theme integration
- [ ] Add more exercise variations
- [ ] Social features and community
- [ ] Workout plan templates
- [ ] Integration with fitness wearables
- [ ] Export progress reports
- [ ] Push notifications for workout reminders

---

## 📄 License

This project is private and not published to pub.dev.

---

## 👨‍💻 Support

For issues, questions, or contributions, please refer to the project repository.

---

**Built with ❤️ using Flutter**
