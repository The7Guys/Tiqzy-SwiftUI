import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @Environment(\.dismiss) private var dismiss // Used to dismiss the login screen
    @State private var navigateToProfile = false // Tracks navigation to ProfileView

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Title
                VStack(spacing: 8) {
                    Text("Log in")
                        .font(.custom("Poppins-SemiBold", size: 30))
                        .foregroundColor(Constants.Design.primaryColor)

                    Text("Log in and start exploring Holland")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.gray)
                }

                Spacer().frame(height: 20)

                // Email Field
                VStack(alignment: .leading, spacing: 12) {
                    Text("Email")
                        .font(.custom("Poppins-Regular", size: 20))
                        .foregroundColor(Constants.Design.secondaryColor)

                    TextField("e.g christianBale@gmail.com", text: $viewModel.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal)

                // Password Field
                VStack(alignment: .leading, spacing: 12) {
                    Text("Password")
                        .font(.custom("Poppins-Regular", size: 20))
                        .foregroundColor(Constants.Design.secondaryColor)

                    SecureField("••••••••", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)

                // Log In Button
                Button(action: {
                    viewModel.logIn()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Design.secondaryColor)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                    } else {
                        Text("Log In")
                            .font(.custom("Poppins-Medium", size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Design.secondaryColor)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
                .disabled(viewModel.isLoading)

                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()

                // Sign Up Text
                HStack {
                    Text("Don’t have an account?")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.gray)

                    NavigationLink(destination: RegisterView()) {
                        Text("Sign Up")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(Constants.Design.secondaryColor)
                    }
                }

                // Navigation to ProfileView
                NavigationLink(
                    destination: ProfileView(),
                    isActive: $viewModel.isLoggedIn
                ) {
                    EmptyView() // Invisible navigation link
                }
            }
            .padding()
        }
    }
}
