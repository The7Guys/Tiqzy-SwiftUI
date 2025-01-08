import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
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

            // Navigate on Successful Login
            if viewModel.isLoggedIn {
                Text("Login successful! Redirecting...")
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundColor(.green)
                    .padding(.top)
                // Simulate navigation
                Spacer()
                Button("Continue to Home") {
                    // Navigate to home or dismiss the login screen
                }
                .font(.custom("Poppins-Medium", size: 18))
                .foregroundColor(Constants.Design.secondaryColor)
            }
            
            Spacer()
            
            // Sign Up Text
            HStack {
                Text("Don’t have an account?")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)
                
                Button(action: {
                    // Navigate to Sign Up
                }) {
                    Text("Sign Up")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(Constants.Design.secondaryColor)
                }
            }
        }
        .padding()
    }
}
