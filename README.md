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
├── Sources
│   ├── UVBuddy
│   │   ├── UVBuddyApp.swift
│   │   ├── App
│   │   │   └── AppContainer.swift
│   │   ├── Features
│   │   │   └── Home
│   │   │       ├── HomeView.swift
│   │   │       ├── HomeViewModel.swift
│   │   │       └── Components
│   │   │           ├── CreatureView.swift
│   │   │           ├── PlaceholderCharacterView.swift
│   │   │           └── UVStatusCard.swift
│   │   ├── Models
│   │   │   └── UVLevel+UI.swift
│   │   └── Utilities
│   │       └── DesignSystem.swift
│   └── UVBuddyCore
│       ├── Models
│       │   ├── UVLevel.swift
│       │   └── WeatherData.swift
│       └── Services
│           ├── CacheService.swift
│           ├── LocationService.swift
│           ├── OpenMeteoResponse.swift
│           └── WeatherService.swift
└── Tests
    └── UVBuddyCoreTests
        └── UVBuddyCoreTests.swift
```

## Architecture

- `UVBuddyCore`: pure Swift module for models, service protocols/implementations, Open-Meteo mapping, and cache logic.
- `UVBuddy`: iOS SwiftUI app target that depends on `UVBuddyCore`.
- `UVBuddyCoreTests`: non-UI tests that can run on Linux/WSL.

## Open-Meteo integration

`OpenMeteoWeatherService` uses `URLSession` + `async/await` and decodes responses via `Codable`.
If API fails, app loads the last successful `WeatherData` from `UserDefaults` cache.

## Debug Preview Mode

For visual UI checks in DEBUG builds, `HomeView` includes a compact debug picker.
Available states:

- Loading
- Low UV
- Moderate UV
- High UV
- Very High UV
- Extreme UV
- Error

Debug controls are wrapped in `#if DEBUG` and are not included in release builds.

## Linux build note (SwiftUI vs Core)

`UVBuddy` app target uses SwiftUI and is intended for iOS/Apple SDK builds.
Linux cannot compile SwiftUI modules directly, so Linux/WSL validation is done on `UVBuddyCore`.

Use these commands on Linux/WSL:

```bash
swift build --product UVBuddyCore
swift test --filter UVBuddyCoreTests
```

Use these commands on macOS/iOS SDK environments:

```bash
swift build
swift run UVBuddy
```

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

3. Install Swift toolchain in WSL:

```bash
tar -xzf swift-*.tar.gz
sudo mv swift-*/ /opt/swift
echo 'export PATH=/opt/swift/usr/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
swift --version
```

4. Install `xtool` in WSL (use your standard install method), then verify:

```bash
xtool --version
```

5. Validate non-UI core logic:

```bash
swift build --product UVBuddyCore
swift test --filter UVBuddyCoreTests
```

## Notes

- No UIKit
- No Storyboards
- No widgets/onboarding/animations yet
- Placeholder premium-minimal UI only

## xtool iOS build and install

This package is compatible with iOS app builds via `xtool`:

- UI app target: `UVBuddy` (SwiftUI, iOS)
- Core target: `UVBuddyCore` (pure Swift)
- No Xcode project required

### Example bundle identifier

Use this bundle identifier for local/device builds:

- `com.kwaga.uvbuddy`

### Signing requirements

To install on a physical iPhone, you need:

1. Apple Developer account (free account works for basic personal testing, paid account recommended for stable provisioning).
2. A valid signing certificate available on the build machine.
3. A provisioning profile that matches:
   - bundle id: `com.kwaga.uvbuddy`
   - target device UDID (for development provisioning)
4. Team ID configured in your signing setup.

### Build and install flow (xtool)

1. Confirm toolchain and xtool:

```bash
swift --version
xtool --version
```

2. Validate package first:

```bash
swift package describe
swift build
```

3. Build for iOS with your xtool command/profile (example shape, adapt to your local xtool syntax):

```bash
xtool build ios --configuration release --bundle-id com.kwaga.uvbuddy
```

4. Install to connected iPhone (adapt to your local xtool syntax):

```bash
xtool install ios --bundle-id com.kwaga.uvbuddy
```

### First device launch checklist

1. iPhone is connected and trusted by host machine.
2. Correct provisioning profile includes this device.
3. Bundle id exactly matches profile: `com.kwaga.uvbuddy`.
4. App signed with matching certificate/team.
5. Build succeeds in release or debug configuration.
6. App installs successfully on device.
7. On first launch, if iOS blocks developer app, open:
   - Settings -> General -> VPN & Device Management -> Trust Developer.
8. Launch app and verify:
   - Home screen renders
   - Weather fetch works (or cache fallback works)
   - Debug picker appears only in DEBUG builds
