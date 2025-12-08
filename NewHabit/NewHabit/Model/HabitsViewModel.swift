//
//  HabitsViewModel.swift
//  NewHabit
//
//  Created by Alejandro Caralt on 7/12/25.
//

import Foundation
import Observation

@Observable
class HabitsViewModel: Codable {
    var newHabits: [Habit] {
        didSet {
            save()
        }
    }
    
    private let savePath = URL.documentsDirectory.appending(path: "habits.json")
    
    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
                newHabits = decoded
                return
            }
        }
        
        newHabits = []
    }

    func save() {
        guard let data = try? JSONEncoder().encode(newHabits) else {
            return
        }
        
        do {
            try data.write(to: savePath)
        } catch {
            print("Failer to save habits")
        }
    }
}

struct Habit: Codable, Hashable, Identifiable {
    private(set) var id: UUID = UUID()
    var name: String
    var description: String
    var startDate: Date
    var counter: Int

    var formattedStartDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: startDate)
    }
}
