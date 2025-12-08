//
//  HabitDetailView.swift
//  NewHabit
//
//  Created by Alejandro Caralt on 7/12/25.
//

import SwiftUI

struct HabitDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var habit: Habit
    @State var deletepopupIsPresented: Bool = false
    
    var viewModel: HabitsViewModel
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Description:")
                    .font(.title2)
                
                Text(habit.description)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(.rect(cornerRadius: 10))
            }
            .padding([.trailing], 250)
            
            VStack(alignment: .leading) {
                Text("\(habit.formattedStartDate)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Spacer()
            
            Button("Completed: \(habit.counter)") {
                habit.counter += 1
                dismiss()
            }
            .foregroundStyle(.white)
            .frame(width: 200, height: 50)
            .background(Color.blue.opacity(0.7))
            .clipShape(Capsule())
            
            Spacer()
        }
        .padding()
        .navigationTitle($habit.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                deletepopupIsPresented = true
            } label: {
                Text("Delete")
                    .padding(5)
            }
            .foregroundStyle(.white)
            .background(Color.red.opacity(0.7))
            .clipShape(.capsule)
            
        }
        .alert("Hola", isPresented: $deletepopupIsPresented) {
            Button("Cancel") {
                deletepopupIsPresented = false
            }
            Button("Delete") {
                if let index = viewModel.newHabits.firstIndex(of: habit) {
                    viewModel.newHabits.remove(at: index)
                }
                dismiss()
            }
        } message: {
            Text("Mensaje")
        }
    }
}

#Preview {
    @Previewable @State var newHabit = Habit(id: .init(), name: "Test", description: "Test", startDate: Date(), counter: 0)
    
    NavigationStack {
        HabitDetailView(habit: $newHabit, viewModel: .init())
    }
}
