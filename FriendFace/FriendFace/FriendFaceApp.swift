//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Alejandro Caralt on 2/1/26.
//

import SwiftUI
import SwiftData

@main
struct FriendFaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
