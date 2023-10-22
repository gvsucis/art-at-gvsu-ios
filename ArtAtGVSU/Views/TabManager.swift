import Foundation

enum Tab {
    case home
    case tours
    case search
    case favorites
}

class TabController: ObservableObject {
    @Published var activeTab = Tab.home

    func open(_ tab: Tab) {
        activeTab = tab
    }
}
