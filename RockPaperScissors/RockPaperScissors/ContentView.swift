//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Patompong Manprasatkul on 24/04/2022.
//

import SwiftUI

struct ContentView: View {
    private static let options = ["🪨", "📄", "✂️"]
    private static let winningCase = [2, 0, 1]
    private let maximumTurn = 10

    @State var botMove = Int.random(in: 0..<ContentView.options.count)
    @State var showResult = false
    @State var isWinning = false
    @State var turnCount = 1
    @State var score = 0
    @State var gameOverTitle = ""
    @State var showGameOver = false

    let gradient = Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple])


    var body: some View {
        ZStack {
            AngularGradient(gradient: gradient, center: .center, angle: .degrees(0)).ignoresSafeArea()
            VStack {
                Spacer()
                Text("Choose wisely")
                    .foregroundColor(.secondary)
                    .font(.title.weight(.light))
                Spacer()
                VStack(spacing: 16) {
                    ForEach(0..<ContentView.options.count, id: \.self) { index in
                        Button {
                            buttonDidTap(index)
                        } label: {
                            Text(ContentView.options[index])
                                .foregroundColor(.primary)
                                .font(.largeTitle.weight(.semibold))
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                        }
                    }
                }
                Spacer()
                if showResult {
                    VStack {
                        Text("Score: \(score)")
                        Text("Bot move: \(ContentView.options[botMove])")
                        Text("You \(isWinning ? "WIN" : "LOSE")")
                            .font(.largeTitle.weight(.semibold))
                    }.foregroundColor(.secondary)
                        .font(.headline.weight(.bold))
                }
                Spacer()
            }
        }.alert(gameOverTitle, isPresented: $showGameOver) {
            Button(action: reset) {
                Text("Try again")
            }
        }
    }

    private func calculateResult(with userMove: Int) -> Bool {
        return ContentView.winningCase[userMove] == botMove
    }

    private func buttonDidTap(_ userMove: Int) {
        isWinning = calculateResult(with: userMove)
        score += isWinning ? 1 : 0
        showResult = true
        turnCount += 1

        handleGameState()
    }

    private func handleGameState() {
        if turnCount > maximumTurn {
            gameOver()
        } else {
            nextGame()
        }
    }

    private func nextGame() {
        botMove = Int.random(in: 0..<ContentView.options.count)
    }

    private func gameOver() {
        gameOverTitle = "Your score is \(score) of \(maximumTurn)"
        showGameOver = true
    }

    private func reset() {
        score = 0
        turnCount = 1
        showResult = false
        nextGame()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
