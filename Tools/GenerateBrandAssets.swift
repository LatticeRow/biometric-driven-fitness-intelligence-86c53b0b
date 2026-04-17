import AppKit
import Foundation

struct Palette {
    static let backgroundTop = NSColor(srgbRed: 0.03, green: 0.04, blue: 0.07, alpha: 1.0)
    static let backgroundBottom = NSColor(srgbRed: 0.07, green: 0.10, blue: 0.15, alpha: 1.0)
    static let gold = NSColor(srgbRed: 0.84, green: 0.71, blue: 0.46, alpha: 1.0)
    static let goldHighlight = NSColor(srgbRed: 0.95, green: 0.86, blue: 0.67, alpha: 1.0)
    static let teal = NSColor(srgbRed: 0.37, green: 0.84, blue: 0.80, alpha: 1.0)
    static let stroke = NSColor.white.withAlphaComponent(0.12)
}

func makeMarkImage(size: CGFloat) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()

    let rect = NSRect(x: 0, y: 0, width: size, height: size)
    NSGraphicsContext.current?.imageInterpolation = .high

    let background = NSGradient(colors: [Palette.backgroundTop, Palette.backgroundBottom])!
    background.draw(in: rect, angle: 270)

    let topGlow = NSBezierPath(ovalIn: NSRect(x: size * 0.12, y: size * 0.46, width: size * 0.76, height: size * 0.46))
    Palette.goldHighlight.withAlphaComponent(0.08).setFill()
    topGlow.fill()

    let glow = NSBezierPath(ovalIn: rect.insetBy(dx: size * 0.18, dy: size * 0.18))
    Palette.teal.withAlphaComponent(0.10).setFill()
    glow.fill()

    let ringRect = rect.insetBy(dx: size * 0.17, dy: size * 0.17)
    let ring = NSBezierPath(ovalIn: ringRect)
    ring.lineWidth = max(12, size * 0.022)
    Palette.stroke.setStroke()
    ring.stroke()

    let innerRing = NSBezierPath(ovalIn: rect.insetBy(dx: size * 0.26, dy: size * 0.26))
    innerRing.lineWidth = max(4, size * 0.008)
    Palette.gold.withAlphaComponent(0.18).setStroke()
    innerRing.stroke()

    let centerX = size / 2
    let bottomY = size * 0.28
    let peakY = size * 0.74
    let spread = size * 0.18

    let monogram = NSBezierPath()
    monogram.move(to: NSPoint(x: centerX - spread, y: peakY))
    monogram.line(to: NSPoint(x: centerX, y: bottomY))
    monogram.line(to: NSPoint(x: centerX + spread, y: peakY))
    monogram.lineWidth = max(30, size * 0.052)
    monogram.lineCapStyle = .round
    monogram.lineJoinStyle = .round

    NSGraphicsContext.saveGraphicsState()
    let shadow = NSShadow()
    shadow.shadowBlurRadius = size * 0.06
    shadow.shadowColor = Palette.teal.withAlphaComponent(0.28)
    shadow.shadowOffset = .zero
    shadow.set()
    let goldGradient = NSGradient(colors: [Palette.goldHighlight, Palette.gold])!
    goldGradient.draw(in: monogram, angle: 270)
    monogram.stroke()
    NSGraphicsContext.restoreGraphicsState()

    let innerLine = NSBezierPath()
    innerLine.move(to: NSPoint(x: centerX, y: bottomY + size * 0.02))
    innerLine.line(to: NSPoint(x: centerX, y: peakY - size * 0.08))
    innerLine.lineWidth = max(10, size * 0.016)
    innerLine.lineCapStyle = .round
    Palette.teal.setStroke()
    innerLine.stroke()

    image.unlockFocus()
    return image
}

func pngData(from image: NSImage) -> Data? {
    guard let tiff = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiff) else {
        return nil
    }

    return bitmap.representation(using: .png, properties: [:])
}

func saveImage(_ image: NSImage, to path: String) throws {
    guard let data = pngData(from: image) else {
        throw NSError(domain: "GenerateBrandAssets", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to encode PNG."])
    }

    try data.write(to: URL(fileURLWithPath: path))
}

let arguments = CommandLine.arguments
guard arguments.count == 3 else {
    fputs("usage: swift GenerateBrandAssets.swift <icon-output> <launch-output>\n", stderr)
    exit(1)
}

do {
    try saveImage(makeMarkImage(size: 1024), to: arguments[1])
    try saveImage(makeMarkImage(size: 768), to: arguments[2])
} catch {
    fputs("error: \(error.localizedDescription)\n", stderr)
    exit(1)
}
