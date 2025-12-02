//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Alejandro Caralt on 28/11/25.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failled to load \(file)")
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Key '\(key)' not found: \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            fatalError(file + ": Expected to decode \(type), but found \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError(file + ": Expected to decode \(type), but found nil: \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            fatalError(file + ": Data corrupted: \(context.debugDescription)")
        } catch {
            fatalError(file + ": \(error.localizedDescription)")
        }
    }
}
