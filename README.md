# 🚶‍♂️ FalloutPipBoy Watch App

iOS Apple Watch application that brings three unique watch face themes to your wrist: Fallout Theme, Rotating Seconds, and Back to the Future Theme. 

## 📸 Screenshots

<div align="center">
  <img src="./ScreenShoots/demo.gif" width="30%" />
  <img src="./ScreenShoots/demo1.gif" width="30%" />
</div>

## 🎨 Features

Fallout Theme: Inspired by the iconic Pip-Boy from the Fallout series, this watch face features a retro-futuristic green monochrome display with animated elements mimicking the Pip-Boy interface. 
Perfect for fans of the post-apocalyptic RPG.

Rotating Seconds: A minimalist and dynamic watch face where the seconds hand rotates smoothly around a sleek, modern design. 
Ideal for those who prefer a clean, functional aesthetic with a focus on timekeeping precision.

Back to the Future Theme: Channel the spirit of the DeLorean with this theme, featuring a digital flux capacitor-inspired display and time-travel animations. 
A nostalgic tribute to the classic sci-fi movie trilogy.

HealthKit Integration: Seamlessly integrates with HealthKit to display health and fitness data (e.g., steps, heart rate) in the context of each theme.

## 🛠 Tech Stack

Swift 5.0+

SwiftUI (UI, animations)

Swift Concurrency (async/await)

watchOS & WatchKit (Apple Watch companion)

HealthKit (heart rate, blood oxygen on watch)

## 🏗 Project Structure
```bash
FalloutPipBoy/
 Sources/
 ├── App/                       # Apple Watch companion app
 │
 ├── Core/
 │    ├── Services/             # HealthKit
 │    └── Utils/                # Helpers, Extensions
 │
 ├── Features/
 │    ├── Root/                 # Main Tab View
 │    └── BackToTheFeature/     # Back to the Future theme
 │    └── PipBoy/               # Fallout theme, preferences
 │    └── RotatingSeconds/      # Rotating Seconds theme
 │
 ├── Resources/
 │    ├── Assets.xcassets       # Image assets for watch faces
 │    └── Fonts                 # Custom fonts for themed displays
 │
 └── Tests/
      ├── UnitTests/            # Unit tests for core functionality
      └── UITests/              # UI tests for watch face rendering
```
## 🚀 Installation

###Prerequisites

Xcode 16 or later

An Apple Watch (watchOS 10 or later)

iOS 17 or later for the companion app

###Steps

Clone the repository
```bash
git clone https://github.com/karkadi/FalloutPipBoy.git
cd FalloutPipBoy
```
Open in Xcode 16+.

Enable required Capabilities:

Workout processing

HealthKit


## 📋 Roadmap

Add complications for each theme (e.g., step count, heart rate, weather).

Support for additional watch face animations and transitions.

Improve accessibility features (e.g., high-contrast modes).

Introduce new themes based on user feedback (e.g., Star Wars, Cyberpunk).

Add support for dynamic complications based on calendar events or notifications.

Optimize performance for older Apple Watch models.

Implement iCloud syncing for user preferences across devices.

## 🤝 Contribution

Pull requests are welcome! For major changes, please open an issue first to discuss what you’d like to change.

## 📄 License

This project is licensed under the MIT License.
See [LICENSE](LICENSE) for details.
