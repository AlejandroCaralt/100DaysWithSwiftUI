//
//  ContentView.swift
//  iExpense
//
//  Created by Alejandro Caralt on 24/11/25.
//

import SwiftUI
import Observation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let saveItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: saveItems) {
                items = decodedItems
                return
            }
        }

        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Personal")) {
                    ForEach(expenses.items.filter({ expense in
                        expense.type == "Personal"
                    })) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currencySymbol ?? "EURO"))
                                .foregroundStyle(amountColor(item.amount))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                Section(header: Text("Business")) {
                    ForEach(expenses.items.filter({ expense in
                        expense.type == "Business"
                    })) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currencySymbol ?? "EURO"))
                                .foregroundStyle(amountColor(item.amount))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
            }
            .navigationTitle("iExpenses")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expense: expenses)
            }
        }
    }
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }

    func amountColor(_ amount: Double) -> Color {
        if amount > 100 {
            return .green
        } else if amount >= 10 {
            return .yellow
        } else {
            return .blue
        }
    }
}


#Preview {
    ContentView()
}
