//
//  ContentView.swift
//  WordScramble
//
//  Created by Patompong Manprasatkul on 26/04/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0

    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false

    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                }

                Section {
                    Text("Your score is: \(score)")
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle.fill")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .toolbar {
                HStack {
                    Button("New word", action: startGame)

                    Button("Reset", role: .destructive, action: resetGame)
                        .font(.body.bold())
                        .foregroundColor(.red)
                }
            }
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) {

                }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.isEmpty == false else { return }

        guard isDifference(word: answer) else {
            wordError(title: "Word as same as start word", message: "You must not enter the start word")
            return
        }

        guard isLongEnough(word: answer) else {
            wordError(title: "Word too short", message: "You must enter more than 3 characters")
            return
        }

        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }

        score += answer.count

        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }

    private func resetGame() {
        score = 0
        newWord = ""
        usedWords = []
        startGame()
    }

    private func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        assertionFailure("Could not load start.txt from bundle.")
    }

    private func isOriginal(word: String) -> Bool {
        usedWords.contains(word) == false
    }

    private func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }

    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }

    private func isLongEnough(word: String) -> Bool {
        word.count > 3
    }

    private func isDifference(word: String) -> Bool {
        word != rootWord
    }
    private func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
