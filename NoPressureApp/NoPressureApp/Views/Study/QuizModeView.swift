import SwiftUI
import SwiftData
import FSRS

struct QuizModeView: View {
    let cards: [Flashcard]
    let onComplete: () -> Void

    @Environment(\.modelContext) private var modelContext
    @State private var currentIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var isAnswered = false
    @State private var score = 0
    @State private var options: [String] = []

    private let fsrsService = FSRSService()

    var body: some View {
        VStack(spacing: 32) {
            // Progress
            VStack(spacing: 12) {
                HStack {
                    Text("Question \(currentIndex + 1) of \(cards.count)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: "#8E8E93"))

                    Spacer()

                    Text("Score: \(score)/\(currentIndex + (isAnswered ? 1 : 0))")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: "#0A84FF"))
                }

                ProgressView(value: Double(currentIndex), total: Double(cards.count))
                    .tint(Color(hex: "#0A84FF"))
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            Spacer()

            // Question Card
            VStack(spacing: 20) {
                Text(currentCard.front)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 40)
            }
            .frame(maxWidth: .infinity)
            .liquidGlass(cornerRadius: 24)
            .padding(.horizontal, 24)

            // Answer Options
            VStack(spacing: 16) {
                ForEach(0..<4) { index in
                    AnswerButton(
                        text: options[index],
                        isSelected: selectedAnswer == index,
                        isCorrect: isAnswered && options[index] == currentCard.back,
                        isAnswered: isAnswered
                    ) {
                        guard !isAnswered else { return }
                        selectedAnswer = index
                        checkAnswer()
                    }
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            // Next Button
            if isAnswered {
                Button {
                    moveToNext()
                } label: {
                    Text(currentIndex < cards.count - 1 ? "Next" : "Finish")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .liquidButton()
                .padding(.horizontal, 24)
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            generateOptions()
        }
    }

    private var currentCard: Flashcard {
        cards[currentIndex]
    }

    private func generateOptions() {
        var opts = [currentCard.back]

        // Get wrong answers from other cards
        let otherCards = cards.filter { $0.id != currentCard.id }
        let wrongAnswers = Array(otherCards.prefix(3).map { $0.back })

        opts.append(contentsOf: wrongAnswers)

        // Fill up to 4 options if needed (for decks with < 4 cards)
        while opts.count < 4 {
            opts.append("Option \(opts.count + 1)")
        }

        // Shuffle
        options = opts.shuffled()
    }

    private func checkAnswer() {
        isAnswered = true

        if let selected = selectedAnswer, options[selected] == currentCard.back {
            score += 1
            updateFSRS(rating: .good)
        } else {
            updateFSRS(rating: .again)
        }
    }

    private func updateFSRS(rating: AppRating) {
        let card = currentCard

        if let fsrsData = card.fsrsData {
            let recordLog = fsrsService.repeat(card: fsrsData.convertToCard(), now: Date())
            let recordLogItem = recordLog[rating] ?? recordLog[.again]!

            fsrsData.update(from: recordLogItem.card)
            fsrsData.lastReviewed = recordLogItem.reviewTime

            try? modelContext.save()
        }
    }

    private func moveToNext() {
        if currentIndex < cards.count - 1 {
            currentIndex += 1
            selectedAnswer = nil
            isAnswered = false
            generateOptions()
        } else {
            onComplete()
        }
    }
}

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isAnswered: Bool
    let action: () -> Void

    private var backgroundColor: Color {
        if !isAnswered {
            return isSelected ? Color(hex: "#0A84FF").opacity(0.2) : Color.white.opacity(0.1)
        }

        if isCorrect {
            return Color(hex: "#30D158").opacity(0.2)
        } else if isSelected {
            return Color(hex: "#FF453A").opacity(0.2)
        } else {
            return Color.white.opacity(0.1)
        }
    }

    private var borderColor: Color {
        if !isAnswered {
            return isSelected ? Color(hex: "#0A84FF") : Color.white.opacity(0.2)
        }

        if isCorrect {
            return Color(hex: "#30D158")
        } else if isSelected {
            return Color(hex: "#FF453A")
        } else {
            return Color.white.opacity(0.2)
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(text)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if isAnswered {
                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: "#30D158"))
                    } else if isSelected {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(hex: "#FF453A"))
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(borderColor, lineWidth: 2)
                    )
            )
        }
        .disabled(isAnswered)
    }
}

#Preview {
    QuizModeView(cards: [], onComplete: {})
}
