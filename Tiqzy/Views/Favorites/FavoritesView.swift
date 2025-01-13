import SwiftUI

struct FavoritesView: View {
    @State private var isLoggedIn = false // Replace with actual logic for user login status

    var body: some View {
        VStack {
            if isLoggedIn {
                // Display Favorites Content
                Text("Your Favorites")
                    .font(.title)
                    .foregroundColor(.red)
            } else {
                // Display Login Prompt
                VStack(spacing: 16) {
                    Text("Sorry, you need to log in to view your favorites.")
                        .font(.custom("Poppins-Regular", size: 18))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)

                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .font(.custom("Poppins-SemiBold", size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .background(Constants.Design.primaryColor)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
