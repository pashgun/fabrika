import SwiftUI
import SwiftData

struct PersonalizationView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedGoal: LearningGoal?
    @Binding var selectedMinutes: Int?
    @Binding var selectedInterests: Set<String>
    @Binding var currentStep: Int
    @State private var userName: String = ""
    let onComplete: () -> Void

    let goals: [(LearningGoal, String, String)] = [
        (.exams, "🎓", "Ace my exams"),
        (.language, "🗣️", "Learn a language"),
        (.professional, "💼", "Professional growth"),
        (.general, "🧠", "General knowledge")
    ]

    let timeOptions: [(Int, String, String)] = [
        (5, "⚡", "Quick learner"),
        (15, "☕", "Steady pace"),
        (30, "📚", "Dedicated"),
        (60, "🚀", "Power user")
    ]

    let interests = [
        "Science", "History", "Languages", "Math",
        "Medicine", "Law", "Art", "Tech",
        "Business", "Music"
    ]

    var body: some View {
        ZStack {
            MeshBackground()

            VStack(spacing: 32) {
                // Title
                VStack(spacing: 8) {
                    Text(currentStep == 0 ? "What's your name?" :
                         currentStep == 1 ? "What's your goal?" :
                         currentStep == 2 ? "How much time per day?" :
                         "What interests you?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    if currentStep == 3 {
                        Text("Select multiple")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color(hex: "#8E8E93"))
                    }
                }
                .padding(.top, 80)

                Spacer()

                // Content
                if currentStep == 0 {
                    // Name Input
                    VStack(spacing: 16) {
                        TextField("Your name", text: $userName)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(20)
                            .liquidGlass(cornerRadius: 20)
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                    }
                    .padding(.horizontal, 32)

                } else if currentStep == 1 {
                    // Goal Selection
                    VStack(spacing: 16) {
                        ForEach(goals, id: \.0) { goal, emoji, title in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedGoal = goal
                                }
                            } label: {
                                HStack(spacing: 16) {
                                    Text(emoji)
                                        .font(.system(size: 32))

                                    Text(title)
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.white)

                                    Spacer()

                                    if selectedGoal == goal {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(Color(hex: "#30D158"))
                                    }
                                }
                                .padding(20)
                                .liquidGlass(cornerRadius: 20)
                            }
                        }
                    }
                    .padding(.horizontal, 32)

                } else if currentStep == 2 {
                    // Time Selection
                    VStack(spacing: 16) {
                        ForEach(timeOptions, id: \.0) { minutes, emoji, title in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedMinutes = minutes
                                }
                            } label: {
                                HStack(spacing: 16) {
                                    Text(emoji)
                                        .font(.system(size: 32))

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(minutes) min")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundColor(.white)

                                        Text(title)
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(Color(hex: "#8E8E93"))
                                    }

                                    Spacer()

                                    if selectedMinutes == minutes {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(Color(hex: "#30D158"))
                                    }
                                }
                                .padding(20)
                                .liquidGlass(cornerRadius: 20)
                            }
                        }
                    }
                    .padding(.horizontal, 32)

                } else {
                    // Interests Selection
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(interests, id: \.self) { interest in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    if selectedInterests.contains(interest) {
                                        selectedInterests.remove(interest)
                                    } else {
                                        selectedInterests.insert(interest)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(interest)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(selectedInterests.contains(interest) ? .white : Color(hex: "#8E8E93"))

                                    if selectedInterests.contains(interest) {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color(hex: "#30D158"))
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .liquidGlass(cornerRadius: 16)
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                }

                Spacer()

                // Continue Button
                Button {
                    if currentStep < 3 {
                        withAnimation {
                            currentStep += 1
                        }
                    } else {
                        // Create user before completing
                        if let goal = selectedGoal, let dailyMinutes = selectedMinutes {
                            _ = UserService.createUser(
                                name: userName.isEmpty ? "Friend" : userName,
                                email: "", // Will be collected during actual sign up
                                goal: goal,
                                dailyMinutes: dailyMinutes,
                                interests: Array(selectedInterests),
                                in: modelContext
                            )
                        }
                        onComplete()
                    }
                } label: {
                    Text(currentStep < 3 ? "Continue" : "Get Started")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .liquidButton()
                .padding(.horizontal, 32)
                .disabled(
                    (currentStep == 0 && userName.isEmpty) ||
                    (currentStep == 1 && selectedGoal == nil) ||
                    (currentStep == 2 && selectedMinutes == nil)
                )
                .opacity(
                    (currentStep == 0 && userName.isEmpty) ||
                    (currentStep == 1 && selectedGoal == nil) ||
                    (currentStep == 2 && selectedMinutes == nil) ? 0.5 : 1.0
                )

                Spacer().frame(height: 60)
            }
        }
    }
}
