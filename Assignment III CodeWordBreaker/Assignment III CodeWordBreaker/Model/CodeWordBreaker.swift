//
//  CodeBreaker.swift
//  StanfordCourseProject
//
//  Created by mohamed mahmoud sobhy badawy on 28/06/2026.
//

import Foundation

typealias Peg = String

enum Match {
    case noMatch
    case exact
    case inexact
}

struct CodeWordBreaker {
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    var pegChoices: [Peg]
    var pegCount: Int
    
    
    init(pegCount: Int = Int.random(in: 3...6)) {
        
        let characters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        // 1. Define your two themes
//        let emojis: [Peg] = ["👽", "😘", "😂", "😍", "💁", "✌🏻"]
//        let colors: [Peg] = ["red", "blue", "green", "yellow", "orange"]
        
       
//        let selectedTheme = Bool.random() ? characters : characters
        
        // 3. Assign the rest of your variables as normal
        self.pegChoices = characters
        self.pegCount = pegCount
        self.masterCode = Code(kind: .master(isHidden: true), pegCount: pegCount)
        self.guess = Code(kind: .guess, pegCount: pegCount)
        
//        masterCode.randomize(from: selectedTheme)
    }
    
   
    
   

    mutating func resetTheGame() {
        // 1. Choose a new random size
        pegCount = Int.random(in: 3...6)
        
        // 2. Clear previous attempts
        attempts = []
        
        // 3. Rebuild guess and masterCode with the new size
        guess = Code(kind: .guess, pegCount: pegCount)
        masterCode = Code(kind: .master(isHidden: true), pegCount: pegCount)
    }
   
    
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    mutating func attemptGuess() {
        guard !guess.pegs.contains(Code.missingPeg) else { return }
                
        let isDuplicate = attempts.contains { $0.pegs == guess.pegs }
                guard !isDuplicate else { return }
        
                
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
                
        guess.reset()
                
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
