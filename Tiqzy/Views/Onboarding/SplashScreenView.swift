import SwiftUI

struct SplashScreenView: View {
    @State private var opacity: Double = 0.0
    var body: some View {
        ZStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 340)
                .opacity(opacity) // Control opacity for fade effect
                .onAppear {
                    withAnimation(.easeIn(duration: 1.0)) {
                        opacity = 1.0 // Fade in
                    }
                }
        }
    }
}

#Preview {
    SplashScreenView()
}
