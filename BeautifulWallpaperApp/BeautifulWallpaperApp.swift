import SwiftUI

@main
struct BeautifulWallpaperApp: App {
    init() {
        // 强制使用暗色模式
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}