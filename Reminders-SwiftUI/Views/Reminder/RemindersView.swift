

import SwiftUI

struct RemindersView: View {
  @State var isShowingCreateModal: Bool = false
  
  let fetchRequest = Reminder.completedRemindersFetchRequest()
  var reminders: FetchedResults<Reminder>{
    //exposing the property wrapper
    fetchRequest.wrappedValue
  }
  
  var body: some View {
    VStack {
      List {
        Section {
          ForEach(reminders, id: \.self) { reminder in
            ReminderRow(reminder: reminder)
          }
        }
      }
      .background(Color.white)
      HStack {
        NewReminderButtonView(isShowingCreateModal: $isShowingCreateModal)
        Spacer()
      }
      .padding(.leading)
    }
    .navigationBarTitle(Text("Reminders"))
  }
}

struct RemindersView_Previews: PreviewProvider {
  static var previews: some View {
    RemindersView()
  }
}
