import SwiftUI
import SwiftData

struct DeckListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Deck.createdAt, order: .reverse) private var decks: [Deck]
    @State private var showCreateDeck = false
    @State private var selectedDeck: Deck?

    var body: some View {
        NavigationStack {
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

                if decks.isEmpty {
                    // Empty state
                    EmptyStateView(
                        systemImage: "rectangle.stack",
                        title: "No Decks Yet",
                        description: "Create your first deck to start learning",
                        actionLabel: "Create Deck",
                        action: { showCreateDeck = true }
                    )
                } else {
                    // Deck list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(decks) { deck in
                                NavigationLink(value: deck) {
                                    DeckRowView(deck: deck)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Decks")
            .navigationDestination(for: Deck.self) { deck in
                CardListView(deck: deck)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showCreateDeck = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Create new deck")
                }
            }
            .sheet(isPresented: $showCreateDeck) {
                DeckEditView(deck: nil)
            }
        }
    }
}

struct DeckRowView: View {
    let deck: Deck

    var body: some View {
        HStack(spacing: 16) {
            // Color badge
            Circle()
                .fill(Color(hex: deck.colorHex))
                .frame(width: 12, height: 12)

            VStack(alignment: .leading, spacing: 4) {
                Text(deck.name)
                    .font(.headline)
                    .fontWeight(.semibold)

                Text(deck.dueText)
                    .font(.callout)
                    .foregroundStyle(deck.dueCount > 0 ? Color(hex: "#14B8A6") : .secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary.opacity(0.5))
        }
        .padding(16)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
