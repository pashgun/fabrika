import SwiftUI

struct MeshBackground: View {
    var body: some View {
        ZStack {
            Color.black

            Circle()
                .fill(Color(hex: "#BF5AF2").opacity(0.4))
                .blur(radius: 100)
                .offset(x: -100, y: -200)

            Circle()
                .fill(Color(hex: "#0A84FF").opacity(0.3))
                .blur(radius: 100)
                .offset(x: 100, y: 200)

            Circle()
                .fill(Color(hex: "#FF375F").opacity(0.2))
                .blur(radius: 80)
                .offset(x: 0, y: 0)
        }
        .ignoresSafeArea()
    }
}
