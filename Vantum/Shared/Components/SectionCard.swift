import SwiftUI

struct SectionCard<Content: View>: View {
    let title: String
    let eyebrow: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(eyebrow)
                    .font(.caption.weight(.semibold))
                    .tracking(1.4)
                    .foregroundStyle(AppTheme.accentGold)

                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
            }

            content
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(AppTheme.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(AppTheme.cardStroke, lineWidth: 1)
        )
    }
}
