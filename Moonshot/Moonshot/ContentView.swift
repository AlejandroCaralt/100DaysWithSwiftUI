//
//  ContentView.swift
//  Moonshot
//
//  Created by Alejandro Caralt on 28/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var gridToggle = false

    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    let columnList = [
        GridItem(.flexible(minimum: 150, maximum: 400))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridToggle ? columns : columnList) {
                    ForEach(missions) { mission in
                        NavigationLink {
                            MissionView(mission: mission, astronauts: astronauts)
                        } label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding(10)
                                
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground)
                            }
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.lightBackground))
                        }
                    }
                }
                .padding([.horizontal, .bottom], 10)
                .animation(.easeInOut, value: gridToggle)
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem {
                    Button {
                        gridToggle.toggle()
                    } label: {
                        Text(gridToggle ? "List" : "Grid")
                            .foregroundStyle(.blue.opacity(0.7))
                            .font(.title2.bold())
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
