# FlashGo - Premium Flashlight App

A beautiful, feature-rich flashlight application built with Flutter that turns your device into a powerful light source.

## ✨ Features

### 🔦 Flashlight Mode
- Toggle your device's LED flash on/off with a single tap
- Bright, reliable flashlight functionality
- Beautiful pulsing animation when active

### 📱 Screen Light Mode
- Transform your entire screen into a customizable light source
- **8 Premium Color Options:**
  - White (Classic)
  - Red (Night Vision)
  - Cyan (Cool Tone)
  - Yellow (Warm Tone)
  - Mint (Soft Light)
  - Purple (Ambient)
  - Pink (Gentle)
  - Green (Nature)

### ⚡ Strobe Effect
- Attention-grabbing strobe functionality
- **Adjustable Speed:** 1 Hz to 20 Hz
- Perfect for emergencies or signaling
- Smooth speed control with real-time updates

## 🎨 Design Highlights

- **Premium Dark Theme** with gradient backgrounds
- **Glassmorphism UI** with frosted glass effects
- **Smooth Animations** including pulse effects and transitions
- **Modern Typography** using Google Fonts (Poppins)
- **Intuitive Controls** with visual feedback
- **Gradient Accents** throughout the interface

## 🛠️ Technical Stack

- **Framework:** Flutter 3.6+
- **Packages:**
  - `torch_light` - Hardware flashlight control
  - `google_fonts` - Premium typography
- **Architecture:** Stateful widgets with animation controllers

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS (with camera permissions)
- ⚠️ Web/Desktop (Screen light only - no hardware flash)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.6.0 or higher
- Android Studio / Xcode for mobile development

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd flashgo
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📋 Permissions

### Android
The app requires the following permissions (already configured):
- `CAMERA` - For flashlight access
- `FLASHLIGHT` - For LED flash control

### iOS
Add to `Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to control the flashlight</string>
```

## 🎯 Key Features Breakdown

### Mode Selector
Three distinct modes accessible via elegant toggle buttons:
1. **Flashlight** - Hardware LED flash
2. **Screen** - Full-screen color light
3. **Strobe** - Flashing effect with speed control

### Color Picker
- 8 carefully selected colors
- Visual selection with check marks
- Glow effects on selected colors
- Instant preview

### Strobe Controls
- Slider-based speed adjustment
- Real-time frequency display (Hz)
- Range: 1-20 flashes per second
- Smooth transitions between speeds

## 🎨 UI Components

- **Gradient Buttons** with smooth hover effects
- **Glassmorphic Cards** for feature displays
- **Animated Main Button** with scale and pulse effects
- **Custom Sliders** with gradient tracks
- **Feature Cards** showcasing app capabilities

## 🔧 Customization

The app is designed to be easily customizable:
- Modify colors in the `_colorOptions` list
- Adjust strobe speed range (currently 1-20 Hz)
- Customize animations in the `AnimationController`
- Update gradient colors for different themes

## 📸 Screenshots

The app features:
- Clean, modern interface
- Smooth animations
- Intuitive controls
- Premium visual design

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Developer

Built with ❤️ using Flutter

---

**Note:** This is a utility app designed to showcase Flutter development skills while providing practical functionality. The flashlight feature requires hardware support and may not work on all devices.
