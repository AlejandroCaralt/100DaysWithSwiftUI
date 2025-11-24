//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Alejandro Caralt on 9/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var gameState = 0
    let gameShuffles = 8
    @State private var gameReset = false
    @State private var spinAmount = [0.0, 0.0, 0.0]
    @State private var indexButtonTapped: Int? = nil

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()

                Text("Quess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in

                        let scaleAmount: CGFloat = (indexButtonTapped == nil || indexButtonTapped! == number) ? 1.0 : 0.2

                        Button {
                            withAnimation(.spring) {
                                spinAmount[number] += 360
                            }
                            flagTapped(number)
                            indexButtonTapped = number
                        } label: {
                            FlagImage(imageName: countries[number])
                                .rotation3DEffect(Angle(degrees: spinAmount[number]), axis: (x: 0, y: 1, z: 0))
                                .scaleEffect(scaleAmount)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                .animation(.easeIn, value: indexButtonTapped)

                Spacer()
                Spacer()

                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Text("Rounds: \(gameState)/\(gameShuffles)")
                    .foregroundStyle(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("You score is \(score)")
        }
        
        .alert("Game finished", isPresented: $gameReset) {
            Button("Reset") {
                score = 0
                gameState = 0
                gameReset = false
            }
        } message: {
            Text("Final result: \(score)/\(gameShuffles)")
        }
    }
    
    func flagTapped(_ number: Int) {
        gameReset = gameState >= gameShuffles

        guard !gameReset else { return }

        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong! The correct answer is \(countries[correctAnswer])"
        }
        showScore = true
        gameState += 1
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        indexButtonTapped = nil
    }

}

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct BlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
    }
}
extension View {
    public func blueTitle() -> some View {
        modifier(BlueTitle())
    }
}

#Preview {
    ContentView()
}
