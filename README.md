# TOMY - Real-Time Location Tracking App

## Overview

**TOMY** is a sophisticated Flutter-based real-time location tracking and member management application. It enables administrators to create and manage groups of drivers/members, monitor their real-time GPS locations, and track their speed metrics.

## Key Features

### 1. **Authentication & Role-Based Access**
- Admin login: Create new groups with exclusive 6-digit codes
- Member login: Join existing groups using group codes
- 4-second animated splash screen with neon theme

### 2. **Admin Dashboard**
- View pending member requests
- Accept or reject member join requests
- Monitor active members with real-time speed tracking
- Instant member removal capability
- Display exclusive group code

### 3. **Member Management**
- 10-second waiting period for admin approval
- Access to real-time map after approval
- Speed monitoring with visual alerts (red border for speeds >80 km/h)

### 4. **Real-Time GPS Tracking**
- High-accuracy location tracking using Geolocator
- Real-time speed calculation (m/s converted to km/h)
- Updates triggered every 2 meters of movement
- Dark-themed map using FlutterMap with CartoDB tiles

### 5. **TOMY AI Assistant**
- Intelligent chatbot for tracking insights
- Speed alerts and member statistics
- Pending member notifications
- Smart query responses

## UI Theme

- **Primary Color:** #BB86FC (Neon Purple)
- **Secondary Color:** #03DAC6 (Cyan)
- **Background:** #121212 (Dark Black)
- **Surface:** #1E1E1E (Dark Gray)
- **Language:** Arabic (RTL Support)

## Project Structure

```
lib/
├── main.dart                 # Main application entry point
├── screens/
│   ├── splash_screen.dart   # 4-second splash screen
│   ├── login_screen.dart    # Admin/Member login
│   ├── waiting_screen.dart  # Member approval waiting
│   ├── admin_dashboard.dart # Admin control panel
│   ├── map_screen.dart      # GPS tracking map
│   └── ai_screen.dart       # TOMY AI chatbot
└── models/
    └── member.dart          # Member data model
```

## Dependencies

```yaml
flutter_map: ^6.0.0        # Map rendering
latlong2: ^0.9.0           # Geographic coordinates
geolocator: ^9.0.0         # GPS and speed tracking
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode (for emulator)
- Geolocator permissions configured for your platform

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/tomasadel0012-wq/Tomy-app.git
   cd Tomy-app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### Platform Configuration

#### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

#### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location for tracking purposes.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs access to your location for real-time tracking.</string>
```

## Usage Flow

### Admin Workflow
1. Launch app → Splash screen (4 seconds)
2. Login with admin role
3. Receive exclusive group code (e.g., TOMY77)
4. View pending member requests
5. Accept/Reject members
6. Monitor active members' speeds
7. Use TOMY AI for insights

### Member Workflow
1. Launch app → Splash screen (4 seconds)
2. Login with member role and group code
3. Enter waiting queue (10 seconds simulation)
4. Admin approves request
5. Access real-time map with GPS tracking
6. View personal speed metrics

## Speed Monitoring

- **Green Status:** Speed ≤ 80 km/h
- **Red Alert:** Speed > 80 km/h (visual warning)
- **Updates:** Every 2 meters of movement
- **Accuracy:** High-precision GPS using Geolocator

## TOMY AI Features

The AI assistant provides intelligent responses for:
- Member status queries
- Speed analysis and reporting
- Pending member information
- Group management guidance

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/YourFeature`)
3. Commit changes (`git commit -m 'Add YourFeature'`)
4. Push to branch (`git push origin feature/YourFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues or questions, please open an issue on the GitHub repository.

## Roadmap

- [ ] Backend integration with Firebase/REST API
- [ ] Real database for member persistence
- [ ] Advanced analytics dashboard
- [ ] Push notifications for speed alerts
- [ ] Map route history
- [ ] Multi-language support
- [ ] Dark/Light theme toggle
- [ ] Offline mode support
