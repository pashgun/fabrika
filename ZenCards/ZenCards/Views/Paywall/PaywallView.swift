import SwiftUI
import Adapty

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var subscriptionService: SubscriptionService
    @State private var paywall: AdaptyPaywall?
    @State private var products: [AdaptyPaywallProduct] = []
    @State private var isLoading = true
    @State private var selectedProduct: AdaptyPaywallProduct?
    @State private var isPurchasing = false
    @State private var errorMessage: String?
    @State private var showError = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(hex: "#14B8A6").opacity(0.3),
                    Color(hex: "#10B981").opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 64))
                            .foregroundStyle(Color(hex: "#14B8A6"))

                        Text("Unlock Your Potential")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)

                        Text("Master any subject with spaced repetition")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 32)

                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(
                            icon: "sparkles",
                            title: "Modern FSRS Algorithm",
                            description: "Scientifically proven spaced repetition"
                        )

                        FeatureRow(
                            icon: "apps.iphone",
                            title: "Interactive Home Screen Widget",
                            description: "Review cards without opening the app"
                        )

                        FeatureRow(
                            icon: "infinity",
                            title: "Unlimited Cards & Decks",
                            description: "Create as many flashcards as you need"
                        )

                        FeatureRow(
                            icon: "speaker.wave.2",
                            title: "Text-to-Speech",
                            description: "Hear pronunciations for better learning"
                        )
                    }
                    .padding(20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 16)

                    // Products
                    if isLoading {
                        ProgressView()
                            .padding()
                    } else {
                        VStack(spacing: 12) {
                            ForEach(products, id: \.vendorProductId) { product in
                                ProductCard(
                                    product: product,
                                    isSelected: selectedProduct?.vendorProductId == product.vendorProductId
                                )
                                .onTapGesture {
                                    selectedProduct = product
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // CTA Button
                    if let selected = selectedProduct {
                        PrimaryButton(
                            label: "Start Learning",
                            action: { purchase(selected) },
                            isLoading: isPurchasing
                        )
                        .padding(.horizontal, 16)
                    }

                    // Footer
                    VStack(spacing: 8) {
                        Button("Restore Purchases") {
                            restorePurchases()
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .disabled(isPurchasing)

                        HStack(spacing: 16) {
                            Button("Privacy Policy") {
                                // Open privacy policy
                            }
                            Text("•")
                            Button("Terms of Use") {
                                // Open terms
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 32)
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "An error occurred")
        }
        .task {
            await loadPaywall()
        }
    }

    private func loadPaywall() async {
        do {
            let paywall = try await Adapty.getPaywall(placementId: "main_paywall")
            let products = try await Adapty.getPaywallProducts(paywall: paywall)

            await MainActor.run {
                self.paywall = paywall
                self.products = products
                self.selectedProduct = products.first // Auto-select first
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load paywall: \(error.localizedDescription)"
                self.showError = true
                self.isLoading = false
            }
        }
    }

    private func purchase(_ product: AdaptyPaywallProduct) {
        isPurchasing = true
        errorMessage = nil

        Task {
            do {
                let profile = try await Adapty.makePurchase(product: product)

                await MainActor.run {
                    if profile.accessLevels["premium"]?.isActive == true {
                        // Premium unlocked!
                        subscriptionService.isPremium = true
                        dismiss()
                    } else {
                        self.errorMessage = "Purchase failed. Please try again."
                        self.showError = true
                    }
                    self.isPurchasing = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isPurchasing = false
                }
            }
        }
    }

    private func restorePurchases() {
        isPurchasing = true
        errorMessage = nil

        Task {
            do {
                let isPremium = try await subscriptionService.restorePurchases()

                await MainActor.run {
                    if isPremium {
                        dismiss()
                    } else {
                        self.errorMessage = "No purchases found to restore."
                        self.showError = true
                    }
                    self.isPurchasing = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Restore failed: \(error.localizedDescription)"
                    self.showError = true
                    self.isPurchasing = false
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color(hex: "#14B8A6"))
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct ProductCard: View {
    let product: AdaptyPaywallProduct
    let isSelected: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(product.localizedTitle)
                    .font(.headline)
                Text(product.localizedDescription ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text(product.localizedPrice ?? "")
                    .font(.title3)
                    .fontWeight(.bold)

                if let period = product.subscriptionPeriod {
                    if period.unit == .month {
                        Text("/month")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else if period.unit == .year {
                        Text("/year")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(16)
        .background(
            isSelected ? Color(hex: "#14B8A6").opacity(0.2) : Color.clear
        )
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    isSelected ? Color(hex: "#14B8A6") : Color.clear,
                    lineWidth: 2
                )
        )
    }
}
