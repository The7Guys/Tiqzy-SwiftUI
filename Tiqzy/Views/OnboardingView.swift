import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Image(viewModel.slides[viewModel.currentPage].imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)

                Text(viewModel.slides[viewModel.currentPage].title)
                    .font(.custom("Poppins-SemiBold", size: 30))
                    .foregroundColor(Constants.Design.primaryColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text(viewModel.slides[viewModel.currentPage].description)
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

                Button(action: {
                    viewModel.nextPage()
                }) {
                    Text(viewModel.currentPage == viewModel.slides.count - 1 ? "Get Started" : "Next")
                        .font(.custom("Poppins-Medium", size: 22))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Constants.Design.secondaryColor)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                HStack {
                    ForEach(0..<viewModel.slides.count, id: \.self) { index in
                        Circle()
                            .fill(index == viewModel.currentPage ? Constants.Design.secondaryColor : Color.gray.opacity(0.5))
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.bottom, 16)
            }
            .animation(.easeInOut, value: viewModel.currentPage)
            .navigationDestination(isPresented: $viewModel.isOnboardingComplete) {
                ContentView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
