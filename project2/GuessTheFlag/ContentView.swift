//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Patompong Manprasatkul on 23/04/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var turnCount = 1
    @State private var showingSummary = false
    @State private var summaryTitle = ""

    private let maximumTurn = 8

    var body: some View {
        ZStack {
            LinearGradient(colors: [.pink, .blue], startPoint: .center, endPoint: .bottom).ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.primary)
                Spacer()
                Spacer()
                VStack {
                    Text("Tap the flag of")
                        .foregroundStyle(.secondary)
                        .font(.subheadline.weight(.heavy))

                    Text(countries[correctAnswer])
                        .foregroundStyle(.primary)
                        .font(.largeTitle.weight(.semibold))


                    VStack(spacing: 16) {
                        ForEach(0..<3) { number in
                            Button {
                                flagDidTap(number)
                            } label: {
                                FlagImage(name: countries[number])
                            }
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(.primary)
                    .font(.title.bold())
                Spacer()
            }.padding()
        }.alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: handleNextGame)
        } message: {
            Text("Your score is \(score)")
        }.alert(summaryTitle, isPresented: $showingSummary) {
            Button("Restart", action: handleResetGame)
        }
    }

    func flagDidTap(_ answer: Int) {
        let isCorrect = correctAnswer == answer
        scoreTitle = isCorrect ? "Correct" : "Wrong! That’s the flag of \(countries[answer])"
        score += isCorrect ? 1 : 0
        showingScore = true
        turnCount += 1
    }

    func handleNextGame() {
        if turnCount > maximumTurn {
            summaryTitle = "Game over!\n Your score is \(score) of \(maximumTurn)"
            showingSummary = true
        } else {
            askQuestion()
        }
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    func handleResetGame() {
        turnCount = 0
        score = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
