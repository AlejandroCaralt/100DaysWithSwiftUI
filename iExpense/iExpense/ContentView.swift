//
//  ContentView.swift
//  iExpense
//
//  Created by Alejandro Caralt on 24/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var personalExpenses: [ExpenseItem]
    @Query var bussinessExpenses: [ExpenseItem]
    @State private var showingPersonalExpenses: Bool = true
    @State private var showingBussinessExpenses: Bool = true
    
    init() {
        _personalExpenses = Query(filter: #Predicate<ExpenseItem> { expense in
            expense.type == "Personal"
        }, sort: [
            SortDescriptor<ExpenseItem>(\.name), SortDescriptor<ExpenseItem>(\.amount)
        ])
        _bussinessExpenses = Query(filter: #Predicate<ExpenseItem> { expense in
            expense.type == "Business"
        }, sort: [
            SortDescriptor<ExpenseItem>(\.name), SortDescriptor<ExpenseItem>(\.amount)
        ])
    }
    
    var body: some View {
        NavigationStack {
            List {
                if showingPersonalExpenses {
                    Section(header: Text("Personal")) {
                        ForEach(personalExpenses) { item in
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
                        .onDelete(perform: removePersonalExpense)
                    }
                }
                if showingBussinessExpenses {
                    Section(header: Text("Business")) {
                        ForEach(bussinessExpenses) { item in
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
                        .onDelete(perform: removeBussinessExpense)
                    }
                }
            }
            .navigationTitle("iExpenses")
            .toolbar {
                NavigationLink() {
                    AddView()
                } label: {
                    HStack {
                        Text("Add Expense")
                        Image(systemName: "plus")
                    }
                }
                
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Button("All") {
                        showingPersonalExpenses = true
                        showingBussinessExpenses = true
                    }
                    Button("Only Personal") {
                        showingPersonalExpenses = true
                        showingBussinessExpenses = false
                    }
                    Button("Only Bussiness") {
                        showingPersonalExpenses = false
                        showingBussinessExpenses = true
                    }
                }
            }
        }
    }
    
    
    func removePersonalExpense(at offsets: IndexSet) {
        for offset in offsets {
            let expense = personalExpenses[offset]
            modelContext.delete(expense)
        }
    }
    
    func removeBussinessExpense(at offsets: IndexSet) {
        for offset in offsets {
            let expense = bussinessExpenses[offset]
            modelContext.delete(expense)
        }
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
