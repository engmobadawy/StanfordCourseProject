//
//  CodeBreaker.swift
//  StanfordCourseProject
//
//  Created by mohamed mahmoud sobhy badawy on 28/06/2026.
//

import Foundation
import Observation

typealias Peg = String

enum Match {
    case noMatch
    case exact
    case inexact
}

@Observable class CodeWordBreaker {
    var name: String
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    var pegChoices: [Peg] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var pegCount: Int {
        didSet {
            if pegCount != oldValue {
                attempts = []
                guess = Code(kind: .guess, pegCount: pegCount)
                masterCode = Code(kind: .master(isHidden: true), pegCount: pegCount)
                
                startTime = nil
                endTime = nil
                elapsedTime = 0
            }
        }
    }
    var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    
    // Stored entirely as Hex Strings
    var exactColor: String = "#6600FF00"
    var inexactColor: String = "#66FFFF00"
    var noMatchColor: String = "#66808080"
    
    init(name: String, pegCount: Int = Int.random(in: 5...5)) {
        self.name = name
        self.pegCount = pegCount
        self.masterCode = Code(kind: .master(isHidden: true), pegCount: pegCount)
        self.guess = Code(kind: .guess, pegCount: pegCount)
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    func resetTheGame() {
        attempts = []
        guess = Code(kind: .guess, pegCount: pegCount)
        masterCode = Code(kind: .master(isHidden: true), pegCount: pegCount)
         
        startTime = .now
        endTime = nil
        elapsedTime = 0
    }
   
    var isOver: Bool {
        attempts.first?.pegs == masterCode.pegs
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    func attemptGuess() {
        guard !guess.pegs.contains(Code.missingPeg) else { return }
                
        let isDuplicate = attempts.contains { $0.pegs == guess.pegs }
        guard !isDuplicate else { return }
                
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.insert(attempt, at: 0)
                
        guess.reset()
                
        if isOver {
            endTime = .now
            masterCode.kind = .master(isHidden: false)
            pauseTimer()
        }
    }
    
    func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
    }
}

extension CodeWordBreaker: Identifiable, Hashable, Equatable {
    static func == (lhs: CodeWordBreaker, rhs: CodeWordBreaker) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
