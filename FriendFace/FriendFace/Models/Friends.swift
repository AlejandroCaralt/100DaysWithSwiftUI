//
//  Friends.swift
//  FriendFace
//
//  Created by Alejandro Caralt on 2/1/26.
//

import Foundation
import SwiftData

@Model
class Friends: Codable {
    @Attribute(.unique) var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }

    func encode(to encoder: any Encoder) throws {
        var codingContainer = encoder.container(keyedBy: CodingKeys.self)
        try codingContainer.encode(id, forKey: .id)
        try codingContainer.encode(name, forKey: .name)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
