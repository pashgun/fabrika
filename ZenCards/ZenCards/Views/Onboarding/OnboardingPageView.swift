import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Hero visual
            hero

            Spacer()

            // Content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(page.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()
        }
        .padding()
    }

    @ViewBuilder
    private var hero: some View {
        switch page.type {
        case .welcome:
            VStack(spacing: 24) {
                // Logo
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "#14B8A6"),
                                Color(hex: "#10B981")
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 48))
                            .foregroundStyle(.white)
                    )

                Text("ZenCards")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(hex: "#14B8A6"))
            }

        case .feature:
            // Mock review card with animation
            ZStack {
                MockFlashcard(text: "What is spaced repetition?", isBack: false)
                    .opacity(reduceMotion ? 1 : 0)
                    .rotation3DEffect(
                        .degrees(reduceMotion ? 0 : 180),
                        axis: (x: 0, y: 1, z: 0)
                    )

                MockFlashcard(text: "A learning technique that spaces reviews over time", isBack: true)
                    .opacity(reduceMotion ? 0 : 1)
                    .rotation3DEffect(
                        .degrees(reduceMotion ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
            }
            .frame(height: 250)
            .padding(.horizontal, 32)

        case .widget:
            // Mock widget
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .foregroundStyle(Color(hex: "#14B8A6"))
                    Text("3 left")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }

                Text("Review from Home Screen")
                    .font(.headline)
                    .multilineTextAlignment(.center)

                HStack(spacing: 8) {
                    Button {} label: {
                        Text("Hard")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(.thickMaterial)
                            .foregroundStyle(.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(true)

                    Button {} label: {
                        Text("Easy")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(.thickMaterial)
                            .foregroundStyle(.green)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(true)
                }
            }
            .padding(16)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(height: 180)
            .padding(.horizontal, 32)
        }
    }
}

struct MockFlashcard: View {
    let text: String
    let isBack: Bool

    var body: some View {
        VStack {
            Text(text)
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(24)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}

enum OnboardingPageType {
    case welcome
    case feature
    case widget
}

struct OnboardingPage {
    let type: OnboardingPageType
    let title: String
    let description: String
}
