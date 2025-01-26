import SwiftUI
import SwiftData

// MARK: - EventCard View
/// A view representing an event card with image, title, and details.
struct EventCard: View {
    let event: Event
    @Environment(\.modelContext) private var modelContext
    @State private var isFavorite: Bool = false // Tracks if the event is marked as favorite.
    @State private var preloadedImage: UIImage? // Stores the preloaded image.

    var body: some View {
        HStack(spacing: 0) {
            // Display the preloaded image or a placeholder if not yet loaded.
            if let image = preloadedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100)
                    .frame(maxHeight: .infinity)
                    .clipped()
            } else {
                Image("EventImage") // Placeholder image.
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100)
                    .frame(maxHeight: .infinity)
                    .clipped()
                    .onAppear {
                        preloadImage() // Start preloading the image.
                    }
            }

            VStack(alignment: .leading, spacing: 8) {
                // Event Title and Favorite Button
                HStack {
                    Text(event.title)
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(Constants.Design.primaryColor)
                    Spacer()
                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                            .foregroundColor(isFavorite ? .red : Color.primary)
                    }
                    .onAppear {
                        isFavorite = isEventFavorite(event.id) // Check if the event is a favorite.
                    }
                }

                // Event Location
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(Constants.Design.primaryColor)
                    Text(event.location ?? "Unknown")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(Constants.Design.primaryColor)
                }

                // Event Summary
                Text(event.summary)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(Constants.Design.primaryColor)
                    .lineLimit(2)

                // Event Duration and Price
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundColor(Constants.Design.primaryColor)
                        Text(formatDuration(event.duration))
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(Constants.Design.primaryColor)
                    }
                    Spacer()
                    Text("from \(String(format: "€%.2f", event.price ?? 0.0))")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(Constants.Design.primaryColor)
                }
            }
            .padding()
            .background(Constants.Design.backgroundColor)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Design.primaryColor, lineWidth: 2)
        )
        .cornerRadius(12)
    }

    // MARK: - Image Preloading
    /// Preloads the event image from the provided URL.
    private func preloadImage() {
        guard let url = URL(string: event.imageURL ?? "") else { return }
        UIImage.load(from: url) { image in
            preloadedImage = image // Set the loaded image to the state.
        }
    }

    // MARK: - Favorites Management
    /// Toggles the favorite state of the event.
    private func toggleFavorite() {
        if isFavorite {
            removeFavorite(eventID: event.id)
        } else {
            addFavorite(event)
        }
        isFavorite.toggle()
    }

    /// Checks if an event is marked as a favorite.
    private func isEventFavorite(_ id: Int) -> Bool {
        let descriptor = FetchDescriptor<Event>(predicate: #Predicate { $0.id == id })
        return (try? modelContext.fetch(descriptor).first) != nil
    }

    /// Adds an event to the favorites list.
    private func addFavorite(_ event: Event) {
        let favoriteEvent = Event(
            id: event.id,
            title: event.title,
            summary: event.summary,
            startDate: event.startDate,
            endDate: event.endDate,
            venueAddress: event.venueAddress,
            location: event.location,
            duration: event.duration,
            imageURL: event.imageURL,
            price: event.price,
            stock: event.stock,
            category: event.category,
            isFavorite: true
        )
        modelContext.insert(favoriteEvent)
        try? modelContext.save()
    }

    /// Removes an event from the favorites list.
    private func removeFavorite(eventID: Int) {
        if let favoriteEvent = fetchEvent(by: eventID) {
            modelContext.delete(favoriteEvent)
            try? modelContext.save()
        }
    }

    /// Fetches an event by its ID from the model context.
    private func fetchEvent(by id: Int) -> Event? {
        let descriptor = FetchDescriptor<Event>(predicate: #Predicate { $0.id == id })
        return try? modelContext.fetch(descriptor).first
    }

    // MARK: - Helper Functions
    /// Formats the event duration in minutes into a human-readable string.
    private func formatDuration(_ durationInMinutes: Int) -> String {
        if durationInMinutes < 60 {
            return "\(durationInMinutes) minutes"
        } else {
            let hours = durationInMinutes / 60
            let minutes = durationInMinutes % 60
            return minutes == 0 ? "\(hours) hours" : "\(hours)h \(minutes)m"
        }
    }
}
