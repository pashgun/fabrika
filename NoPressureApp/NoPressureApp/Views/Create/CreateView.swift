import SwiftUI

struct CreateView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                VStack(spacing: 24) {
                    Text("Create Flashcards")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 60)

                    Spacer()

                    // Three input options
                    VStack(spacing: 16) {
                        CreateOptionCard(
                            icon: "camera.fill",
                            emoji: "📷",
                            title: "Camera",
                            subtitle: "Snap notes or textbook"
                        )

                        CreateOptionCard(
                            icon: "doc.fill",
                            emoji: "📄",
                            title: "PDF",
                            subtitle: "Import documents"
                        )

                        CreateOptionCard(
                            icon: "text.alignleft",
                            emoji: "✍️",
                            title: "Text",
                            subtitle: "Paste or type"
                        )
                    }
                    .padding(.horizontal, 24)

                    Spacer()

                    Button {
                        // Navigate to manual creation
                    } label: {
                        Text("Create Manually")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(hex: "#0A84FF"))
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct CreateOptionCard: View {
    let icon: String
    let emoji: String
    let title: String
    let subtitle: String

    var body: some View {
        Button {
            // Handle create action
        } label: {
            HStack(spacing: 16) {
                Text(emoji)
                    .font(.system(size: 40))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    Text(subtitle)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "#8E8E93"))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: "#8E8E93"))
            }
            .padding(24)
            .glassCard()
        }
    }
}
