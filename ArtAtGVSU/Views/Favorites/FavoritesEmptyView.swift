import SwiftUI

struct FavoritesEmptyView: View {
    @EnvironmentObject private var tabs: TabController

    var body: some View {
        VStack {
            Text("favorites_empty_Explainer")
            Text("favorites_empty_Description")
            Button("favorites_empty_Action") {
                tabs.open(.home)
            }
            .padding()
        }.padding()
    }
}

#Preview {
    FavoritesEmptyView()
}
