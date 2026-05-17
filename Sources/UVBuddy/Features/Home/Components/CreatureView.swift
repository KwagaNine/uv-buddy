import SwiftUI
import UVBuddyCore

@MainActor
struct CreatureView: View {
    let uvLevel: UVLevel

    @State private var isBreathing = false
    @State private var isBlinking = false
    @State private var glowPulse = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                shadow
                    .offset(y: 56)

                bodyShape
                    .scaleEffect(isBreathing ? 1.03 : 0.97)
                    .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: isBreathing)

                arms
                eyes
                orb
            }
            .frame(width: 210, height: 220)
        }
        .onAppear {
            isBreathing = true
            glowPulse = true
        }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(2.7))
                withAnimation(.easeInOut(duration: 0.11)) {
                    isBlinking = true
                }
                try? await Task.sleep(for: .milliseconds(140))
                withAnimation(.easeInOut(duration: 0.11)) {
                    isBlinking = false
                }
            }
        }
    }

    private var shadow: some View {
        Ellipse()
            .fill(Color.black.opacity(0.12))
            .frame(width: 120, height: 22)
            .blur(radius: 3)
    }

    private var bodyShape: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.19, green: 0.20, blue: 0.24),
                        Color(red: 0.10, green: 0.11, blue: 0.14)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 152, height: 152)
    }

    private var arms: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.11, green: 0.12, blue: 0.15))
                .frame(width: 60, height: 16)
                .rotationEffect(.degrees(-24))
                .offset(x: -44, y: 12)

            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.11, green: 0.12, blue: 0.15))
                .frame(width: 60, height: 16)
                .rotationEffect(.degrees(24))
                .offset(x: 44, y: 12)
        }
    }

    private var eyes: some View {
        HStack(spacing: 28) {
            Capsule()
                .fill(Color.white.opacity(0.92))
                .frame(width: 12, height: isBlinking ? 2 : 10)
            Capsule()
                .fill(Color.white.opacity(0.92))
                .frame(width: 12, height: isBlinking ? 2 : 10)
        }
        .offset(y: -10)
    }

    private var orb: some View {
        Circle()
            .fill(uvLevel.glowColor)
            .frame(width: 46, height: 46)
            .scaleEffect((glowPulse ? 1.0 : 0.9) * uvLevel.orbScale)
            .shadow(color: uvLevel.glowColor.opacity(0.40 * uvLevel.glowIntensity), radius: 18, x: 0, y: 0)
            .shadow(color: uvLevel.glowColor.opacity(0.55 * uvLevel.glowIntensity), radius: 38, x: 0, y: 0)
            .offset(y: 20)
            .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: glowPulse)
    }
}

#Preview {
    CreatureView(uvLevel: .high)
}
