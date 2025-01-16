import SwiftUI

struct FavoritesView: View {
    @State private var isLoggedIn = false // Track user login status
    @State private var errorMessage: String? // Track error messages

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

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

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
        .onAppear {
            checkAuthentication()
        }
    }

    // MARK: - Check Authentication
    private func checkAuthentication() {
        do {
            _ = try AuthManager.shared.getAuthenticatedUser()
            isLoggedIn = true
        } catch {
            isLoggedIn = false
            errorMessage = "You are not logged in. Please log in to continue."
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
