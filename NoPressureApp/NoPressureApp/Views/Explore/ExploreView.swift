import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""

    let categories = [
        ("Languages", "globe", "#0A84FF"),
        ("Science", "atom", "#30D158"),
        ("Math", "function", "#FF9F0A"),
        ("History", "clock.fill", "#BF5AF2"),
        ("Medicine", "cross.case.fill", "#FF375F"),
        ("Tech", "laptopcomputer", "#0A84FF")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                ScrollView {
                    VStack(spacing: 24) {
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(hex: "#8E8E93"))

                            TextField("Search topics...", text: $searchText)
                                .foregroundColor(.white)
                        }
                        .padding(12)
                        .liquidGlass(cornerRadius: 12)
                        .padding(.horizontal, 24)
                        .padding(.top, 20)

                        // Categories
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Browse Categories")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(categories, id: \.0) { category in
                                    CategoryCard(
                                        title: category.0,
                                        icon: category.1,
                                        color: category.2
                                    )
                                }
                            }
                            .padding(.horizontal, 24)
                        }

                        // Featured Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Featured Decks")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)

                            Text("Coming soon...")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(Color(hex: "#8E8E93"))
                                .padding(.horizontal, 24)
                        }

                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct CategoryCard: View {
    let title: String
    let icon: String
    let color: String

    var body: some View {
        Button {
            // Navigate to category
        } label: {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: color))

                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .liquidGlass(cornerRadius: 16)
        }
    }
}
