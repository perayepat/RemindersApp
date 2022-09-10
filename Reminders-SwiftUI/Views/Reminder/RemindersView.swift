

import SwiftUI

struct RemindersView: View {
  @Environment(\.managedObjectContext) var viewContext
  @State var isShowingCreateModal: Bool = false
  @State var isShowingTagsModal: Bool  = false
  let fetchRequest:  FetchRequest<Reminder>
  var reminders: FetchedResults<Reminder>{
    //exposing the property wrapper
    fetchRequest.wrappedValue
  }
  let reminderList: ReminderList
  
  //get tags with computed property
  var tags: Array<Tag>{
    let tagsSet = reminderList.reminders.compactMap({$0.tags}).reduce(Set<Tag>(),{(result,tags) in
      var result = result
      result.formUnion(tags)
      return result
    })
    return Array(tagsSet)
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
        NewReminderButtonView(isShowingCreateModal: $isShowingCreateModal, reminderList: self.reminderList)
        Spacer()
      }
      .padding(.leading)
    }
    .navigationBarTitle(Text("Reminders"))
    .navigationBarItems(trailing:Button{
      self.isShowingTagsModal.toggle()
    }label:{
      Text("Tags")
    }.sheet(isPresented: self.$isShowingTagsModal, content: {
      TagsView(tags: self.tags).environment(\.managedObjectContext, self.viewContext)
    }))
  }
  init(reminderList: ReminderList){
    self.reminderList = reminderList
    self.fetchRequest = Reminder.reminders(in: reminderList)
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
