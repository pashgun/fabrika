import SwiftUI

struct OnboardingView: View {
    @Binding var showPaywall: Bool
    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            type: .welcome,
            title: "Beautiful Spaced Repetition",
            description: "Master any subject with the power of science-backed learning"
        ),
        OnboardingPage(
            type: .feature,
            title: "Modern Algorithm",
            description: "FSRS spaced repetition helps you remember long-term"
        ),
        OnboardingPage(
            type: .widget,
            title: "Review Anywhere",
            description: "Interactive Home Screen widget lets you study without opening the app"
        )
    ]

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(hex: "#14B8A6").opacity(0.3),
                    Color(hex: "#10B981").opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Pages
                TabView(selection: $currentPage) {
                    ForEach(pages.indices, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Page indicators
                HStack(spacing: 8) {
                    ForEach(pages.indices, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color(hex: "#14B8A6") : Color.secondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 24)

                // CTA Button
                PrimaryButton(label: currentPage == pages.count - 1 ? "Get Started" : "Next") {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        showPaywall = true
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}
