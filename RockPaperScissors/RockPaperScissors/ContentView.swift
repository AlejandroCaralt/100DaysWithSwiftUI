//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Alejandro Caralt on 16/11/25.
//

import SwiftUI

enum GameOptions: CaseIterable {
    case paper, rock, scissors
    
    var localizedDescription: String {
        switch self {
        case .paper:
            return "Paper"
        case .rock:
            return "Rock"
        case .scissors:
            return "Scissors"
        }
    }
    var icon: String {
        switch self {
        case .paper:
            return "📜"
        case .rock:
            return "🪨"
        case .scissors:
            return "✂️"
        }
    }
}

struct ContentView: View {
    @State var didWin: Bool = false
    @State var didLose: Bool = false
    @State var gameFinished: Bool = false
    @State var haveToWinOrLose: Bool = Bool.random()
    @State var computerOption: GameOptions = GameOptions.allCases.randomElement()!
    @State var selectedOption: GameOptions = .paper
    @State var paperSelected: Bool = false
    @State var rockSelected: Bool = false
    @State var scissorsSelected: Bool = false

    @State var score: Int = 0
    @State var maxRounds: Int = 10
    @State var currentRound: Int = 1
    let appTheme = AppTheme.shared

    var body: some View {
        ZStack {
            BackgroundImage(randomTopColor: appTheme.randomDark, randomBottomColor: appTheme.randomLight)
            VStack {
                VStack {
                    VStack {
                        Text("Round \(currentRound)/\(maxRounds)")
                            .font(.title)
                            .foregroundColor(.white)
                        HStack {
                            Text("You should ")
                                + Text(haveToWinOrLose ? "win" : "lose")
                                .font(.title2.bold())
                                .foregroundStyle(appTheme.randomLight)
                                + Text(" against:")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                    }
                    .padding()
                    Text("\(computerOption.icon) \(computerOption.localizedDescription)")
                        .font(.title.bold())
                        .foregroundStyle(appTheme.randomLight)
                }
                Spacer()
                HStack {
                    Button {
                        selectedOption = .paper
                        winOrLose()
                    } label: {
                        HStack {
                            Text(GameOptions.paper.icon)
                            Text(GameOptions.paper.localizedDescription)
                        }
                    }
                    .padding()
                    .background {
                        Capsule().fill(appTheme.randomDark.opacity(0.7))
                            .shadow(radius: 5)
                    }
                    .foregroundStyle(.white)
                    .buttonBorderShape(.capsule)
                    
                    
                    Button {
                        selectedOption = .rock
                        winOrLose()
                    } label: {
                        HStack {
                            Text(GameOptions.rock.icon)
                            Text(GameOptions.rock.localizedDescription)
                        }
                    }
                    .padding()
                    .background {
                        Capsule().fill(appTheme.randomDark.opacity(0.7))
                            .shadow(radius: 5)
                    }
                    .foregroundStyle(.white)
                    .buttonBorderShape(.capsule)
                    
                    
                    Button {
                        selectedOption = .scissors
                        winOrLose()
                    } label: {
                        HStack {
                            Text(GameOptions.scissors.icon)
                            Text(GameOptions.scissors.localizedDescription)
                        }
                    }
                    .padding()
                    .background {
                        Capsule().fill(appTheme.randomDark.opacity(0.7))
                            .shadow(radius: 5)
                    }
                    .foregroundStyle(.white)
                    .buttonBorderShape(.capsule)
                }
                Spacer()
            }
            .alert("Great one!", isPresented: $didWin) {
                Button("Next round", action: {
                    nextRound()
                })
            } message: {
                Text("You just scored a point, keep going!")
            }

            .alert("Not so lucky...", isPresented: $didLose) {
                Button("Next round", action: {
                    nextRound()
                })
            } message: {
                Text("You just losed a point, wish you luck next time...")
            }

            .alert("Game finished!", isPresented: $gameFinished) {
                Button("Restart game", action: {
                    restartGame()
                })
            } message: {
                Text("Your score: \(score)/\(maxRounds)")
            }
            
        }
    }

    func winOrLose() {
        switch (selectedOption, computerOption) {
        case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
            haveToWinOrLose ? winning() : losing()
        case (.rock, .paper), (.paper, .scissors), (.scissors, .rock):
            haveToWinOrLose ? losing() : winning()
        case (.rock, .rock), (.paper, .paper), (.scissors, .scissors):
            drawing()
        }
    }
    
    func restartGame() {
        score = 0
        currentRound = 1
        gameFinished = false
    }

    func nextRound() {
        guard currentRound < maxRounds else {
            gameFinished = true
            return
        }
        currentRound += 1
        didLose = false
        didWin = false
        haveToWinOrLose = Bool.random()
        computerOption = GameOptions.allCases.randomElement()!
    }

    func winning() {
        score += 1
        didWin = true
    }

    func losing() {
        score -= 1
        didLose = true
    }

    func drawing() {
        haveToWinOrLose = Bool.random()
        computerOption = GameOptions.allCases.randomElement()!
    }
}

final class AppTheme {
    static let shared = AppTheme()
    
    let randomLight = Color(red: Double.random(in: 0.6...1), green: Double.random(in: 0.6...1), blue: Double.random(in: 0.6...1))
    let randomDark = Color(red: Double.random(in: 0...0.4), green: Double.random(in: 0...0.4), blue: Double.random(in: 0...0.4))

    private init() {}
}

struct BackgroundImage: View {
    var randomTopColor: Color
    var randomBottomColor: Color
    @ViewBuilder var body: some View {
        LinearGradient(gradient: .init(colors: [randomTopColor, randomBottomColor]), startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
