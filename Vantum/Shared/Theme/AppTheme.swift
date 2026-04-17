import SwiftUI

enum AppTheme {
    static let accentGold = Color(hex: "D3B16B")
    static let accentTeal = Color(hex: "5FD6CB")
    static let backgroundTop = Color(hex: "05070A")
    static let backgroundBottom = Color(hex: "0B1118")
    static let cardBackground = Color(hex: "121A23").opacity(0.94)
    static let cardStroke = Color.white.opacity(0.10)
    static let inputBackground = Color(hex: "18212B")
    static let secondaryText = Color(hex: "B9C1CC")
    static let tertiaryText = Color(hex: "7C8795")

    static var sceneBackground: some View {
        ZStack {
            LinearGradient(
                colors: [backgroundTop, backgroundBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RadialGradient(
                colors: [accentGold.opacity(0.18), .clear],
                center: .topTrailing,
                startRadius: 24,
                endRadius: 320
            )

            RadialGradient(
                colors: [accentTeal.opacity(0.14), .clear],
                center: .bottomLeading,
                startRadius: 24,
                endRadius: 280
            )
        }
    }
}
