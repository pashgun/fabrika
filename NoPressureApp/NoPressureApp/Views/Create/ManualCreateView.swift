import SwiftUI
import SwiftData

struct ManualCreateView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var deckName = ""
    @State private var deckDescription = ""
    @State private var selectedColor = "#0A84FF"
    @State private var selectedIcon = "star.fill"
    @State private var cards: [CardDraft] = [CardDraft(), CardDraft()]

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
        NavigationStack {
            ZStack {
                MeshBackground()

                ScrollView {
                    VStack(spacing: 24) {
                        // Deck Details Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Deck Details")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)

                            // Deck Name
                            TextField("Deck name", text: $deckName)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(16)
                                .liquidGlass(cornerRadius: 16)

                            // Deck Description
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
                        .padding(.top, 20)

                        // Cards Section
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

                            ForEach(cards.indices, id: \.self) { index in
                                CardInputView(
                                    card: $cards[index],
                                    index: index + 1,
                                    onDelete: {
                                        withAnimation {
                                            cards.remove(at: index)
                                        }
                                    }
                                )
                            }

                            // Add Card Button
                            Button {
                                withAnimation {
                                    cards.append(CardDraft())
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color(hex: selectedColor))

                                    Text("Add Card")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.white)

                                    Spacer()
                                }
                                .padding(20)
                                .liquidGlass(cornerRadius: 16)
                            }
                        }
                        .padding(.horizontal, 24)

                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Create Deck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "#0A84FF"))
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveDeck()
                    }
                    .foregroundColor(Color(hex: "#0A84FF"))
                    .disabled(!canSave)
                }
            }
        }
    }

    private var canSave: Bool {
        !deckName.isEmpty && cards.filter { !$0.front.isEmpty && !$0.back.isEmpty }.count >= 2
    }

    private func saveDeck() {
        let deck = Deck(
            name: deckName,
            description: deckDescription.isEmpty ? nil : deckDescription,
            colorHex: selectedColor,
            icon: selectedIcon
        )
        modelContext.insert(deck)

        // Create flashcards
        for card in cards where !card.front.isEmpty && !card.back.isEmpty {
            let flashcard = Flashcard(
                front: card.front,
                back: card.back,
                deck: deck
            )
            modelContext.insert(flashcard)
        }

        try? modelContext.save()
        dismiss()
    }
}

// MARK: - Card Draft Model

struct CardDraft: Identifiable {
    let id = UUID()
    var front = ""
    var back = ""
}

// MARK: - Card Input View

struct CardInputView: View {
    @Binding var card: CardDraft
    let index: Int
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Card \(index)")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                if index > 2 {
                    Button {
                        onDelete()
                    } label: {
                        Image(systemName: "trash.fill")
                            .foregroundColor(Color(hex: "#FF453A"))
                    }
                }
            }

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

// MARK: - Preview

#Preview {
    ManualCreateView()
}
