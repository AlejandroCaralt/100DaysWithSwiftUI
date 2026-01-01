//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Alejandro Caralt on 24/11/25.
//

import SwiftUI
import SwiftData

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
