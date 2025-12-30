//
//  Order.swift
//  CupcakeCorner
//
//  Created by Alejandro Caralt on 10/12/25.
//

import Foundation
import Observation

@Observable
public class Order: Codable {
    
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnable = "specialRequestEnable"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "street_address"
        case _city = "city"
        case _zip = "zip"
    }
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0
    var quantity = 3
    
    var specialRequestEnable = false {
        didSet {
            if !specialRequestEnable {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false

    var name = "" {
        didSet {
            UserDefaults.standard.set(name, forKey: "name")
        }
    }
    var streetAddress = "" {
        didSet {
            UserDefaults.standard.set(streetAddress, forKey: "streetAddress")
        }
    }
    var city = "" {
        didSet {
            UserDefaults.standard.set(city, forKey: "city")
        }
    }
    var zip = "" {
        didSet {
            UserDefaults.standard.set(zip, forKey: "zip")
        }
    }

    var hasValidAddress: Bool {
        let validName = !name.replacingOccurrences(of: " ", with: "").isEmpty
        let validAddress = !streetAddress.replacingOccurrences(of: " ", with: "").isEmpty
        let validCity = !city.replacingOccurrences(of: " ", with: "").isEmpty
        let validZip = !zip.replacingOccurrences(of: " ", with: "").isEmpty
        
        return !(validName && validAddress && validCity && validZip)
    }
    
    var cost: Decimal {
        var cost = Decimal(quantity) * 2
        cost += Decimal(type) / 2

        if extraFrosting {
            cost += Decimal(quantity)
        }

        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
        
    }

    init() {
        name = UserDefaults.standard.value(forKey: "name") as? String ?? ""
        streetAddress = UserDefaults.standard.value(forKey: "streetAddress") as? String ?? ""
        city = UserDefaults.standard.value(forKey: "city") as? String ?? ""
        zip = UserDefaults.standard.value(forKey: "zip") as? String ?? ""
    }
}
