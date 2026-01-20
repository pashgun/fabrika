import SwiftUI
import SwiftData

struct DeckEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let deck: Deck?
    @State private var name: String
    @State private var colorHex: String

    private let colorOptions = [
        "#14B8A6", // Teal
        "#10B981", // Green
        "#3B82F6", // Blue
        "#8B5CF6", // Purple
        "#F59E0B", // Amber
        "#EF4444", // Red
        "#EC4899", // Pink
        "#6366F1"  // Indigo
    ]

    init(deck: Deck?) {
        self.deck = deck
        _name = State(initialValue: deck?.name ?? "")
        _colorHex = State(initialValue: deck?.colorHex ?? "#14B8A6")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Deck name", text: $name)
                        .font(.body)
                } header: {
                    Text("Name")
                }

                Section {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 16) {
                        ForEach(colorOptions, id: \.self) { color in
                            Button {
                                colorHex = color
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: color))
                                        .frame(width: 44, height: 44)

                                    if colorHex == color {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.white)
                                            .fontWeight(.bold)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Color")
                }
            }
            .navigationTitle(deck == nil ? "New Deck" : "Edit Deck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        if let deck = deck {
            // Edit existing
            deck.name = trimmedName
            deck.colorHex = colorHex
            deck.updatedAt = Date()
        } else {
            // Create new
            let newDeck = Deck(name: trimmedName, colorHex: colorHex)
            modelContext.insert(newDeck)
        }

        try? modelContext.save()
        dismiss()
    }
}
