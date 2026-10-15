import SwiftUI

/// A colored square with the first letter of the brand. Used instead of can photos.
public struct BrandTile: View {
    let brand: String
    let size: CGFloat

    public init(brand: String, size: CGFloat = 44) {
        self.brand = brand
        self.size = size
    }

    public var body: some View {
        Text(String(brand.prefix(1)).uppercased())
            .font(.system(size: size * 0.45, weight: .heavy, design: .rounded))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(BrandPalette.color(for: brand), in: .rect(cornerRadius: size * 0.27, style: .continuous))
            .accessibilityHidden(true)   // the brand name is already next to the tile
    }
}

/// Six tile colors. The same brand always gets the same color (also in the Stats donut chart).
public enum BrandPalette {
    public static let colors: [Color] = [
        Color(red: 0x3D / 255, green: 0x5A / 255, blue: 0xFE / 255),
        Color(red: 0x4D / 255, green: 0x7C / 255, blue: 0x0F / 255),
        Color(red: 0xC2 / 255, green: 0x41 / 255, blue: 0x0C / 255),
        Color(red: 0xBE / 255, green: 0x18 / 255, blue: 0x5D / 255),
        Color(red: 0x0F / 255, green: 0x76 / 255, blue: 0x6E / 255),
        Color(red: 0x47 / 255, green: 0x55 / 255, blue: 0x69 / 255),
    ]

    /// Sum of unicode scalars modulo 6.
    /// Not `hashValue`: Swift randomizes hashes on every launch, so colors would change.
    public static func index(for brand: String) -> Int {
        brand.unicodeScalars.reduce(0) { $0 + Int($1.value) } % colors.count
    }

    public static func color(for brand: String) -> Color {
        colors[index(for: brand)]
    }
}

#Preview {
    HStack {
        BrandTile(brand: "Red Bull")
        BrandTile(brand: "Monster")
        BrandTile(brand: "Burn", size: 52)
    }
}
