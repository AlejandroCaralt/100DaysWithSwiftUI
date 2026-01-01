////
////  ExpenseView.swift
////  iExpense
////
////  Created by Alejandro Caralt on 1/1/26.
////
//
//import SwiftUI
//import SwiftData
//
//struct ExpenseView: View {
//    @Environment(\.modelContext) var modelContext
//    @Query var expenses: [ExpenseItem]
//    
//
//    var body: some View {
//        Section(header: Text("Personal")) {
//            ForEach(expenses) { item in
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text(item.name)
//                            .font(.headline)
//                        Text(item.type)
//                    }
//                    
//                    Spacer()
//                    
//                    Text(item.amount, format: .currency(code: Locale.current.currencySymbol ?? "EURO"))
//                        .foregroundStyle(amountColor(item.amount))
//                }
//            }
//            .onDelete(perform: removeItems)
//        }
//    }
//
//    init(sortOrder: [SortDescriptor<ExpenseItem>]) {
//        _expenses = Query(\.expenses, sortOrder: sortOrder)
//    }
//    
//    func removeItems(at offsets: IndexSet) {
//        for offset in offsets {
//            let expense = expenses[offset]
//            modelContext.delete(expense)
//        }
//    }
//    
//    func amountColor(_ amount: Double) -> Color {
//        if amount > 100 {
//            return .green
//        } else if amount >= 10 {
//            return .yellow
//        } else {
//            return .blue
//        }
//    }
//}
//
//#Preview {
//    ExpenseView()
//}
