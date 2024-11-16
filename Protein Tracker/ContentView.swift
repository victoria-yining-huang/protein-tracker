import SwiftUI

// Define the ProteinTracker class as a simple example for the state object.
//class ProteinTracker: ObservableObject {
//    @Published var dailyGoal: Float = 150.0
//    @Published var remainingGoal: Float = 150.0
//    @Published var entries: [Float] = []
//    
//    func addProtein(amount: Float) {
//        entries.append(amount)
//        remainingGoal -= amount
//    }
//}

struct ContentView: View {
    @StateObject private var proteinTracker = ProteinTracker()
    @State private var newEntryAmount: Float = 0.0

    var body: some View {
        NavigationView {
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
                    // Make sure TextField is correctly set up with $newEntryAmount binding
                    TextField("Enter protein (g)", value: $newEntryAmount, format: .number)
                        .keyboardType(.decimalPad)  // Allows decimal number input
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
    }

    private func addNewEntry() {
        // No need to convert to Int anymore; we can directly use Float
        if newEntryAmount > 0 {
            proteinTracker.addProtein(amount: newEntryAmount)
            newEntryAmount = 0.0 // Clear input field
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
