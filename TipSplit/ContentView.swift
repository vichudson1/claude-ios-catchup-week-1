import SwiftUI
import Playgrounds

struct ContentView: View {
    
    // MARK: - State (the "order ticket")
    @State private var billText = ""
    @State private var tipPercent = 20
    @State private var people = 2
    
    @FocusState private var billFocused: Bool
    
    private let tipOptions = [10, 15, 18, 20, 25]

    
    // MARK: - Computation Variables
    private var currency: String {
        Locale.current.currency?.identifier ?? "USD"
    }
    
    private var bill: Double {
        (try? Double(billText, format: .number)) ?? 0
    }
    
    private var tip: Double {
        bill * Double(tipPercent) / 100
    }
    
    private var total: Double {
        bill + tip
    }
    
    private var perPerson: Double {
        total / Double(people)
    }
    
    // MARK: - UI
    var body: some View {
        NavigationStack {
            Form {
                
                Section {
                    VStack(spacing: 4) {
                        Text("Each person pays")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(perPerson, format: .currency(code: currency))
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .contentTransition(.numericText())
                            .animation(.snappy, value: perPerson)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                
                Section("Bill") {
                    TextField("Amount", text: $billText)
                        .keyboardType(.decimalPad)
                        .focused($billFocused)
                }
                
                Section("Tip") {
                    Picker("Tip", selection: $tipPercent) {
                        ForEach(tipOptions, id: \.self) { percent in
                            Text("\(percent)%")
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Split") {
                    Stepper(
                        "\(people) \(people == 1 ? "person" : "people")",
                        value: $people,
                        in: 1...20
                    )
                }
                
                Section("Details") {
                    LabeledContent("Tip", value: tip, format: .currency(code: currency))
                    LabeledContent("Total", value: total, format: .currency(code: currency))
                    
                }
                
            }
            .navigationTitle("Tip Split")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") { billFocused = false }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            
        }
        
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
