import SwiftUI

// MARK: - Glass Card (Large containers)
struct GlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(Color.white.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(Color.white, lineWidth: 2)
            )
    }
}

// MARK: - Liquid Button (with shine effect)
struct LiquidButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(Color.white.opacity(0.01))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
            )
            // Inner glow effect
            .overlay(
                Capsule()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.25)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                    .blur(radius: 1)
            )
    }
}

// MARK: - Liquid Glass (General purpose)
struct LiquidGlass: ViewModifier {
    var cornerRadius: CGFloat = 24
    var blurRadius: CGFloat = 15

    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.1),
                        Color.white.opacity(0.05),
                        Color.white.opacity(0.02)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 8)
    }
}

// MARK: - View Extensions
extension View {
    func liquidGlass(cornerRadius: CGFloat = 24) -> some View {
        modifier(LiquidGlass(cornerRadius: cornerRadius))
    }

    func glassCard() -> some View {
        modifier(GlassCard())
    }

    func liquidButton() -> some View {
        modifier(LiquidButton())
    }
}
