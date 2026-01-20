import SwiftUI
import WidgetKit

struct ZenCardsWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: CardEntry

    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                SmallWidgetView(entry: entry)
            case .systemMedium:
                MediumWidgetView(entry: entry)
            case .systemLarge:
                LargeWidgetView(entry: entry)
            default:
                MediumWidgetView(entry: entry)
            }
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

// MARK: - Small Widget
struct SmallWidgetView: View {
    let entry: CardEntry

    var body: some View {
        VStack(spacing: 8) {
            if let card = entry.card {
                Image(systemName: "brain.head.profile")
                    .font(.title)
                    .foregroundStyle(Color(hex: "#14B8A6"))

                Text("\(entry.dueCount)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: "#14B8A6"))

                Text("due")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color(hex: "#14B8A6"))
                Text("All Done!")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
        }
        .padding(12)
    }
}

// MARK: - Medium Widget
struct MediumWidgetView: View {
    let entry: CardEntry

    var body: some View {
        if let card = entry.card {
            VStack(spacing: 12) {
                // Header with progress
                HStack {
                    Image(systemName: "brain.head.profile")
                        .foregroundStyle(Color(hex: "#14B8A6"))
                    Text("\(entry.dueCount) left")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }

                // Card question
                Text(card.front)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Action buttons
                HStack(spacing: 8) {
                    Button(intent: RateCardIntent(cardID: card.id, rating: 2)) {
                        Label("Hard", systemImage: "minus")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(.thickMaterial)
                            .foregroundStyle(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.orange, lineWidth: 2)
                            )
                    }
                    .buttonStyle(.plain)

                    Button(intent: RateCardIntent(cardID: card.id, rating: 4)) {
                        Label("Easy", systemImage: "checkmark")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(.thickMaterial)
                            .foregroundStyle(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.green, lineWidth: 2)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        } else {
            // No cards due
            VStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color(hex: "#14B8A6"))
                Text("All Done!")
                    .font(.headline)
                Text("No cards due right now")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
        }
    }
}

// MARK: - Large Widget
struct LargeWidgetView: View {
    let entry: CardEntry

    var body: some View {
        if let card = entry.card {
            VStack(spacing: 16) {
                // Header
                HStack {
                    Image(systemName: "brain.head.profile")
                        .foregroundStyle(Color(hex: "#14B8A6"))
                    Text("\(entry.dueCount) cards left")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }

                // Card front (question)
                VStack(spacing: 12) {
                    Text(card.front)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .frame(maxWidth: .infinity)

                    Divider()

                    // Card back (answer)
                    Text(card.back)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .frame(maxWidth: .infinity)
                }
                .padding(16)
                .frame(maxHeight: .infinity)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // Action buttons (all 4 ratings)
                HStack(spacing: 8) {
                    Button(intent: RateCardIntent(cardID: card.id, rating: 1)) {
                        VStack(spacing: 4) {
                            Image(systemName: "xmark")
                            Text("Again")
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.thickMaterial)
                        .foregroundStyle(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.red, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)

                    Button(intent: RateCardIntent(cardID: card.id, rating: 2)) {
                        VStack(spacing: 4) {
                            Image(systemName: "minus")
                            Text("Hard")
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.thickMaterial)
                        .foregroundStyle(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.orange, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)

                    Button(intent: RateCardIntent(cardID: card.id, rating: 3)) {
                        VStack(spacing: 4) {
                            Image(systemName: "hand.thumbsup")
                            Text("Good")
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.thickMaterial)
                        .foregroundStyle(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.blue, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)

                    Button(intent: RateCardIntent(cardID: card.id, rating: 4)) {
                        VStack(spacing: 4) {
                            Image(systemName: "checkmark")
                            Text("Easy")
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.thickMaterial)
                        .foregroundStyle(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.green, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        } else {
            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Color(hex: "#14B8A6"))
                Text("All Done!")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("No cards due right now. Great work!")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
        }
    }
}

// Color extension for widget (duplicate from main app)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
