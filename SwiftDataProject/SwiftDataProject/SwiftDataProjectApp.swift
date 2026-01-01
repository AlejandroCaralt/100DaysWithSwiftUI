//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Alejandro Caralt on 30/12/25.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
