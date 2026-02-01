import SwiftUI
import SwiftData

struct TextImportView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var inputText = ""
    @State private var isGenerating = false
    @State private var generatedCards: [GeneratedFlashcard] = []
    @State private var errorMessage: String?
    @State private var showingReview = false

    private let aiService = AIGenerationService()
    private let characterLimit = 5000

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                if showingReview {
                    ReviewGeneratedCardsView(
                        cards: $generatedCards,
                        onSave: { deckName, deckDescription, colorHex, icon in
                            saveDeck(name: deckName, description: deckDescription, color: colorHex, icon: icon)
                        },
                        onCancel: {
                            showingReview = false
                            generatedCards = []
                        }
                    )
                } else {
                    VStack(spacing: 24) {
                        // Instructions
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Paste or type text")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)

                            Text("Add text from notes, articles, or any source")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(Color(hex: "#8E8E93"))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)

                        // Text Editor
                        VStack(spacing: 12) {
                            TextEditor(text: $inputText)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .frame(minHeight: 300)
                                .padding(16)
                                .liquidGlass(cornerRadius: 20)

                            HStack {
                                Text("\(inputText.count)/\(characterLimit) characters")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(Color(hex: "#8E8E93"))

                                Spacer()

                                if !inputText.isEmpty {
                                    Button("Clear") {
                                        inputText = ""
                                    }
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Color(hex: "#FF453A"))
                                }
                            }
                        }
                        .padding(.horizontal, 24)

                        // Error Message
                        if let error = errorMessage {
                            Text(error)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color(hex: "#FF453A"))
                                .padding(.horizontal, 24)
                                .multilineTextAlignment(.center)
                        }

                        Spacer()

                        // Generate Button
                        Button {
                            Task {
                                await generateFlashcards()
                            }
                        } label: {
                            HStack(spacing: 12) {
                                if isGenerating {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 16, weight: .semibold))
                                }

                                Text(isGenerating ? "Generating..." : "Generate Flashcards")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                        }
                        .liquidButton()
                        .padding(.horizontal, 24)
                        .disabled(inputText.isEmpty || isGenerating || inputText.count > characterLimit)
                        .opacity(inputText.isEmpty || inputText.count > characterLimit ? 0.5 : 1.0)

                        Spacer().frame(height: 60)
                    }
                }
            }
            .navigationTitle("Text Import")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !showingReview {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(Color(hex: "#0A84FF"))
                    }
                }
            }
        }
    }

    private func generateFlashcards() async {
        guard !inputText.isEmpty else { return }

        isGenerating = true
        errorMessage = nil

        do {
            let cards = try await aiService.generateFlashcards(from: inputText)

            await MainActor.run {
                generatedCards = cards
                showingReview = true
                isGenerating = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isGenerating = false
            }
        }
    }

    private func saveDeck(name: String, description: String?, color: String, icon: String) {
        let deck = Deck(
            name: name,
            description: description,
            colorHex: color,
            icon: icon
        )
        modelContext.insert(deck)

        for card in generatedCards {
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

#Preview {
    TextImportView()
}
