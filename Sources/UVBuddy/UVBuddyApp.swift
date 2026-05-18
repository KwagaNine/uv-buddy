import SwiftUI

@main
struct UVBuddyApp: App {
    private let container = AppContainer.live

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel(
                weatherService: container.weatherService,
                locationService: container.locationService
            ))
        }
    }
}
