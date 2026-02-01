import SwiftUI
import SwiftData
import FSRS

struct WriteModeView: View {
    let cards: [Flashcard]
    let onComplete: () -> Void

    @Environment(\.modelContext) private var modelContext
    @State private var currentIndex = 0
    @State private var userAnswer = ""
    @State private var isAnswered = false
    @State private var isCorrect = false
    @State private var score = 0
    @State private var showHint = false
    @State private var showError = false
    @State private var errorMessage = ""

    private let fsrsService = FSRSService()
    private let similarityThreshold = 0.8 // 80% similarity required

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
            if let card = currentCardSafe {
                VStack(spacing: 20) {
                    Text(card.front)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 40)
            }
            .frame(maxWidth: .infinity)
            .liquidGlass(cornerRadius: 24)
            .padding(.horizontal, 24)
            } else {
                Text("No card available")
                    .foregroundColor(.white)
            }

            // Answer Input
            VStack(spacing: 16) {
                TextField("Type your answer", text: $userAnswer)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(answerBackgroundColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(answerBorderColor, lineWidth: 2)
                            )
                    )
                    .disabled(isAnswered)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                // Hint Button
                if !isAnswered && !showHint {
                    Button("Show Hint") {
                        showHint = true
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(hex: "#8E8E93"))
                }

                // Hint
                if showHint && !isAnswered {
                    Text(getHint())
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "#8E8E93"))
                        .padding(.horizontal, 20)
                }

                // Feedback
                if isAnswered {
                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(isCorrect ? Color(hex: "#30D158") : Color(hex: "#FF453A"))

                            Text(isCorrect ? "Correct!" : "Not quite")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        if !isCorrect, let card = currentCardSafe {
                            VStack(spacing: 4) {
                                Text("Correct answer:")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color(hex: "#8E8E93"))

                                Text(card.back)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(Color(hex: "#30D158"))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .liquidGlass(cornerRadius: 16)
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            // Action Button
            Button {
                if isAnswered {
                    moveToNext()
                } else {
                    checkAnswer()
                }
            } label: {
                Text(isAnswered ? (currentIndex < cards.count - 1 ? "Next" : "Finish") : "Submit")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
            }
            .liquidButton()
            .padding(.horizontal, 24)
            .padding(.bottom, 60)
            .disabled(!isAnswered && userAnswer.isEmpty)
            .opacity(!isAnswered && userAnswer.isEmpty ? 0.5 : 1.0)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }

    private var currentCardSafe: Flashcard? {
        guard currentIndex >= 0 && currentIndex < cards.count else {
            return nil
        }
        return cards[currentIndex]
    }

    private var answerBackgroundColor: Color {
        if !isAnswered {
            return Color.white.opacity(0.1)
        }
        return isCorrect ? Color(hex: "#30D158").opacity(0.2) : Color(hex: "#FF453A").opacity(0.2)
    }

    private var answerBorderColor: Color {
        if !isAnswered {
            return Color.white.opacity(0.2)
        }
        return isCorrect ? Color(hex: "#30D158") : Color(hex: "#FF453A")
    }

    private func getHint() -> String {
        guard let card = currentCardSafe else {
            return "No hint available"
        }

        let answer = card.back
        let wordCount = answer.split(separator: " ").count

        if wordCount == 1 {
            // Show first letter
            return "Hint: Starts with '\(answer.prefix(1))'"
        } else {
            // Show word count
            return "Hint: \(wordCount) words"
        }
    }

    private func checkAnswer() {
        guard let card = currentCardSafe else {
            return
        }

        isAnswered = true
        isCorrect = userAnswer.isSimilarEnough(to: card.back, threshold: similarityThreshold)

        if isCorrect {
            score += 1
            updateFSRS(rating: .good)
        } else {
            updateFSRS(rating: .again)
        }
    }

    private func updateFSRS(rating: AppRating) {
        guard let card = currentCardSafe else {
            return
        }

        if let fsrsData = card.fsrsData {
            let recordLog = fsrsService.repeat(card: fsrsData.convertToCard(), now: Date())

            // Safe optional binding - use rating or fallback to .good
            guard let recordLogItem = recordLog[rating.fsrsRating] ?? recordLog[.good] else {
                return
            }

            fsrsData.update(from: recordLogItem.card)
            fsrsData.lastReviewed = recordLogItem.reviewTime

            do {
                try modelContext.save()
            } catch {
                showError = true
                errorMessage = "Failed to save progress: \(error.localizedDescription)"
            }
        }
    }

    private func moveToNext() {
        if currentIndex < cards.count - 1 {
            currentIndex += 1
            userAnswer = ""
            isAnswered = false
            isCorrect = false
            showHint = false
        } else {
            onComplete()
        }
    }
}

#Preview {
    WriteModeView(cards: [], onComplete: {})
}
