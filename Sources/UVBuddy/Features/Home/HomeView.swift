import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
#if DEBUG
    @State private var debugPreset: DebugPreset = .moderate
#endif

    init(viewModel: HomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            viewModel.weather.uvLevel.backgroundGradient
                .ignoresSafeArea()
            backgroundGlows

            VStack(spacing: DesignSystem.Spacing.medium) {
                header

                CreatureView(uvLevel: viewModel.weather.uvLevel)
                    .transition(.scale.combined(with: .opacity))

                content

#if DEBUG
                debugControls
#endif
            }
            .padding(.horizontal, DesignSystem.Spacing.xLarge)
            .padding(.vertical, DesignSystem.Spacing.large)
        }
        .animation(.easeInOut(duration: 0.35), value: viewModel.state)
        .animation(.easeInOut(duration: 0.35), value: viewModel.weather.uvLevel.rawValue)
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading weather...")
                .tint(DesignSystem.Colors.accent)
                .foregroundStyle(DesignSystem.Colors.secondaryText)
                .frame(maxWidth: .infinity, minHeight: 200)

        case .loaded:
            UVStatusCard(
                uvIndexText: viewModel.uvIndexText,
                uvLevel: viewModel.weather.uvLevel,
                spfRecommendation: viewModel.spfRecommendation,
                temperatureText: viewModel.temperatureText,
                weatherSummary: viewModel.weatherSummary
            )
            .transition(.move(edge: .bottom).combined(with: .opacity))

        case .error(let message):
            VStack(spacing: DesignSystem.Spacing.small) {
                Text("Failed to load weather")
                    .font(DesignSystem.Typography.value)
                    .foregroundStyle(DesignSystem.Colors.primaryText)

                Text(message)
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.Colors.secondaryText)

                Button("Retry") {
                    Task {
                        await viewModel.load()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(DesignSystem.Colors.accent)
            }
            .frame(maxWidth: .infinity, minHeight: 220)
            .background(DesignSystem.glassBackground())
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.card, style: .continuous))
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    private var header: some View {
        VStack(spacing: DesignSystem.Spacing.xSmall) {
            Text("UV Buddy")
                .font(DesignSystem.Typography.title)
                .foregroundStyle(DesignSystem.Colors.primaryText)
            Text("Today's sun mood")
                .font(DesignSystem.Typography.subtitle)
                .foregroundStyle(DesignSystem.Colors.secondaryText)
        }
    }

    private var backgroundGlows: some View {
        ZStack {
            Circle()
                .fill(viewModel.weather.uvLevel.glowColor.opacity(0.18))
                .frame(width: 290, height: 290)
                .blur(radius: 38)
                .offset(x: -110, y: -290)

            Circle()
                .fill(viewModel.weather.uvLevel.glowColor.opacity(0.12))
                .frame(width: 240, height: 240)
                .blur(radius: 34)
                .offset(x: 130, y: -120)
        }
        .allowsHitTesting(false)
    }

#if DEBUG
    private var debugControls: some View {
        VStack(spacing: DesignSystem.Spacing.small) {
            Picker("Debug", selection: $debugPreset) {
                ForEach(DebugPreset.allCases) { preset in
                    Text(preset.title).tag(preset)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: debugPreset) { _, newValue in
                switch newValue {
                case .loading:
                    viewModel.applyDebugLoading()
                case .low:
                    viewModel.applyDebugMock(.mockLow)
                case .moderate:
                    viewModel.applyDebugMock(.mockModerate)
                case .high:
                    viewModel.applyDebugMock(.mockHigh)
                case .veryHigh:
                    viewModel.applyDebugMock(.mockVeryHigh)
                case .extreme:
                    viewModel.applyDebugMock(.mockExtreme)
                case .error:
                    viewModel.applyDebugError()
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.medium)
        .padding(.vertical, DesignSystem.Spacing.small)
        .background(DesignSystem.glassBackground(cornerRadius: DesignSystem.Radius.pill))
    }

    private enum DebugPreset: String, CaseIterable, Identifiable {
        case loading
        case low
        case moderate
        case high
        case veryHigh
        case extreme
        case error

        var id: String { rawValue }

        var title: String {
            switch self {
            case .loading: return "Loading"
            case .low: return "Low UV"
            case .moderate: return "Moderate UV"
            case .high: return "High UV"
            case .veryHigh: return "Very High UV"
            case .extreme: return "Extreme UV"
            case .error: return "Error"
            }
        }
    }
#endif
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(
            weatherService: MockWeatherService(),
            locationService: MockLocationService()
        )
    )
}
