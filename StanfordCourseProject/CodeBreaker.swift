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
    var thereIsAChange = false
    var itISANewDifferentAttempt: Bool = true
   
    
    init(pegCount: Int = Int.random(in: 3...6)) {
            // 1. Define your two themes
            let emojis: [Peg] = ["👽", "😘", "😂", "😍", "💁", "✌🏻"]
            let colors: [Peg] = ["red", "blue", "yellow", "green", "purple", "orange"]
            
            // 2. Randomly pick one (true = emojis, false = colors)
            let selectedTheme = Bool.random() ? emojis : colors
            
            // 3. Assign the rest of your variables as normal
            self.pegChoices = selectedTheme
            self.pegCount = pegCount
            self.masterCode = Code(kind: .master, pegCount: pegCount)
            self.guess = Code(kind: .guess, pegCount: pegCount)
            
            masterCode.randomize(from: selectedTheme)
        }
    
    mutating func rest() {
        attempts = []
        guess.pegs = Array(repeating: Code.missing, count: pegCount)
        itISANewDifferentAttempt = true
    }
    
    mutating func attemptGuess() {
        var attempt = guess
        if thereIsAChange == true  {
            
          for guess in attempts {
                if guess.pegs != attempt.pegs {
                  itISANewDifferentAttempt = true
                  break
              }
              itISANewDifferentAttempt = false
              
            }
            if itISANewDifferentAttempt == true {
                attempt.kind = .attemp(guess.match(against: masterCode))
                attempts.append(attempt)
                itISANewDifferentAttempt = false
                thereIsAChange = false
               
            }
            
            
        }
    }
    
    mutating func changeGuessPeg(at index: Int) {
        thereIsAChange = true
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
}

struct Code {
    var kind: Kind
    var pegs: [Peg]
    
    static let missing: Peg = "clear"
    init(kind: Kind , pegCount : Int) {
        self.kind = kind
        self.pegs = Array(repeating: Code.missing, count: pegCount)
        
    }
    
    enum Kind: Equatable {
        case master
        case guess
        case attemp([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
    }
    
    var matches: [Match] {
        switch kind {
        case .attemp(let matches): return matches
        default: return Array(repeating: .noMatch, count: pegs.count)
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .noMatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        
        return results
    }
}

