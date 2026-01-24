import SwiftUI

struct WelcomeView: View {
    @Binding var showOnboarding: Bool

    var body: some View {
        ZStack {
            MeshBackground()

            VStack(spacing: 40) {
                Spacer()

                // Logo and Title
                VStack(spacing: 16) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "#BF5AF2"), Color(hex: "#0A84FF")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Text("No Pressure\nFlashcards")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("Learn without the pressure")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(Color(hex: "#8E8E93"))
                }

                Spacer()

                // Get Started Button
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        showOnboarding = false
                    }
                } label: {
                    Text("Get Started")
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
