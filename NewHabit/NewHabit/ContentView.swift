//
//  ContentView.swift
//  NewHabit
//
//  Created by Alejandro Caralt on 7/12/25.
//

import SwiftUI
import Observation

struct ContentView: View {
    
    @State var viewModel: HabitsViewModel = HabitsViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.newHabits) { habit in
                NavigationLink(value: habit) {
                    HStack {
                        Text(habit.name)
                        Spacer()
                        Text("^[\(habit.counter) day](inflect: true)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        NewHabitView(viewModel: viewModel)
                    } label: {
                        Group {
                            Text("Add")
                            Image(systemName: "plus")
                        }
                        .foregroundStyle(.blue.opacity(0.8))
                        .font(.headline.bold())
                    }
                }
            }
            .navigationDestination(for: Habit.self, destination: { habit in
                if let index = viewModel.newHabits.firstIndex(of: habit) {
                    HabitDetailView(habit: $viewModel.newHabits[index], viewModel: viewModel)
                }
            })
        }
    }
}

#Preview {
    ContentView()
}
