import SwiftUI

struct ReviewGeneratedCardsView: View {
    @Binding var cards: [GeneratedFlashcard]
    let onSave: (String, String?, String, String) -> Void
    let onCancel: () -> Void

    @State private var deckName = ""
    @State private var deckDescription = ""
    @State private var selectedColor = "#0A84FF"
    @State private var selectedIcon = "star.fill"

    let availableColors = [
        "#0A84FF", // Blue
        "#BF5AF2", // Purple
        "#FF453A", // Red
        "#FF9F0A", // Orange
        "#30D158", // Green
        "#64D2FF", // Cyan
        "#FFD60A"  // Yellow
    ]

    let availableIcons = [
        "star.fill", "heart.fill", "book.fill", "globe",
        "brain.head.profile", "graduationcap.fill",
        "flag.fill", "lightbulb.fill", "sparkles"
    ]

    var body: some View {
        ZStack {
            MeshBackground()

            ScrollView {
                VStack(spacing: 24) {
                    // Success Header
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "#30D158"), Color(hex: "#64D2FF")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text("Generated \(cards.count) flashcards")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        Text("Review and edit before saving")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color(hex: "#8E8E93"))
                    }
                    .padding(.top, 40)

                    // Deck Details
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Deck Details")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)

                        TextField("Deck name", text: $deckName)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(16)
                            .liquidGlass(cornerRadius: 16)

                        TextField("Description (optional)", text: $deckDescription)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white)
                            .padding(16)
                            .liquidGlass(cornerRadius: 16)

                        // Color Picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Color")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(hex: "#8E8E93"))

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(availableColors, id: \.self) { color in
                                        Circle()
                                            .fill(Color(hex: color))
                                            .frame(width: 44, height: 44)
                                            .overlay(
                                                Circle()
                                                    .strokeBorder(Color.white, lineWidth: 3)
                                                    .opacity(selectedColor == color ? 1 : 0)
                                            )
                                            .onTapGesture {
                                                selectedColor = color
                                            }
                                    }
                                }
                            }
                        }

                        // Icon Picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Icon")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(hex: "#8E8E93"))

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(availableIcons, id: \.self) { icon in
                                        Image(systemName: icon)
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(selectedIcon == icon ? Color(hex: selectedColor) : .white)
                                            .frame(width: 44, height: 44)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white.opacity(selectedIcon == icon ? 0.2 : 0.1))
                                            )
                                            .onTapGesture {
                                                selectedIcon = icon
                                            }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    // Cards List
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Cards")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)

                            Spacer()

                            Text("\(cards.count)")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(hex: "#8E8E93"))
                        }

                        ForEach($cards) { $card in
                            EditableCardView(card: $card)
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer(minLength: 100)
                }
            }

            // Bottom Buttons
            VStack {
                Spacer()

                HStack(spacing: 16) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(hex: "#FF453A"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .liquidGlass(cornerRadius: 16)

                    Button("Save Deck") {
                        onSave(
                            deckName.isEmpty ? "New Deck" : deckName,
                            deckDescription.isEmpty ? nil : deckDescription,
                            selectedColor,
                            selectedIcon
                        )
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .liquidButton()
                    .disabled(cards.isEmpty)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

struct EditableCardView: View {
    @Binding var card: GeneratedFlashcard

    var body: some View {
        VStack(spacing: 12) {
            TextField("Front (question)", text: $card.front, axis: .vertical)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                )
                .lineLimit(3...5)

            TextField("Back (answer)", text: $card.back, axis: .vertical)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                )
                .lineLimit(3...5)
        }
        .padding(16)
        .liquidGlass(cornerRadius: 16)
    }
}

#Preview {
    @Previewable @State var cards = [
        GeneratedFlashcard(front: "What is SwiftUI?", back: "A declarative UI framework for Apple platforms"),
        GeneratedFlashcard(front: "What is SwiftData?", back: "Apple's persistence framework introduced in iOS 17")
    ]

    return ReviewGeneratedCardsView(
        cards: $cards,
        onSave: { name, desc, color, icon in
            print("Save: \(name)")
        },
        onCancel: {
            print("Cancel")
        }
    )
}
