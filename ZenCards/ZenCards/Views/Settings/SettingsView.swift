import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                // App Section
                Section {
                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        Label("Daily Reminder", systemImage: "bell")
                    }
                } header: {
                    Text("App")
                }

                // About Section
                Section {
                    Link(destination: URL(string: "https://zencards.app/privacy")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }

                    Link(destination: URL(string: "https://zencards.app/terms")!) {
                        Label("Terms of Use", systemImage: "doc.text")
                    }

                    Link(destination: URL(string: "mailto:support@zencards.app")!) {
                        Label("Support", systemImage: "envelope")
                    }

                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct NotificationSettingsView: View {
    @AppStorage("dailyReminderEnabled") private var isEnabled = false
    @AppStorage("dailyReminderTime") private var reminderTimeData = Data()
    @State private var reminderTime = Date()

    var body: some View {
        Form {
            Section {
                Toggle("Enable Daily Reminder", isOn: $isEnabled)

                if isEnabled {
                    DatePicker(
                        "Time",
                        selection: $reminderTime,
                        displayedComponents: .hourAndMinute
                    )
                    .onChange(of: reminderTime) { oldValue, newValue in
                        saveReminderTime(newValue)
                    }
                }
            } footer: {
                Text("Get notified daily to review your cards")
            }
        }
        .navigationTitle("Daily Reminder")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadReminderTime()
        }
    }

    private func loadReminderTime() {
        if let decoded = try? JSONDecoder().decode(Date.self, from: reminderTimeData) {
            reminderTime = decoded
        } else {
            // Default to 9:00 AM
            var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            components.hour = 9
            components.minute = 0
            reminderTime = Calendar.current.date(from: components) ?? Date()
        }
    }

    private func saveReminderTime(_ date: Date) {
        if let encoded = try? JSONEncoder().encode(date) {
            reminderTimeData = encoded
        }
        // TODO: Schedule local notification
    }
}
