import SwiftUI
import SwiftData
import Firebase

@main
struct TiqzyApp: App {
    @State private var showSplashScreen = true
    @State private var preloadContentView = false
    @State private var showOnboarding = false

    init() {
        // Determine if onboarding needs to be shown
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        _showOnboarding = State(initialValue: !hasSeenOnboarding)
        
        FirebaseApp.configure()
        print("Firebase App Initialized")
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Main Content View (preloaded in the background)
                ContentView()
                    .opacity(preloadContentView && !showSplashScreen && !showOnboarding ? 1 : 0)
                    .onAppear {
                        preloadContentView = true // Preload ContentView in the background
                    }

                // Onboarding View
                if showOnboarding && !showSplashScreen {
                    OnboardingView()
                        .transition(.move(edge: .trailing)) // Smooth transition for onboarding
                        .onDisappear {
                            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        }
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
        .modelContainer(for: [Ticket.self])
    }
    
}
