//
//  UserRepository.swift
//  FriendFace
//
//  Created by Alejandro Caralt on 2/1/26.
//

import Foundation

class UserRepository {
    static let shared = UserRepository()

    private init() {}
    func getUsers() async throws -> [User] {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            fatalError("Invalid URL")
        }
        print("Downloading")
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                return users
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
}
