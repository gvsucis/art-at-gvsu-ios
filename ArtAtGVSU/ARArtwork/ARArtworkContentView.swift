
import SwiftUI
import RealityKit

class Count: ObservableObject {
    @Published var num = 0
}

struct ARArtworkContentView : View {
    
    var count = Count()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                ARArtworkButtonsView(count: count)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
