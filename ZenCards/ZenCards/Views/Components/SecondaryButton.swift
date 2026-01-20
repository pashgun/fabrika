import SwiftUI

struct SecondaryButton: View {
    let label: String
    let systemImage: String?
    let action: () -> Void

    init(
        label: String,
        systemImage: String? = nil,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.systemImage = systemImage
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let image = systemImage {
                    Image(systemName: image)
                }
                Text(label)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(.thickMaterial)
            .foregroundStyle(Color(hex: "#14B8A6"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color(hex: "#14B8A6"), lineWidth: 2)
            )
        }
    }
}
