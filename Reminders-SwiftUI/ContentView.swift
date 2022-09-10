

import SwiftUI

struct ContentView: View {
  @State var isShowingListModal = false
  
  var body: some View {
    NavigationView {
      RemindersView()
      .navigationBarTitle(Text("Reminders"))
    }
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
