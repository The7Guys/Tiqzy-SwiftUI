import SwiftUI
import SwiftData

struct EventCard: View {
    let event: Event
    @Environment(\.modelContext) private var modelContext
    @State private var isFavorite: Bool = false // Tracks favorite state

    var body: some View {
        HStack(spacing: 0) { // Align image and details seamlessly
            // Event Image
            AsyncImage(url: URL(string: event.imageURL ?? "")) { phase in
                switch phase {
                case .empty:
                    Image("EventImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100)
                        .frame(maxHeight: .infinity)
                        .clipped()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100)
                        .frame(maxHeight: .infinity)
                        .clipped()
                case .failure:
                    Image("EventImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100)
                        .frame(maxHeight: .infinity)
                        .clipped()
                @unknown default:
                    EmptyView()
                }
            }

            // Event Details
            VStack(alignment: .leading, spacing: 8) {
                // Event Title and Favorite Button
                HStack {
                    Text(event.title)
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(Constants.Design.primaryColor)

                    Spacer()

                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .resizable() // Enable resizing of the image
                            .scaledToFit() // Keep the proportions
                            .frame(width: 22, height: 22) // Set custom size for the heart
                            .foregroundColor(isFavorite ? .red : Color.primary) // Adjust color
                    }
                    .onAppear {
                        isFavorite = isEventFavorite(event.id)
                    }                }

                // Location
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundColor(Constants.Design.primaryColor)

                    Text(event.location ?? "Unknown")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(Constants.Design.primaryColor)
                }

                // Description
                Text(event.summary)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(Constants.Design.primaryColor)
                    .lineLimit(2)

                // Duration and Price
                HStack {
                    // Time Icon and Duration
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundColor(Constants.Design.primaryColor)

                        Text(
                            formatDuration(event.duration)
                        )
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(Constants.Design.primaryColor)
                    }

                    Spacer()

                    // Price
                    Text("from \(String(format: "€%.2f", event.price ?? "Free"))")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(Constants.Design.primaryColor)
                }
            }
            .padding()
            .background(Constants.Design.backgroundColor) // Use background color from constants
        }
        .overlay( // Border with primary color
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Design.primaryColor, lineWidth: 2)
        )
        .cornerRadius(12)
    }

    // MARK: - Helper Methods for Favorites
    private func toggleFavorite() {
        if isFavorite {
            removeFavorite(eventID: event.id)
        } else {
            addFavorite(event)
        }
        isFavorite.toggle()
    }

    private func isEventFavorite(_ id: Int) -> Bool {
        let descriptor = FetchDescriptor<Event>(predicate: #Predicate { $0.id == id })
        return (try? modelContext.fetch(descriptor).first) != nil
    }

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

    private func removeFavorite(eventID: Int) {
        if let favoriteEvent = fetchEvent(by: eventID) {
            modelContext.delete(favoriteEvent)
            try? modelContext.save()
        }
    }

    private func fetchEvent(by id: Int) -> Event? {
        let descriptor = FetchDescriptor<Event>(predicate: #Predicate { $0.id == id })
        return try? modelContext.fetch(descriptor).first
    }

    // Helper function to format the duration
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
