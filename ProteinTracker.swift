import Foundation

// Data model for a protein entry
//struct ProteinEntry: Identifiable {
//    let id = UUID()
//    var amount: Float // Amount of protein consumed (now using Float)
//    var date: Date
//}
//
//class ProteinTracker: ObservableObject {
//    @Published var dailyGoal: Float = 100.0
//    @Published var totalProteinConsumed: Float = 0.0
//    @Published var proteinEntries: [ProteinEntry] = []
//
//    var remainingGoal: Float {
//        max(0, dailyGoal - totalProteinConsumed)
//    }
//
//    func addProtein(amount: Float) {
//        let entry = ProteinEntry(amount: amount, date: Date())
//        proteinEntries.append(entry)
//        totalProteinConsumed += amount
//    }
//
//    func removeEntry(at index: Int) {
//        let entry = proteinEntries[index]
//        totalProteinConsumed -= entry.amount
//        proteinEntries.remove(at: index)
//    }
//
//    // Filter entries for today
//    func entriesForToday() -> [ProteinEntry] {
//        let calendar = Calendar.current
//        return proteinEntries.filter {
//            calendar.isDateInToday($0.date)
//        }
//    }
//}
