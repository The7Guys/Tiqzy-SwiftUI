import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var showContentView = false // Controls transition to ContentView

    var body: some View {
        ZStack {
            // Onboarding Slides
            if !showContentView {
                VStack(spacing: 20) {
                    TabView(selection: $viewModel.currentPage) {
                        ForEach(0..<viewModel.slides.count, id: \.self) { index in
                            VStack {
                                Spacer()

                                Image(viewModel.slides[index].imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 300)

                                Text(viewModel.slides[index].title)
                                    .font(.custom("Poppins-SemiBold", size: 30))
                                    .foregroundColor(Constants.Design.primaryColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)

                                Text(viewModel.slides[index].description)
                                    .font(.custom("Poppins-Regular", size: 16))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)

                                Spacer()
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut, value: viewModel.currentPage)

                    Button(action: {
                        viewModel.nextPage()
                        if viewModel.isOnboardingComplete {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                completeOnboarding()
                            }
                        }
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
                .transition(.opacity) // Smooth fade transition
            }

            // ContentView with fade-in effect
            if showContentView {
                ContentView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
                showContentView = true
            }
        }
    }

    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        showContentView = true
    }
}
