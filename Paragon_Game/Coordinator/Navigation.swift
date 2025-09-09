import Foundation


enum AvailableScreens {
    case MENU
    case GAME
    case LEVELS
}

class NavGuard: ObservableObject {
    @Published var currentScreen: AvailableScreens = .MENU
    static var shared: NavGuard = .init()
}
