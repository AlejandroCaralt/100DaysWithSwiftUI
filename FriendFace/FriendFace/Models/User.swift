//
//  User.swift
//  FriendFace
//
//  Created by Alejandro Caralt on 2/1/26.
//

import Foundation
import SwiftData

@Model
class User: Codable {
    @Attribute(.unique) var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    @Relationship var friends: [Friends]
    
    init(id: String, isActive: Bool, name: String, age: Int, company: String, email: String, address: String, about: String, registered: Date, tags: [String], friends: [Friends]) {
        self.id = id
        self.isActive = isActive
        self.name = name
        self.age = age
        self.company = company
        self.email = email
        self.address = address
        self.about = about
        self.registered = registered
        self.tags = tags
        self.friends = friends
    }
    
    enum CodingKeys: String, CodingKey {
        case id, isActive, name, age, company, email, address, about, registered, tags, friends
    }
    
    required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        isActive = try values.decode(Bool.self, forKey: .isActive)
        name = try values.decode(String.self, forKey: .name)
        age = try values.decode(Int.self, forKey: .age)
        company = try values.decode(String.self, forKey: .company)
        email = try values.decode(String.self, forKey: .email)
        address = try values.decode(String.self, forKey: .address)
        about = try values.decode(String.self, forKey: .about)
        let registeredDate = try values.decode(String.self, forKey: .registered)
        registered = try Date(registeredDate, strategy: .iso8601)
        tags = try values.decode([String].self, forKey: .tags)
        friends = try values.decode([Friends].self, forKey: .friends)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(company, forKey: .company)
        try container.encode(email, forKey: .email)
        try container.encode(address, forKey: .address)
        try container.encode(about, forKey: .about)
        try container.encode(registered, forKey: .registered)
        try container.encode(tags, forKey: .tags)
        try container.encode(friends, forKey: .friends)
    }
}
