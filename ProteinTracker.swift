import Foundation

// Data model for a protein entry
struct ProteinEntry: Identifiable {
    let id = UUID()
    var amount: Float // Amount of protein consumed (now using Float)
    var date: Date
}

// ViewModel for tracking protein data
class ProteinTracker: ObservableObject {
    @Published var dailyGoal: Float = 100.0 // Default daily goal as Float
    @Published var totalProteinConsumed: Float = 0.0
    @Published var proteinEntries: [ProteinEntry] = []

    // Calculate remaining goal based on entries
    var remainingGoal: Float {
        max(0, dailyGoal - totalProteinConsumed)
    }

    // Method to add a new protein entry
    func addProtein(amount: Float) {
        let entry = ProteinEntry(amount: amount, date: Date())
        proteinEntries.append(entry)
        totalProteinConsumed += amount
    }

    // Method to remove a protein entry
    func removeEntry(at index: Int) {
        let entry = proteinEntries[index]
        totalProteinConsumed -= entry.amount
        proteinEntries.remove(at: index)
    }
}
