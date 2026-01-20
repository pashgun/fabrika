import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var subscriptionService: SubscriptionService
    @State private var showRestoreSuccess = false
    @State private var showRestoreError = false
    @State private var isRestoring = false

    var body: some View {
        NavigationStack {
            Form {
                // Account Section
                Section {
                    if subscriptionService.isPremium {
                        Label {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Premium Active")
                                    .font(.body)
                                Text("Thank you for your support!")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color(hex: "#14B8A6"))
                        }

                        Button("Manage Subscription") {
                            openSubscriptionManagement()
                        }
                    } else {
                        Label("Free Account", systemImage: "person")
                    }

                    Button {
                        restorePurchases()
                    } label: {
                        HStack {
                            Text("Restore Purchases")
                            Spacer()
                            if isRestoring {
                                ProgressView()
                                    .controlSize(.small)
                            }
                        }
                    }
                    .disabled(isRestoring)
                } header: {
                    Text("Account")
                }

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
            .alert("Purchases Restored", isPresented: $showRestoreSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your purchases have been restored successfully.")
            }
            .alert("Restore Failed", isPresented: $showRestoreError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("No purchases found to restore.")
            }
        }
    }

    private func restorePurchases() {
        isRestoring = true

        Task {
            do {
                let isPremium = try await subscriptionService.restorePurchases()

                await MainActor.run {
                    isRestoring = false
                    if isPremium {
                        showRestoreSuccess = true
                    } else {
                        showRestoreError = true
                    }
                }
            } catch {
                await MainActor.run {
                    isRestoring = false
                    showRestoreError = true
                }
            }
        }
    }

    private func openSubscriptionManagement() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            Task {
                do {
                    try await AppStore.showManageSubscriptions(in: scene)
                } catch {
                    print("Failed to open subscription management: \(error)")
                }
            }
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
