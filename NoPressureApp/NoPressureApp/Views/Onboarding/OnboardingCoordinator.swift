import SwiftUI

struct OnboardingCoordinator: View {
    @Binding var isOnboardingComplete: Bool
    @State private var currentScreen = 0
    @State private var howItWorksPage = 0
    @State private var personalizationStep = 0

    @State private var selectedGoal: LearningGoal? = nil
    @State private var selectedMinutes: Int? = nil
    @State private var selectedInterests: Set<String> = []

    var body: some View {
        ZStack {
            switch currentScreen {
            case 0:
                WelcomeView(showOnboarding: .constant(true))
                    .transition(.opacity)

            case 1:
                HowItWorksView(currentPage: $howItWorksPage) {
                    withAnimation {
                        currentScreen = 2
                    }
                }
                .transition(.opacity)

            case 2:
                PersonalizationView(
                    selectedGoal: $selectedGoal,
                    selectedMinutes: $selectedMinutes,
                    selectedInterests: $selectedInterests,
                    currentStep: $personalizationStep
                ) {
                    completeOnboarding()
                }
                .transition(.opacity)

            default:
                EmptyView()
            }
        }
        .onAppear {
            // Start with welcome screen
            currentScreen = 0
        }
    }

    private func completeOnboarding() {
        // Save user preferences (would normally save to SwiftData)
        withAnimation {
            isOnboardingComplete = true
        }
    }
}
