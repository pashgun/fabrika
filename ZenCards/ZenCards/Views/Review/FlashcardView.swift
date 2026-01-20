import SwiftUI

struct FlashcardView: View {
    let card: Card
    @Binding var isFlipped: Bool
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Front side
                CardSide(text: card.front, isFront: true)
                    .opacity(isFlipped ? 0 : 1)
                    .rotation3DEffect(
                        .degrees(isFlipped ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )

                // Back side
                CardSide(text: card.back, isFront: false)
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(
                        .degrees(isFlipped ? 0 : -180),
                        axis: (x: 0, y: 1, z: 0)
                    )
            }
            .animation(
                reduceMotion ? .none : .spring(response: 0.6, dampingFraction: 0.8),
                value: isFlipped
            )
            .frame(
                width: geometry.size.width,
                height: min(geometry.size.height, 400)
            )
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(isFlipped ? "Card back: \(card.back)" : "Card front: \(card.front)")
        .accessibilityHint(isFlipped ? "Tap to flip to front" : "Tap to flip to back")
    }
}

struct CardSide: View {
    let text: String
    let isFront: Bool

    var body: some View {
        VStack(spacing: 16) {
            Text(text)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            if isFront {
                Text("Tap to flip ↑")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
        .padding(.horizontal, 24)
    }
}
