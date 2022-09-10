/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import CoreData
import SwiftUI

extension Reminder{
  @NSManaged var title: String
  @NSManaged var isCompleted: Bool
  @NSManaged var notes: String?
  @NSManaged var dueDate: Date?
  @NSManaged var priority: Int16
  @NSManaged var list: ReminderList
  
  static func createWith(title: String, notes:String? ,date:Date?, priority: ReminderPriority,in list: ReminderList, using viewContext: NSManagedObjectContext){
    let reminder = Reminder(context: viewContext)
    reminder.title = title
    reminder.notes = notes
    reminder.dueDate = date
    reminder.priority = priority.rawValue
    reminder.list = list
    
    do{
      try viewContext.save()
    }catch{
      let nsError = error as NSError
      fatalError("Unresolved error \(error), \(nsError.userInfo)")
    }
  }
  
  //Generic defines the return type is of remnider
  static func basicFetchRequest() -> FetchRequest<Reminder> {
    FetchRequest(entity: Reminder.entity(), sortDescriptors: [])
  }
  
  //MARK: Sorting 
  
  //Returning a sorted fetch request
  static func sortedFetchRequest() -> FetchRequest<Reminder>{
    /// Define a sort descriptor you want to sort against, such as due date
    let dateSortDescriptor = NSSortDescriptor(key: "dueDate", ascending: false)
    return FetchRequest(entity: Reminder.entity(), sortDescriptors: [dateSortDescriptor])
  }
  
  //Sort by title and priority
  static func fetchRequestSortedByTitileAndPriority() -> FetchRequest<Reminder>{
    let titleSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
    let prioritySortDescriptor = NSSortDescriptor(key: "priority", ascending: true)
    
    //if title is first then it will be sorted by title then priotity if titles are the same
    return FetchRequest(entity: Reminder.entity(), sortDescriptors: [titleSortDescriptor, prioritySortDescriptor])
  }
  
  //MARK: Predicates
    
  static func completedRemindersFetchRequest() -> FetchRequest<Reminder> {
    let titleSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
    let prioritySortDescriptor = NSSortDescriptor(key: "priority", ascending: false)
    //Filter the reminders,
    /// %K and %@ are formate specifiers,
    // %K / apply a filter on the isCompleted as a key path
    // %@ / this is for object value like the NSNumber false
    let isCompletedPredicate = NSPredicate(format: "%K == %@", "isCompleted", NSNumber(value: false))
    
    return FetchRequest(entity: Reminder.entity(), sortDescriptors: [titleSortDescriptor, prioritySortDescriptor], predicate: isCompletedPredicate)
  }
}
