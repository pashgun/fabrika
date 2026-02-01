import SwiftUI
import SwiftData
import FabrikaAnalytics

struct StudySessionView: View {
    let deck: Deck
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.analyticsService) private var analytics

    @State private var currentCardIndex = 0
    @State private var isFlipped = false
    @State private var cardsReviewed = 0
    @State private var showingComplete = false
    @State private var sessionStartTime = Date()
    @State private var studyMode: StudyMode = .flashcard

    private let fsrsService = FSRSService()

    var dueCards: [Flashcard] {
        deck.cards.filter { card in
            guard let nextReview = card.fsrsData?.nextReview else { return true }
            return nextReview <= Date()
        }
    }

    var currentCard: Flashcard? {
        guard currentCardIndex < dueCards.count else { return nil }
        return dueCards[currentCardIndex]
    }

    var body: some View {
        ZStack {
            MeshBackground()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(12)
                            .liquidGlass(cornerRadius: 12)
                    }

                    Spacer()

                    Text("\(currentCardIndex + 1) / \(dueCards.count)")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .liquidGlass(cornerRadius: 12)

                    Spacer()

                    // Placeholder for symmetry
                    Color.clear
                        .frame(width: 48, height: 48)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Study Mode Selector
                StudyModeSelector(selectedMode: $studyMode)
                    .padding(.top, 16)

                // Content based on study mode
                switch studyMode {
                case .flashcard:
                    flashcardModeView
                case .quiz:
                    quizModeView
                case .write:
                    writeModeView
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingComplete) {
            SessionCompleteView(
                cardsReviewed: cardsReviewed,
                onDismiss: { dismiss() }
            )
        }
        .onAppear {
            sessionStartTime = Date()

            // Track session start
            let event = FlashcardEvent.studySessionStarted(
                deckName: deck.name,
                dueCardsCount: dueCards.count
            )
            analytics.track(event, context: modelContext)
        }
        .onDisappear {
            // Track session end
            let duration = Date().timeIntervalSince(sessionStartTime)
            let event = FlashcardEvent.studySessionCompleted(
                cardsReviewed: cardsReviewed,
                duration: duration
            )
            analytics.track(event, context: modelContext)
        }
    }

    // MARK: - Mode Views

    @ViewBuilder
    private var flashcardModeView: some View {
        VStack(spacing: 0) {
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 4)

                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#BF5AF2"), Color(hex: "#0A84FF")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(currentCardIndex) / CGFloat(max(dueCards.count, 1)), height: 4)
                }
            }
            .frame(height: 4)
            .padding(.top, 16)
            .padding(.horizontal, 24)

            Spacer()

            // Flashcard
            if let card = currentCard {
                FlipCard(
                    front: card.front,
                    back: card.back,
                    isFlipped: $isFlipped
                )
                .padding(.horizontal, 32)
            } else {
                Text("No cards to review")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }

            Spacer()

            // Rating Buttons (show only when flipped)
            if isFlipped {
                HStack(spacing: 12) {
                    RatingButton(title: "Again", color: "#FF375F") {
                        rateCard(rating: .again)
                    }

                    RatingButton(title: "Hard", color: "#FF9F0A") {
                        rateCard(rating: .hard)
                    }

                    RatingButton(title: "Good", color: "#0A84FF") {
                        rateCard(rating: .good)
                    }

                    RatingButton(title: "Easy", color: "#30D158") {
                        rateCard(rating: .easy)
                    }
                }
                .padding(.horizontal, 24)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Spacer().frame(height: 60)
        }
    }

    @ViewBuilder
    private var quizModeView: some View {
        QuizModeView(cards: dueCards) {
            showingComplete = true
            cardsReviewed = dueCards.count
        }
    }

    @ViewBuilder
    private var writeModeView: some View {
        WriteModeView(cards: dueCards) {
            showingComplete = true
            cardsReviewed = dueCards.count
        }
    }

    // MARK: - Card Rating

    private func rateCard(rating: AppRating) {
        guard let card = currentCard else { return }

        // Update FSRS data
        let updatedData = fsrsService.processReview(card: card, rating: rating)
        card.fsrsData = updatedData
        deck.lastStudied = Date()

        // Track card rating
        let cardAge = Date().timeIntervalSince(card.createdAt)
        let event = FlashcardEvent.cardRated(
            rating: "\(rating)",
            cardAge: cardAge
        )
        analytics.track(event, context: modelContext)

        // Save context
        try? modelContext.save()

        cardsReviewed += 1

        // Move to next card
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            isFlipped = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if currentCardIndex < dueCards.count - 1 {
                    currentCardIndex += 1
                } else {
                    showingComplete = true
                }
            }
        }
    }
}

struct FlipCard: View {
    let front: String
    let back: String
    @Binding var isFlipped: Bool

    var body: some View {
        ZStack {
            // Back side
            CardSide(text: back, isBack: true)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -90),
                    axis: (x: 0, y: 1, z: 0)
                )

            // Front side
            CardSide(text: front, isBack: false)
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(isFlipped ? 90 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isFlipped.toggle()
            }
        }
    }
}

struct CardSide: View {
    let text: String
    let isBack: Bool

    var body: some View {
        VStack {
            Spacer()

            Text(text)
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(32)

            Spacer()

            if !isBack {
                Text("Tap to reveal")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color(hex: "#8E8E93"))
                    .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: 400)
        .glassCard()
    }
}

struct RatingButton: View {
    let title: String
    let color: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(hex: color))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

struct SessionCompleteView: View {
    let cardsReviewed: Int
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            MeshBackground()

            VStack(spacing: 32) {
                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "#30D158"), Color(hex: "#0A84FF")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                VStack(spacing: 12) {
                    Text("Great job!")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)

                    Text("You reviewed \(cardsReviewed) cards")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color(hex: "#8E8E93"))
                }

                Spacer()

                Button {
                    onDismiss()
                } label: {
                    Text("Done")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .liquidButton()
                .padding(.horizontal, 32)

                Spacer().frame(height: 60)
            }
        }
    }
}
