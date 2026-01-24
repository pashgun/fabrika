import SwiftUI

struct FeaturePage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct HowItWorksView: View {
    @Binding var currentPage: Int
    let onComplete: () -> Void

    let features = [
        FeaturePage(
            icon: "camera.fill",
            title: "Snap & Learn",
            description: "AI creates flashcards from photos, PDFs, or text"
        ),
        FeaturePage(
            icon: "heart.fill",
            title: "No Guilt, No Burnout",
            description: "Miss a day? No problem. No streaks, no pressure."
        ),
        FeaturePage(
            icon: "brain.head.profile",
            title: "Smart Repetition",
            description: "FSRS algorithm shows cards at optimal time"
        )
    ]

    var body: some View {
        ZStack {
            MeshBackground()

            VStack(spacing: 0) {
                Spacer()

                // Feature Content
                TabView(selection: $currentPage) {
                    ForEach(Array(features.enumerated()), id: \.element.id) { index, feature in
                        VStack(spacing: 32) {
                            Image(systemName: feature.icon)
                                .font(.system(size: 80))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(hex: "#BF5AF2"), Color(hex: "#0A84FF")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )

                            VStack(spacing: 16) {
                                Text(feature.title)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)

                                Text(feature.description)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(Color(hex: "#8E8E93"))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 48)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 400)

                Spacer()

                // Continue Button
                Button {
                    if currentPage < features.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                } label: {
                    Text(currentPage < features.count - 1 ? "Continue" : "Next")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .liquidButton()
                .padding(.horizontal, 32)

                Spacer().frame(height: 60)
            }
        }
    }
}
