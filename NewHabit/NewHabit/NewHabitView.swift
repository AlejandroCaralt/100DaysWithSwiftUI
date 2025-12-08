//
//  NewHabitView.swift
//  NewHabit
//
//  Created by Alejandro Caralt on 7/12/25.
//

import SwiftUI

struct NewHabitView: View {
    @Environment(\.dismiss) var dismiss

    @State var name: String = ""
    @State var description: String = ""
    
    var viewModel: HabitsViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("What's the new habit?", text: $name)
            }
            .autocorrectionDisabled()
            Section(header: Text("Description")) {
                TextField("Describe it in a few lines...", text: $description, axis: .vertical)
                    .lineLimit(6, reservesSpace: true)
            }
            .autocorrectionDisabled()
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancelar")
                        .foregroundStyle(.red)
                        .font(.headline.bold())
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.newHabits.append(Habit(name: name, description: description, startDate: Date.now, counter: 0))
                    dismiss()
                } label: {
                    Image(systemName: "checkmark.circle")
                        .font(.headline.bold())
                        .foregroundStyle(.green.opacity(0.8))
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    let viewModel = HabitsViewModel()
    viewModel.newHabits = [Habit(name: "Test", description: "Test", startDate: Date.now, counter: 0)]

    return NavigationStack {
        NewHabitView(viewModel: viewModel)
    }
}
