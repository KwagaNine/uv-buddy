# AGENTS.md

## Project Rules

- SwiftUI only
- Swift Package Manager only
- No Xcode project
- No Storyboards
- No UIKit
- `xtool` compatible
- Linux/Windows WSL friendly
- MVVM architecture
- Open-Meteo API boundary (mock-first)
- Minimalist premium UI

## Implementation Notes

- Keep all UI in `Features/*` with SwiftUI.
- Keep business logic out of views, place it in ViewModels.
- Services are protocol-driven and async/await-ready.
- For stage 1, use mock data only. Do not introduce real networking yet.
- Avoid Apple-only tooling assumptions in repository layout.
