import SwiftUI

/// Extends the `Color` structure to allow initialization using a hex string.
extension Color {
    /// Initializes a `Color` instance from a hex string.
    /// - Parameter hex: A hex string representing the color (e.g., "#RRGGBB" or "RRGGBB").
    init(hex: String) {
        // Trim any whitespace or newline characters from the hex string.
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        
        // Check if the hex string starts with a "#" and skip it.
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }
        
        // Convert the hex string into an integer value.
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        // Extract the red, green, and blue components from the integer.
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        // Initialize the color using the extracted RGB values.
        self.init(red: red, green: green, blue: blue)
    }
}

// MARK: - Image Cache for Efficient Loading
/// A shared image cache to store downloaded images for reuse.
class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}

// MARK: - UIImage Extension for Network Loading
extension UIImage {
    /// Loads an image from a URL, with caching support.
    /// - Parameters:
    ///   - url: The URL to load the image from.
    ///   - completion: A closure called with the loaded `UIImage` or `nil` if loading fails.
    static func load(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Check if the image is already cached.
        if let cachedImage = ImageCache.shared.object(forKey: url as NSURL) {
            completion(cachedImage)
            return
        }

        // Download the image if it's not cached.
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                ImageCache.shared.setObject(image, forKey: url as NSURL) // Cache the image.
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil) // Call completion with nil if loading fails.
                }
            }
        }
    }
}
