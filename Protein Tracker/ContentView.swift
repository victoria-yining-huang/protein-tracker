import SwiftUI

//// Protein Entry model
struct ProteinEntry: Identifiable {
    let id = UUID()
    var amount: Float // Amount of protein consumed
    var date: Date
}

// Protein Tracker ViewModel
class ProteinTracker: ObservableObject {
    @Published var dailyGoal: Float = 100.0
    @Published var totalProteinConsumed: Float = 0.0
    @Published var proteinEntries: [ProteinEntry] = []

    var remainingGoal: Float {
        max(0, dailyGoal - totalProteinConsumed)
    }

    func addProtein(amount: Float) {
        let entry = ProteinEntry(amount: amount, date: Date())
        proteinEntries.append(entry)
        totalProteinConsumed += amount
    }

    func removeEntry(at index: Int) {
        let entry = proteinEntries[index]
        totalProteinConsumed -= entry.amount
        proteinEntries.remove(at: index)
    }

    // Filter entries for today
    func entriesForToday() -> [ProteinEntry] {
        let calendar = Calendar.current
        return proteinEntries.filter {
            calendar.isDateInToday($0.date)
        }
    }
    
    func updateEntry(_ entry: ProteinEntry, with newAmount: Float) {
           // Find the index of the entry to be updated
           if let index = proteinEntries.firstIndex(where: { $0.id == entry.id }) {
               let oldAmount = proteinEntries[index].amount
               proteinEntries[index].amount = newAmount // Update the amount of the entry
               totalProteinConsumed += newAmount - oldAmount // Adjust the total protein consumed
           }
       }
}

// Dashboard View
struct DashboardView: View {
    @StateObject var proteinTracker: ProteinTracker
    @State private var newEntryAmount: Float = 0.0

    var body: some View {
        VStack {
            // Daily Goal Display
            VStack {
                Text("Daily Goal: \(proteinTracker.dailyGoal, specifier: "%.2f")g")
                    .font(.title)
                Text("Remaining: \(proteinTracker.remainingGoal, specifier: "%.2f")g")
                    .font(.headline)
                    .foregroundColor(proteinTracker.remainingGoal > 0 ? .green : .red)
            }
            .padding()

            // Input field to add new protein entry
            HStack {
                TextField("Enter protein (g)", value: $newEntryAmount, format: .number)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()

                Button(action: addNewEntry) {
                    Text("Add")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }

    private func addNewEntry() {
        if newEntryAmount > 0 {
            proteinTracker.addProtein(amount: newEntryAmount)
            newEntryAmount = 0.0 // Clear input field
        }
    }
}

// Today's Entries View
struct TodaysEntriesView: View {
    @StateObject var proteinTracker: ProteinTracker
    @State private var updatedEntryAmount: Float = 0.0
    @State private var isEditing = false
    @State private var entryToEdit: ProteinEntry?

    var body: some View {
        List {
            // Display today's protein entries
            ForEach(proteinTracker.entriesForToday()) { entry in
                HStack {
                    Text("\(entry.amount, specifier: "%.2f")g")
                    Spacer()
                    Text(entry.date, style: .time)
                        .foregroundColor(.gray)

                    Button(action: {
                        entryToEdit = entry
                        updatedEntryAmount = entry.amount // Set initial value in the field
                        isEditing = true // Show edit form
                    }) {
                        Text("Edit")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
            }
            .onDelete(perform: deleteEntry) // Add swipe-to-delete functionality
        }
        .listStyle(PlainListStyle()) // Optional: Use plain list style for a cleaner look
    }

    private func deleteEntry(at offsets: IndexSet) {
          // Remove entries from proteinTracker's list
          offsets.forEach { index in
              proteinTracker.removeEntry(at: index)
          }
      }

    private func saveEdit() {
        // Ensure that 'entryToEdit' is not nil and 'updatedEntryAmount' is valid
        if let entry = entryToEdit, updatedEntryAmount > 0 {
            proteinTracker.updateEntry(entry, with: updatedEntryAmount)
            isEditing = false // Close the editing sheet by setting isEditing to false
            entryToEdit = nil // Reset the entry being edited
        }
    }
}


// Main Content View with TabView
struct ContentView: View {
    @StateObject private var proteinTracker = ProteinTracker()

    var body: some View {
        TabView {
            // Dashboard Tab
            DashboardView(proteinTracker: proteinTracker)
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }

            // Today's Entries Tab
            TodaysEntriesView(proteinTracker: proteinTracker)
                .tabItem {
                    Label("Today's Entries", systemImage: "list.bullet")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
