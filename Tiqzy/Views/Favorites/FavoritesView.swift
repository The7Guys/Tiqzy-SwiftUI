import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext // Access SwiftData context
    @Query var favorites: [Event] // Fetch favorite events
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // Title
                Text("Your Favorite Events")
                    .font(.custom("Poppins-SemiBold", size: 28))
                    .foregroundColor(Constants.Design.primaryColor)
                    .padding(.horizontal)
                    .padding(.top)
                
                if favorites.isEmpty {
                    // Improved "No Favorites" UI - Adjusted for content position
                    VStack(spacing: 20) {
                        Image("EmptyFavorites") // Add a placeholder image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding(.top, 40) // Slightly more space from the title

                        Text("No favorite events yet!")
                            .font(.custom("Poppins-SemiBold", size: 20))
                            .foregroundColor(Constants.Design.primaryColor)
                            .multilineTextAlignment(.center)

                        Text("Start exploring and add events to your favorites to see them here.")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxHeight: .infinity, alignment: .top) // Align content closer to the top
                } else {
                    // Display favorite events using EventCard
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(favorites) { favorite in
                                NavigationLink(destination: EventDetailView(eventID: favorite.id)) {
                                    EventCard(event: favorite)
                                }
                                .buttonStyle(PlainButtonStyle()) // To prevent the default button style
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}
