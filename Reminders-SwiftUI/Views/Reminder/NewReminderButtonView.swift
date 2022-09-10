

import SwiftUI

struct NewReminderButtonView: View {
  @Binding var isShowingCreateModal: Bool
  @Environment(\.managedObjectContext) var viewContext
  let reminderList: ReminderList
  
  var body: some View {
    Button(action: { self.isShowingCreateModal.toggle() }) {
      Image(systemName: "plus.circle.fill")
        .foregroundColor(.red)
      Text("New Reminder")
        .font(.headline)
        .foregroundColor(.red)
    }.sheet(isPresented: $isShowingCreateModal) {
      CreateReminderView(reminderList: self.reminderList)
        .environment(\.managedObjectContext, self.viewContext)
    }
  }
}

struct NewReminderButtonView_Previews: PreviewProvider {
  static var previews: some View {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let newReminderList = ReminderList(context: context)
    newReminderList.title = "Preview List"
    return NewReminderButtonView(isShowingCreateModal: .constant(false),reminderList: newReminderList)
    
  }
  
  
}
