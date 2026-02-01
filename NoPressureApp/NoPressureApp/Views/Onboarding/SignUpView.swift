import SwiftUI

struct SignUpView: View {
    let onComplete: () -> Void

    @State private var isLoading = false
    @State private var selectedMethod: AuthMethod? = nil

    enum AuthMethod {
        case apple
        case google
        case email
    }

    var body: some View {
        ZStack {
            MeshBackground()

            VStack(spacing: 32) {
                // Title
                VStack(spacing: 12) {
                    Text("Create Account")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)

                    Text("Choose how you'd like to sign up")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color(hex: "#8E8E93"))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 100)

                Spacer()

                // Auth Buttons
                VStack(spacing: 16) {
                    // Apple Sign In
                    AuthButton(
                        icon: "apple.logo",
                        title: "Continue with Apple",
                        isLoading: isLoading && selectedMethod == .apple
                    ) {
                        signIn(with: .apple)
                    }

                    // Google Sign In
                    AuthButton(
                        icon: "g.circle.fill",
                        title: "Continue with Google",
                        isLoading: isLoading && selectedMethod == .google
                    ) {
                        signIn(with: .google)
                    }

                    // Email Sign In
                    AuthButton(
                        icon: "envelope.fill",
                        title: "Continue with Email",
                        isLoading: isLoading && selectedMethod == .email
                    ) {
                        signIn(with: .email)
                    }
                }
                .padding(.horizontal, 32)

                Spacer()

                // Privacy Notice
                Text("By continuing, you agree to our Terms of Service and Privacy Policy")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color(hex: "#8E8E93"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 60)
            }
        }
    }

    private func signIn(with method: AuthMethod) {
        selectedMethod = method
        isLoading = true

        // Simulate authentication delay (MVP: visual only, no real auth)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            onComplete()
        }
    }
}

// MARK: - Auth Button Component

private struct AuthButton: View {
    let icon: String
    let title: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(width: 24, height: 24)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                }

                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .padding(.horizontal, 20)
        }
        .liquidGlass(cornerRadius: 16)
        .disabled(isLoading)
        .opacity(isLoading ? 0.6 : 1.0)
    }
}

// MARK: - Preview

#Preview {
    SignUpView {
        print("Sign up completed")
    }
}
