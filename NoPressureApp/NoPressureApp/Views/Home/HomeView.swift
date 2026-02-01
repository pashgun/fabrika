import SwiftUI
import SwiftData
import FabrikaAnalytics

struct HomeView: View {
    @Query private var decks: [Deck]
    @Query private var users: [User]
    @Environment(\.analyticsService) private var analytics
    @Environment(\.modelContext) private var modelContext

    private var userName: String {
        users.first?.name ?? "Friend"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                ScrollView {
                    VStack(spacing: 32) {
                        // Greeting
                        VStack(alignment: .leading, spacing: 8) {
                            Text(greetingText())
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)

                            Text("Ready to learn something new?")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(Color(hex: "#8E8E93"))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)

                        // Today's Goal Card
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Today's Goal")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.white)

                                    Text("0/20 cards reviewed")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(Color(hex: "#8E8E93"))
                                }

                                Spacer()

                                // Progress Ring
                                ZStack {
                                    Circle()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 6)
                                        .frame(width: 60, height: 60)

                                    Circle()
                                        .trim(from: 0, to: 0.0) // 0% progress
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color(hex: "#BF5AF2"), Color(hex: "#0A84FF")],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                                        )
                                        .frame(width: 60, height: 60)
                                        .rotationEffect(.degrees(-90))

                                    Text("0%")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(24)
                            .glassCard()
                            .padding(.horizontal, 24)

                            // Start Learning Button
                            Button {
                                // Navigate to study session
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 16, weight: .semibold))

                                    Text("Start Learning")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                            }
                            .liquidButton()
                            .padding(.horizontal, 24)
                        }

                        // Due Today Section
                        if !decks.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Due Today")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(decks.prefix(5)) { deck in
                                            DeckCardView(deck: deck)
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                }
                            }
                        } else {
                            // Empty State
                            VStack(spacing: 16) {
                                Image(systemName: "folder.badge.plus")
                                    .font(.system(size: 60))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color(hex: "#BF5AF2"), Color(hex: "#0A84FF")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )

                                Text("No decks yet")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)

                                Text("Create your first deck to start learning")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(Color(hex: "#8E8E93"))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 60)
                        }

                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                analytics.trackScreen("Home", context: modelContext)
            }
        }
    }

    private func greetingText() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            return "Good morning, \(userName)"
        case 12..<17:
            return "Good afternoon, \(userName)"
        default:
            return "Good evening, \(userName)"
        }
    }
}

struct DeckCardView: View {
    let deck: Deck

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: deck.icon)
                    .foregroundColor(Color(hex: deck.colorHex))

                Spacer()

                Text("\(deck.cards.count)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#8E8E93"))
            }

            Text(deck.name)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(2)
        }
        .padding(20)
        .frame(width: 180)
        .liquidGlass(cornerRadius: 20)
    }
}
