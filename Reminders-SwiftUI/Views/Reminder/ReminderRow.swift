

import SwiftUI

struct ReminderRow: View {
  @State var isCompleted: Bool = false
  let reminder: Reminder
  private var priority: String{
    ReminderPriority(rawValue: reminder.priority)?.shortDisplay ?? ""
  }
  
  var body: some View {
    HStack {
      Button(action: {
        self.isCompleted.toggle()
      }) {
        ReminderStatusView(isChecked: $isCompleted)
      }
      Text("\(priority) \(reminder.title)")
      Spacer()
    }
  }
}

struct ReminderRow_Previews: PreviewProvider {
  static var previews: some View {
    let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let newReminder = Reminder(context: context)
    newReminder.title = "Some task"
    return ReminderRow(reminder: newReminder)
      .environment(\.managedObjectContext, context)
      .previewLayout(.fixed(width: 300, height: 70))
  }
}
