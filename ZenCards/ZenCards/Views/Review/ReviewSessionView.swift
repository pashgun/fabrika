import SwiftUI
import SwiftData
import FSRS

struct ReviewSessionView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var fsrsService = FSRSService()
    @State private var currentCard: Card?
    @State private var isFlipped = false
    @State private var dueCards: [Card] = []
    @State private var reviewedCount = 0

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(hex: "#14B8A6").opacity(0.1),
                        Color(hex: "#10B981").opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    if let card = currentCard {
                        // Progress
                        HStack {
                            Text("Reviewed: \(reviewedCount)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(dueCards.count) left")
                                .font(.subheadline)
                                .foregroundStyle(Color(hex: "#14B8A6"))
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)

                        Spacer()

                        // Flashcard
                        FlashcardView(card: card, isFlipped: $isFlipped)
                            .frame(height: 400)
                            .onTapGesture {
                                if !isFlipped {
                                    isFlipped = true
                                }
                            }

                        Spacer()

                        // Action buttons (only show when flipped)
                        if isFlipped {
                            VStack(spacing: 12) {
                                HStack(spacing: 12) {
                                    ActionButton(
                                        label: "Again",
                                        systemImage: "xmark",
                                        color: .red
                                    ) {
                                        rateCard(.again)
                                    }
                                    .accessibilityLabel("Rate as Again")
                                    .accessibilityHint("Card will be shown soon")

                                    ActionButton(
                                        label: "Hard",
                                        systemImage: "minus",
                                        color: .orange
                                    ) {
                                        rateCard(.hard)
                                    }
                                    .accessibilityLabel("Rate as Hard")
                                    .accessibilityHint("Card was difficult to remember")

                                    ActionButton(
                                        label: "Easy",
                                        systemImage: "checkmark",
                                        color: .green
                                    ) {
                                        rateCard(.easy)
                                    }
                                    .accessibilityLabel("Rate as Easy")
                                    .accessibilityHint("Card was easy to remember")
                                }
                                .padding(.horizontal, 24)
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    } else {
                        // No cards due
                        EmptyStateView(
                            systemImage: "checkmark.circle.fill",
                            title: "All Done!",
                            description: "No cards due right now. Great work!"
                        )
                    }
                }
                .padding(.bottom, 24)
            }
            .navigationTitle("Review")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadNextCard()
            }
        }
    }

    private func rateCard(_ rating: Rating) {
        guard let card = currentCard else { return }

        // Review card with FSRS
        fsrsService.reviewCard(card, rating: rating, modelContext: modelContext)

        // Update counts
        reviewedCount += 1

        // Load next card
        isFlipped = false
        loadNextCard()
    }

    private func loadNextCard() {
        dueCards = fsrsService.getDueCards(modelContext: modelContext)
        currentCard = dueCards.first
    }
}
