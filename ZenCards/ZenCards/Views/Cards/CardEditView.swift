import SwiftUI
import SwiftData

struct CardEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let deck: Deck
    let card: Card?

    @State private var front: String
    @State private var back: String
    @StateObject private var ttsService = TTSService()

    init(deck: Deck, card: Card?) {
        self.deck = deck
        self.card = card
        _front = State(initialValue: card?.front ?? "")
        _back = State(initialValue: card?.back ?? "")
    }

    var isValid: Bool {
        !front.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !back.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Question or context", text: $front, axis: .vertical)
                        .lineLimit(5...10)
                } header: {
                    Text("Front")
                } footer: {
                    Text("\(front.count)/500 characters")
                        .foregroundStyle(front.count > 500 ? .red : .secondary)
                }

                Section {
                    TextField("Answer or definition", text: $back, axis: .vertical)
                        .lineLimit(5...10)

                    // TTS Preview button
                    Button {
                        ttsService.speak(back)
                    } label: {
                        HStack {
                            Image(systemName: ttsService.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                            Text("Preview Pronunciation")
                        }
                    }
                    .disabled(back.isEmpty || ttsService.isSpeaking)
                } header: {
                    Text("Back")
                } footer: {
                    Text("\(back.count)/500 characters")
                        .foregroundStyle(back.count > 500 ? .red : .secondary)
                }

                Section {
                    HStack {
                        Circle()
                            .fill(Color(hex: deck.colorHex))
                            .frame(width: 12, height: 12)
                        Text(deck.name)
                            .font(.body)
                    }
                } header: {
                    Text("Deck")
                }
            }
            .navigationTitle(card == nil ? "New Card" : "Edit Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        if ttsService.isSpeaking {
                            ttsService.stop()
                        }
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(!isValid || front.count > 500 || back.count > 500)
                }
            }
        }
        .onDisappear {
            if ttsService.isSpeaking {
                ttsService.stop()
            }
        }
    }

    private func save() {
        let trimmedFront = front.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBack = back.trimmingCharacters(in: .whitespacesAndNewlines)

        if let card = card {
            // Edit existing
            card.front = trimmedFront
            card.back = trimmedBack
            card.updatedAt = Date()
        } else {
            // Create new
            let newCard = Card(front: trimmedFront, back: trimmedBack, deck: deck)
            modelContext.insert(newCard)
        }

        try? modelContext.save()

        // Sync to widget
        let fsrsService = FSRSService()
        fsrsService.syncDueCardsToWidget(modelContext: modelContext)

        dismiss()
    }
}
