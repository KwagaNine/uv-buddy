# UV Buddy

Minimal MVP foundation for a SwiftUI UV/weather app built with Swift Package Manager only.

## Goals

- SwiftUI-only UI layer
- SPM-only project layout (no `.xcodeproj`)
- MVVM architecture
- `xtool`-friendly structure
- Linux/Windows WSL-friendly repository layout
- Open-Meteo-ready service boundary

## Project Structure

```text
.
├── Package.swift
├── README.md
├── AGENTS.md
└── Sources
    └── UVBuddy
        ├── UVBuddyApp.swift
        ├── Features
        │   └── Home
        │       ├── HomeView.swift
        │       ├── HomeViewModel.swift
        │       └── Components
        ├── Services
        │   ├── LocationService.swift
        │   └── WeatherService.swift
        ├── Models
        │   ├── UVLevel.swift
        │   └── WeatherData.swift
        ├── Utilities
        │   └── DesignSystem.swift
        └── App
            └── AppContainer.swift
```

## Architecture (MVP)

- `Features/Home`: View + ViewModel for the main screen
- `Services`: Protocol-driven service layer (`WeatherService`, `LocationService`) with mock implementations
- `Models`: Domain models (`WeatherData`, `UVLevel`)
- `Utilities`: Shared UI tokens (`DesignSystem`)
- `App`: Dependency container to keep composition centralized

## Open-Meteo integration

`OpenMeteoWeatherService` uses `URLSession` + `async/await` and decodes response via `Codable`.
If API fails, app loads the last successful `WeatherData` from `UserDefaults` cache.

## Debug Preview Mode

For visual UI checks on a real iPhone in DEBUG builds, `HomeView` includes a compact debug picker.
Available states:

- Loading
- Low UV
- Moderate UV
- High UV
- Very High UV
- Extreme UV
- Error

How to use:

1. Run app in DEBUG.
2. Open Home screen.
3. Use `Debug` picker at the bottom of the screen.
4. Switch states and verify UV text, temperature, weather summary, SPF recommendation, and error rendering.

Debug controls are wrapped in `#if DEBUG` and are not included in release builds.

## Run (macOS)

```bash
swift run UVBuddy
```

## Build (including Linux/WSL validation)

```bash
swift build
```

This command validates package structure and cross-platform friendliness at the SwiftPM level.

## Windows + WSL setup

Use this flow when developing on Windows with WSL (Ubuntu).

1. Install WSL and Ubuntu (PowerShell as Administrator):

```powershell
wsl --install -d Ubuntu
```

2. Open Ubuntu and install base packages:

```bash
sudo apt update
sudo apt install -y curl git clang libicu-dev libsqlite3-dev libpython3-dev libncurses-dev libxml2-dev libcurl4-openssl-dev libedit-dev libz3-dev pkg-config tzdata unzip
```

3. Install Swift toolchain in WSL.
Download the latest Ubuntu toolchain from Swift.org, then:

```bash
tar -xzf swift-*.tar.gz
sudo mv swift-*/ /opt/swift
echo 'export PATH=/opt/swift/usr/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
swift --version
```

4. Install `xtool` in WSL (choose your preferred method from xtool docs), then verify:

```bash
xtool --version
```

5. Clone/open this project inside WSL filesystem and run checks:

```bash
swift package describe
swift build
swift build -c release
```

6. Optional run command:

```bash
swift run UVBuddy
```

## Notes

- No UIKit
- No Storyboards
- No widgets/onboarding/animations yet
- Placeholder premium-minimal UI only
