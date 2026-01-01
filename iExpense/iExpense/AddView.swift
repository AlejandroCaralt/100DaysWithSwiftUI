//
//  AddView.swift
//  iExpense
//
//  Created by Alejandro Caralt on 26/11/25.
//

import SwiftUI
import SwiftData

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var name = "Add Expense"
    @State private var type = "Personal"
    @State private var amount = 0.0

    let types = ["Business", "Personal"]

    var body: some View {
        NavigationStack {
            Form {
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: "EUR"))
                    .keyboardType(.decimalPad)
                    .foregroundStyle(amountColor(amount))
            }
            .navigationTitle($name)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button() {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                    }
                    
                }
                ToolbarItem {
                    Button("Save") {
                        let item = ExpenseItem(name: name, type: type, amount: amount)
                        modelContext.insert(item)
                        dismiss()
                    }
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
    AddView()
}
