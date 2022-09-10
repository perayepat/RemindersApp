

import SwiftUI

struct RemindersView: View {
  @State var isShowingCreateModal: Bool = false
  let fetchRequest = Reminder.completedRemindersFetchRequest()
  var reminders: FetchedResults<Reminder>{
    //exposing the property wrapper
    fetchRequest.wrappedValue
  }
  let reminderList: ReminderList
  
  
  var body: some View {
    VStack {
      List {
        Section {
          ForEach(reminderList.reminders, id: \.self) { reminder in
            ReminderRow(reminder: reminder)
          }
        }
      }
      .background(Color.white)
      HStack {
        NewReminderButtonView(isShowingCreateModal: $isShowingCreateModal, reminderList: self.reminderList)
        Spacer()
      }
      .padding(.leading)
    }
    .navigationBarTitle(Text("Reminders"))
  }
}

struct RemindersView_Previews: PreviewProvider {
  static var previews: some View {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let newReminderList = ReminderList(context: context)
    newReminderList.title = "Preview List"
    return RemindersView(reminderList: newReminderList).environment(\.managedObjectContext, context)
  }
}
