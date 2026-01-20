import Adapty
import SwiftUI

@MainActor
class SubscriptionService: ObservableObject {
    @Published var isPremium: Bool = false
    @Published var isLoading: Bool = true

    init() {
        checkAccess()
    }

    func checkAccess() {
        isLoading = true
        Task {
            do {
                let profile = try await Adapty.getProfile()
                await MainActor.run {
                    self.isPremium = profile.accessLevels["premium"]?.isActive == true
                    self.isLoading = false
                }
            } catch {
                print("Failed to check access: \(error)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }

    func restorePurchases() async throws -> Bool {
        let profile = try await Adapty.restorePurchases()
        let isPremium = profile.accessLevels["premium"]?.isActive == true
        await MainActor.run {
            self.isPremium = isPremium
        }
        return isPremium
    }
}
