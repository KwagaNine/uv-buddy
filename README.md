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

## xtool workflow for iPhone

`Package.swift` is compatible with this workflow:

- iOS app target: `UVBuddy` (SwiftUI executable target)
- shared core target: `UVBuddyCore`
- Linux-safe test target: `UVBuddyCoreTests`

Bundle ID for device build/install:

- `com.kwaga.uvbuddy`

App display name target:

- `UV Buddy`

### 1) install xtool

Install `xtool` using your preferred official method, then verify:

```bash
xtool --version
```

### 2) xtool setup

Initialize local xtool environment/workspace settings:

```bash
xtool setup
```

### 3) xtool auth

Authenticate xtool with your Apple developer context:

```bash
xtool auth login
```

### 4) xtool sdk

Install/select required Apple SDK artifacts used by xtool:

```bash
xtool sdk list
xtool sdk install ios
```

### 5) xtool devices

Connect iPhone and confirm it is visible:

```bash
xtool devices
```

### 6) xtool dev/build

First validate package and tests, then build app:

```bash
swift build --product UVBuddyCore
swift test --filter UVBuddyCoreTests
xtool build ios --target UVBuddy --bundle-id com.kwaga.uvbuddy --app-name "UV Buddy"
```

### 7) xtool install

Install generated app to connected iPhone:

```bash
xtool install ios --bundle-id com.kwaga.uvbuddy
```

### 8) xtool launch

Launch installed app on device:

```bash
xtool launch ios --bundle-id com.kwaga.uvbuddy
```

### 9) troubleshooting

If install/launch fails, check:

1. Device is trusted and unlocked.
2. Provisioning profile includes device UDID.
3. Signing certificate, Team ID, and bundle id match (`com.kwaga.uvbuddy`).
4. No secrets/certificates/profiles are committed to repo.
5. Core tests pass before iOS build:
   - `swift test --filter UVBuddyCoreTests`

### First iPhone run checklist

1. `xtool auth login` completed.
2. iOS SDK installed via xtool.
3. Device detected by `xtool devices`.
4. Build succeeds for target `UVBuddy`.
5. App installs with bundle id `com.kwaga.uvbuddy`.
6. On first launch, trust developer profile in iOS settings if prompted.
7. Verify app opens to Home screen and weather load path works.
