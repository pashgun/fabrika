import SwiftUI
import SwiftData

struct LibraryView: View {
    @Query private var decks: [Deck]
    @State private var searchText = ""
    @State private var selectedFilter: FilterOption = .all

    enum FilterOption: String, CaseIterable {
        case all = "All"
        case recent = "Recent"
        case favorites = "Favorites"
    }

    var filteredDecks: [Deck] {
        var result = decks

        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }

        switch selectedFilter {
        case .recent:
            result = result.sorted { ($0.lastStudied ?? .distantPast) > ($1.lastStudied ?? .distantPast) }
        case .favorites:
            // Would need a favorites property in Deck model
            break
        case .all:
            break
        }

        return result
    }

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                VStack(spacing: 0) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(hex: "#8E8E93"))

                        TextField("Search decks...", text: $searchText)
                            .foregroundColor(.white)
                    }
                    .padding(12)
                    .liquidGlass(cornerRadius: 12)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)

                    // Filter Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(FilterOption.allCases, id: \.self) { option in
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedFilter = option
                                    }
                                } label: {
                                    Text(option.rawValue)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(selectedFilter == option ? .white : Color(hex: "#8E8E93"))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(
                                            selectedFilter == option ?
                                            LinearGradient(
                                                colors: [Color(hex: "#BF5AF2"), Color(hex: "#0A84FF")],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ) :
                                            LinearGradient(colors: [Color.clear], startPoint: .top, endPoint: .bottom)
                                        )
                                        .clipShape(Capsule())
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.white.opacity(selectedFilter == option ? 0 : 0.2), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 16)

                    // Decks Grid
                    if filteredDecks.isEmpty {
                        Spacer()

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

                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(filteredDecks) { deck in
                                    DeckGridCard(deck: deck)
                                }
                            }
                            .padding(24)
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct DeckGridCard: View {
    let deck: Deck

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: deck.icon)
                    .foregroundColor(Color(hex: deck.colorHex))
                    .font(.system(size: 24))

                Spacer()

                // Progress Ring
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 3)
                        .frame(width: 32, height: 32)

                    Text("\(deck.cards.count)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
            }

            Text(deck.name)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(2)

            if let lastStudied = deck.lastStudied {
                Text("Last studied \(timeAgo(lastStudied))")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(hex: "#8E8E93"))
            } else {
                Text("Not studied yet")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(hex: "#8E8E93"))
            }
        }
        .padding(16)
        .liquidGlass(cornerRadius: 16)
    }

    private func timeAgo(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .hour], from: date, to: now)

        if let days = components.day, days > 0 {
            return "\(days)d ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours)h ago"
        } else {
            return "Just now"
        }
    }
}
