//
//  AddView.swift
//  iExpense
//
//  Created by Alejandro Caralt on 26/11/25.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0

    let types = ["Business", "Personal"]
    var expense: Expenses

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: "EUR"))
                    .keyboardType(.decimalPad)
                    .foregroundStyle(amountColor(amount))
            }
            .navigationTitle("Add Expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expense.items.append(item)
                    dismiss()
                }
            }
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
    AddView(expense: Expenses())
}
