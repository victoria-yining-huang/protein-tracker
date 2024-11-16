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

    var body: some View {
        List(proteinTracker.entriesForToday()) { entry in
            HStack {
                Text("\(entry.amount, specifier: "%.2f")g")
                Spacer()
                Text(entry.date, style: .time)
                    .foregroundColor(.gray)
            }
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
