//
//  Location.swift
//  BucketList
//
//  Created by Alejandro Caralt on 11/1/26.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    #if DEBUG
    static let example = Location(id: UUID(), name: "Santiago Bernabeu", description: "Estadio de futbol", latitude: -34.603723, longitude: -58.381594)
    #endif
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
