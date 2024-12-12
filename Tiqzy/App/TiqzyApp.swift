import SwiftUI

@main
struct TiqzyApp: App {
    @State private var showSplashScreen = true // Single state variable
    @State private var preloadContentView = false // Preload ContentView in the background

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Main Content View (preloaded in the background)
                ContentView()
                    .opacity(preloadContentView && !showSplashScreen ? 1 : 0) // Fully visible after splash
                    .onAppear {
                        // Preload ContentView in the background
                        preloadContentView = true
                    }

                // Splash Screen View
                if showSplashScreen {
                    SplashScreenView()
                        .transition(.scale(scale: 1.2).combined(with: .opacity)) // Zoom-out and fade
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    showSplashScreen = false // Hide splash screen
                                }
                            }
                        }
                }
            }
            .animation(.easeInOut(duration: 1.0), value: showSplashScreen) // Smooth animation
        }
    }
}
