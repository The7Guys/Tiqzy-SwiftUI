import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext // Access SwiftData context
    @Query var favorites: [FavoriteEvent] // Fetch favorite events

    var body: some View {
        VStack(alignment: .leading) {
            // Title
            Text("Your Favorite Events")
                .font(.custom("Poppins-SemiBold", size: 28))
                .foregroundColor(Constants.Design.primaryColor)
                .padding(.horizontal)
                .padding(.top)

            if favorites.isEmpty {
                // No favorites to display
                VStack(spacing: 16) {
                    Text("No favorite events yet!")
                        .font(.custom("Poppins-Regular", size: 18))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    Text("Explore events and add them to your favorites to see them here.")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                // Display favorite events using EventCard
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(favorites) { favorite in
                            EventCard(event: favorite)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
