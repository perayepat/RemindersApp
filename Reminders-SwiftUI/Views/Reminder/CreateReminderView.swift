
import CoreData
import SwiftUI

enum ReminderPriority: Int16, CaseIterable {
  case none = 0
  case low = 1
  case medium = 2
  case high = 3
}

extension ReminderPriority {
  var shortDisplay: String {
    switch self {
    case .none: return ""
    case .low: return "!"
    case .medium: return "!!"
    case .high: return "!!!"
    }
  }
  
  var fullDisplay: String {
    switch self {
    case .none: return "None"
    case .low: return "Low"
    case .medium: return "Medium"
    case .high: return "High"
    }
  }
}

struct CreateReminderView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @Environment(\.managedObjectContext) var viewContext: NSManagedObjectContext
  let reminderList: ReminderList
  
  // MARK: - State -
  @State var text: String = ""
  @State var notes: String = ""
  @State var shouldRemind: Bool = false
  @State var dueDate = Date()
  @State var tags = ""
  @State var priority: ReminderPriority = .none
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Title", text: $text)
          TextField("Notes", text: $notes)
        }
        Section {
          HStack {
            Toggle(isOn: $shouldRemind) {
              Text("Remind me")
            }
            .onTapGesture {
              UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
          }
          if shouldRemind {
            DatePicker(selection: $dueDate, displayedComponents: .date) {
              Text("Date")
            }
          }
        }
        Section{
            TextField("Tags", text: $tags)
        }
        Section {
          NavigationLink(destination: ReminderPrioritySelectionView(priority: $priority)) {
            Text("Priority")
            Spacer()
            Text(priority.fullDisplay)
          }
        }
      }
      .background(Color(.systemGroupedBackground))
      .navigationBarTitle(Text("Create Event"), displayMode: .inline)
      .navigationBarItems(trailing:
                            Button(action: {
        //create a set of tags based on the users input, split and then map them
        let tags = Set(self.tags.split(separator: ",").map { Tag.fetchOrCreateWith(title: String($0), in: self.viewContext) })
        
        
        Reminder.createWith(title: self.text,
                            notes: self.notes,
                            date: self.dueDate,
                            priority: self.priority,
                            tags: tags,
                            in: self.reminderList,
                            using: self.viewContext)
        
        self.presentationMode.wrappedValue.dismiss()
      }) {
        Text("Save")
          .fontWeight(.bold)
      }
      )
    }
  }
}

struct CreateReminderView_Previews: PreviewProvider {
  static var previews: some View {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let newReminderList = ReminderList(context: context)
    newReminderList.title = "Preview List"
    return CreateReminderView(reminderList: newReminderList).environment(\.managedObjectContext, context)
  }
}
