import SwiftUI

/// Splash screen displaying a logo with a fade-in effect.
struct SplashScreenView: View {
    @State private var opacity: Double = 0.0 // Controls the logo's fade-in effect.

    var body: some View {
        ZStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 340)
                .opacity(opacity)
                .onAppear {
                    // Animate the logo's opacity when the view appears.
                    withAnimation(.easeIn(duration: 1.0)) {
                        opacity = 1.0
                    }
                }
        }
    }
}
