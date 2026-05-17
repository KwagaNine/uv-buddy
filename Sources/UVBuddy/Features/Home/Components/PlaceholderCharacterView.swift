import SwiftUI

struct PlaceholderCharacterView: View {
    var character: String

    var body: some View {
        Text(character)
            .font(DesignSystem.Typography.character)
            .accessibilityLabel("Placeholder character")
    }
}
