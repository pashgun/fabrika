import SwiftUI
import SwiftData

struct CardListView: View {
    @Environment(\.modelContext) private var modelContext
    let deck: Deck
    @State private var showCreateCard = false
    @State private var selectedCard: Card?

    private var cards: [Card] {
        deck.cards?.sorted(by: { $0.createdAt > $1.createdAt }) ?? []
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(hex: "#14B8A6").opacity(0.05),
                    Color(hex: "#10B981").opacity(0.03)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            if cards.isEmpty {
                // Empty state
                EmptyStateView(
                    systemImage: "rectangle.on.rectangle",
                    title: "No Cards Yet",
                    description: "Add your first flashcard to this deck",
                    actionLabel: "Add Card",
                    action: { showCreateCard = true }
                )
            } else {
                // Card list
                List {
                    ForEach(cards) { card in
                        CardRowView(card: card)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .onTapGesture {
                                selectedCard = card
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    deleteCard(card)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }

                                Button {
                                    selectedCard = card
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(Color(hex: "#14B8A6"))
                            }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle(deck.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showCreateCard = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add new card")
            }
        }
        .sheet(item: $selectedCard) { card in
            CardEditView(deck: deck, card: card)
        }
        .sheet(isPresented: $showCreateCard) {
            CardEditView(deck: deck, card: nil)
        }
    }

    private func deleteCard(_ card: Card) {
        modelContext.delete(card)
        try? modelContext.save()
    }
}

struct CardRowView: View {
    let card: Card

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(card.front)
                .font(.body)
                .fontWeight(.semibold)
                .lineLimit(1)

            HStack {
                if card.isNew {
                    Text("New")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "#14B8A6").opacity(0.2))
                        .foregroundStyle(Color(hex: "#14B8A6"))
                        .clipShape(Capsule())
                } else {
                    Text(card.statusText)
                        .font(.caption)
                        .foregroundStyle(card.isDue ? Color(hex: "#14B8A6") : .secondary)
                }

                Spacer()

                if card.reps > 0 {
                    Text("\(card.reps) reviews")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
