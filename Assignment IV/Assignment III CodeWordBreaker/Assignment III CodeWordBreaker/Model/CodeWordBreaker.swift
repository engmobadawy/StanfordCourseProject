//
//  CodeBreaker.swift
//  StanfordCourseProject
//
//  Created by mohamed mahmoud sobhy badawy on 28/06/2026.
//

import SwiftUI
import SwiftData

typealias Peg = String

@Model class CodeWordBreaker {
    var name: String
    @Relationship(deleteRule: .cascade) var masterCode: Code
    @Relationship(deleteRule: .cascade) var guess: Code
    @Relationship(deleteRule: .cascade) var _attempts: [Code] = []
    var pegChoices: [Peg] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    // NEW: Property without the didSet observer
    var pegCount: Int
    
    /* OLD CODE COMMENTED OUT:
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
    */
    
    @Transient var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    var lastAttemptDate: Date? = Date.now
    
    
    var attempts: [Code] {
        get { _attempts.sorted { $0.timestamp > $1.timestamp } }
        set { _attempts = newValue }
    }
    
    // Stored entirely as Hex Strings
    var exactColor: String = "#6600FF00"
    var inexactColor: String = "#66FFFF00"
    var noMatchColor: String = "#66808080"
    
    init(name: String, pegCount: Int = 5) {
        self.name = name
        self.pegCount = pegCount
        self.masterCode = Code(kind: .master(isHidden: true), pegCount: pegCount)
        self.guess = Code(kind: .guess, pegCount: pegCount)
    }
    
    // NEW: Manual function to handle peg count changes since SwiftData ignores didSet
    func applyPegCountChange() {
        if guess.pegCount != pegCount {
            attempts = []
            guess = Code(kind: .guess, pegCount: pegCount)
            masterCode = Code(kind: .master(isHidden: true), pegCount: pegCount)
            
            startTime = nil
            endTime = nil
            elapsedTime = 0
        }
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
            elapsedTime += 0.00001
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
        isOver = false
    }
   
    var isOver: Bool = false
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    func attemptGuess() {
        guard !guess.pegs.contains(Code.missingPeg) else { return }
                
        let isDuplicate = attempts.contains { $0.pegs == guess.pegs }
        guard !isDuplicate else { return }
        
        
        // FIX: Instantiate a completely new Code instance so we don't
        // mutate the current guess reference when we call guess.reset()
        let matchResult = guess.match(against: masterCode)
        let attempt = Code(kind: .attempt(matchResult), pegCount: pegCount)
                
        // Copy the pegs from the current guess to the new attempt
        attempt.pegs = guess.pegs
        
        
        
        attempts.insert(attempt, at: 0)
        lastAttemptDate = .now
                
        guess.reset()
                
        if attempts.first?.pegs == masterCode.pegs {
            isOver = true
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
    
    func updateElapsedTime() {
        pauseTimer()
        startTimer()
    }
}

extension CodeWordBreaker {
    func matches(search text: String) -> Bool {
        // 1. If search is empty, show everything
        if text.isEmpty { return true }
        
        // 2. Always allow searching by name, current guess, or past attempts
        let nameMatch = name.localizedStandardContains(text)
        let guessMatch = guess.word.localizedStandardContains(text)
        let attemptMatch = attempts.contains { $0.word.localizedStandardContains(text) }
        
        // 3. Prevent cheating: Only allow searching the master code if the game is over
        let masterMatch = isOver && masterCode.word.localizedStandardContains(text)
        
        return nameMatch || guessMatch || attemptMatch || masterMatch
    }
}

//extension CodeWordBreaker: Identifiable, Hashable, Equatable {
//    static func == (lhs: CodeWordBreaker, rhs: CodeWordBreaker) -> Bool {
//        return lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
