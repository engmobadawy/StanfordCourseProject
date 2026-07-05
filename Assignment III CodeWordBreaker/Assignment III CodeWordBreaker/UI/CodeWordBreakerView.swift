//
//  CodeWordBreakerView.swift
//  StanfordCourseProject
//
//  Created by mohamed mahmoud sobhy badawy on 28/06/2026.
//

import SwiftUI

struct CodeWordBreakerView: View {
    // MARK: Data In
    @Environment(\.words) var words
    
    // MARK: Data Owned by Me
    @State private var game: CodeWordBreaker = CodeWordBreaker()
    @State private var selection: Int = 0
    
    // NEW: State for highlighting and preventing double-taps
    @State private var highlightedIndices: [Int] = []
    @State private var isChecking: Bool = false
    
    var body: some View {
        VStack {
            view(for: game.masterCode)
            
            ScrollView {
                if !game.isOver {
                    view(for: game.guess)
                }
                
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            
            PegChooser { peg in
                game.setGuessPeg(peg, at: selection)
                
                // 1. Search for the lowest index that is still empty
                if let firstEmptyIndex = game.guess.pegs.firstIndex(of: Code.missingPeg) {
                    selection = firstEmptyIndex
                } else {
                    // 2. Fallback if full: cycle sequentially
                    selection = (selection + 1) % game.pegCount
                }
            }
        }
        .padding()
        .onChange(of: words.count, initial: true) { _, _ in
            game.masterCode.word = words.random(length: game.pegCount) ?? String(repeating: "E", count: game.pegCount)
            print("\(game.masterCode.word) ")
        }
    }
    
    var guessButton: some View {
        Button {
            // 1. Check if there is an empty peg slot
            if let firstEmptyIndex = game.guess.pegs.firstIndex(of: Code.missingPeg) {
                withAnimation { selection = firstEmptyIndex }
            } else {
                // 2. Call the new animation-delayed function
                submitGuessWithAnimationDelay()
            }
        } label: {
            Text("Guess")
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
        .disabled(isChecking) // NEW: Disable while animating
    }
    
    var resetButton: some View {
        Button {
            withAnimation {
                game.resetTheGame()
                selection = 0
                game.masterCode.word = words.random(length: game.pegCount) ?? String(repeating: "E", count: game.pegCount)
                print("New word generated: \(game.masterCode.word)")
            }
        } label: {
            Text("Reset")
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    // NEW: Calculate matches, animate highlight for 1 second, then submit
    private func submitGuessWithAnimationDelay() {
        isChecking = true
        
        let matches = game.guess.match(against: game.masterCode)
        let exactIndices = matches.enumerated().compactMap { index, match in
            match == .exact ? index : nil
        }
        
        // Trigger the highlight with a 1-second duration
        withAnimation(.easeInOut(duration: 1.0)) {
            highlightedIndices = exactIndices
        } completion: {
            // This block fires automatically when the 1-second animation completes
            withAnimation {
                highlightedIndices = []
                game.attemptGuess()
                selection = 0
                isChecking = false
            }
        }
    }
    
    func view(for code: Code) -> some View {
        HStack {
            
            CodeView(
                code: code,
                selection: $selection,
                highlightedIndices: code.kind == .guess ? highlightedIndices : []
            )
            
            Rectangle().foregroundStyle(Color.clear).aspectRatio(contentMode: .fit)
                .overlay {
                    switch code.kind {
                    case .master:
                        resetButton
                    case .guess:
                        guessButton
                    default:
                        EmptyView()
                    }
                }
        }
    }
    
    struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor: CGFloat = minimumFontSize / maximumFontSize
    }
}



extension Color {
    init?(pegName: String) {
        switch pegName.lowercased() {
        case "red": self = .red
        case "blue": self = .blue
        case "yellow": self = .yellow
        case "green": self = .green
        case "purple": self = .purple
        case "orange": self = .orange
        case "clear": self = .clear
        default: return nil
        }
    }
}


#Preview {
    CodeWordBreakerView()
}
