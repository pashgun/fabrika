import SwiftUI

enum StudyMode: String, CaseIterable, Identifiable {
    case flashcard = "Flashcard"
    case quiz = "Quiz"
    case write = "Write"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .flashcard: return "rectangle.stack.fill"
        case .quiz: return "list.bullet.rectangle.fill"
        case .write: return "pencil.line"
        }
    }

    var description: String {
        switch self {
        case .flashcard: return "Flip cards to learn"
        case .quiz: return "Multiple choice questions"
        case .write: return "Type your answers"
        }
    }
}

struct StudyModeSelector: View {
    @Binding var selectedMode: StudyMode

    var body: some View {
        VStack(spacing: 12) {
            Text("Study Mode")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(hex: "#8E8E93"))
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                ForEach(StudyMode.allCases) { mode in
                    ModeButton(
                        mode: mode,
                        isSelected: selectedMode == mode
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedMode = mode
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

struct ModeButton: View {
    let mode: StudyMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: mode.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isSelected ? .white : Color(hex: "#8E8E93"))

                Text(mode.rawValue)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(isSelected ? .white : Color(hex: "#8E8E93"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color(hex: "#0A84FF").opacity(0.3) : Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(
                                isSelected ? Color(hex: "#0A84FF") : Color.white.opacity(0.2),
                                lineWidth: 2
                            )
                    )
            )
        }
    }
}

#Preview {
    @Previewable @State var mode = StudyMode.flashcard

    return ZStack {
        MeshBackground()

        VStack {
            StudyModeSelector(selectedMode: $mode)
            Spacer()
        }
        .padding(.top, 100)
    }
}
