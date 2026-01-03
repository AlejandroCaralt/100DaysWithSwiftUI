//
//  ContentView.swift
//  FriendFace
//
//  Created by Alejandro Caralt on 2/1/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \User.name) var users: [User]

    var body: some View {
        NavigationStack {
            List {
                ForEach(users, id: \.self) { user in
                    NavigationLink(value: user) {
                        HStack {
                            Text(user.name)
                            Spacer()
                            Text("\(user.age) old")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationDestination(for: User.self) { user in
                DetailUserView(user: user)
            }
            .navigationTitle("Class mates")
        }
        .onAppear() {
            Task {
                await getUsers()
            }
        }
    }

    func getUsers() async {
        guard users.isEmpty else { return }
        
        do {
            let users = try await UserRepository.shared.getUsers()
            for user in users {
                modelContext.insert(user)
            }
        } catch {
            print("Fetch failed: \(error)")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: User.self, configurations: config)
    
    return ContentView()
        .modelContainer(container)
}
