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

    var body: some View {
        ZStack {
            LinearGradient(colors: [.pink, .blue], startPoint: .center, endPoint: .bottom).ignoresSafeArea()
            VStack {
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.primary)
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
                                Image(countries[number])
                                    .renderingMode(.original)
                                    .cornerRadius(16)
                                    .shadow(radius: 5)
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
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
    }

    func flagDidTap(_ answer: Int) {
        let isCorrect = correctAnswer == answer
        scoreTitle = isCorrect ? "Correct" : "Wrong"
        score += isCorrect ? 1 : 0
        showingScore = true
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
