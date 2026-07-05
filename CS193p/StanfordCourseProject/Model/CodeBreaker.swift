//
//  CodeBreaker.swift
//  StanfordCourseProject
//
//  Created by mohamed mahmoud sobhy badawy on 28/06/2026.
//

import Foundation

typealias Peg = String

struct CodeBreaker {
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    var pegChoices: [Peg]
    var pegCount: Int
    
    init(pegCount: Int = Int.random(in: 3...6)) {
        // 1. Define your two themes
        let emojis: [Peg] = ["👽", "😘", "😂", "😍", "💁", "✌🏻"]
        let colors: [Peg] = ["red", "blue", "green", "yellow", "orange"]
        
        // 2. Randomly pick one (true = emojis, false = colors)
        let selectedTheme = Bool.random() ? emojis : colors
        
        // 3. Assign the rest of your variables as normal
        self.pegChoices = selectedTheme
        self.pegCount = pegCount
        self.masterCode = Code(kind: .master(isHidden: false), pegCount: pegCount)
        self.guess = Code(kind: .guess, pegCount: pegCount)
        
        masterCode.randomize(from: selectedTheme)
    }
    
    mutating func restTheGame() {
        attempts = []
        guess.pegs = Array(repeating: Code.missingPeg, count: pegCount)
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    mutating func attemptGuess() {
        // 1. Prevent guessing if there are any missing pegs (empty slots)
        guard !guess.pegs.contains(Code.missingPeg) else {
            return
        }
        
        // 2. Prevent guessing if this exact combination has already been attempted
        let isDuplicate = attempts.contains { $0.pegs == guess.pegs }
        guard !isDuplicate else {
            return
        }
        
        // 3. Process the valid, unique attempt
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        
        // 4. Reset for the next turn
        guess.reset()
        
        // 5. Check win condition
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
    }
}
