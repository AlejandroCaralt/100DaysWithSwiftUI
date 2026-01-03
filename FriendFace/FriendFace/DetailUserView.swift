//
//  DetailUserView.swift
//  FriendFace
//
//  Created by Alejandro Caralt on 2/1/26.
//

import SwiftUI
import SwiftData

struct DetailUserView: View {
    var user: User

    var body: some View {
        List {
            Section(user.name) {
                Text(user.address)
                Text(user.company)
                Text(user.email)
                Text("\(user.age) años")
            }
            Section("Amigos") {
                ForEach(user.friends, id: \.self) { friend in
                    Text(friend.name)
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: User.self, configurations: config)
    let friends = [Friends(id: "1231232", name: "Paco"), Friends(id: "2", name: "Fernando"), Friends(id: "33", name: "Camilo")]
    let user = User(id: "2", isActive: true, name: "Almudena", age: 21, company: "Companion", email: "mail@example.com", address: "Carretera 1", about: "Me gusta el hockey y ir al cine.", registered: .now, tags: ["tags"], friends: friends)

    DetailUserView(user: user)
        .modelContainer(container)
}
