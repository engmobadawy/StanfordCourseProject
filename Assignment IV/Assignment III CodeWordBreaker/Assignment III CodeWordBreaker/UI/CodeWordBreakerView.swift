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
    @Environment(\.scenePhase) var scenePhase
    
    // MARK: Data Shared with Me
    let game: CodeWordBreaker
    
    // MARK: Data Owned by Me
    
    @State private var selection: Int = 0
    // for animation
    @State private var restarting = false
    
    // State for highlighting and preventing double-taps
    @State private var currentGuessMatches: [Match]? = nil
    @State private var isChecking: Bool = false
    
    var body: some View {
//        NavigationSplitView(columnVisibility: .constant(.all)){
            VStack {
                CodeView(code: game.masterCode)
                
                ScrollView {
                    if !game.isOver {
                        CodeView(
                                    code: game.guess,
                                    selection: $selection,
                                    guessMatches: currentGuessMatches,
                                    exactColor: game.exactColor,
                                    inexactColor: game.inexactColor,
                                    noMatchColor: game.noMatchColor
                                ) {
                            guessButton
                        }
                        .animation(nil, value: game.attempts.count)
                        .opacity(restarting ? 0 : 1)
                    }
                    ForEach(game.attempts, id: \.pegs) { attempt in
                        CodeView(
                                    code: attempt,
                                    exactColor: game.exactColor,
                                    inexactColor: game.inexactColor,
                                    noMatchColor: game.noMatchColor
                                ){ }
                        .transition(.attempt(game.isOver))
                    }
                }
                
                if !game.isOver {
                    PegChooser(onChoose: changePegAtSelection)
                        .transition(.pegChooser)
                        .frame(maxHeight: 90)
                }
            }
            .navigationTitle(game.name)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Restart", systemImage: "arrow.circlepath", action: restart)
                }
                ToolbarItem {
                    ElapsedTime(startTime: game.startTime, endTime: game.endTime, elapsedTime: game.elapsedTime)
                        .monospaced()
                        .lineLimit(1)
                }
            }
//        } detail: {
//            Text("hiiii")
//        }
//        .navigationSplitViewStyle(.balanced)
        .trackElapsedTime(in: game)
        .onChange(of: words.count, initial: true) { _, _ in
            if game.masterCode.pegs.contains(Code.missingPeg) {
                game.masterCode.word = words.random(length: game.pegCount) ?? String(repeating: "E", count: game.pegCount)
                
                // Print the solution to the console
                print("Initial Game Solution: \(game.masterCode.word)")
            }
        }
        .padding()
    }
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.masterCode.pegs.count
    }
    
    var guessButton: some View {
        Button {
            // 1. Check if there is an empty peg slot
            if let firstEmptyIndex = game.guess.pegs.firstIndex(of: Code.missingPeg) {
                withAnimation { selection = firstEmptyIndex }
            } else {
                // 2. Submit guess with animation
                submitGuessWithAnimationDelay()
            }
        } label: {
            Text("Guess")
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
        .disabled(isChecking)
    }

    func restart() {
        withAnimation(.restart) {
            restarting = game.isOver
            game.resetTheGame()
            
            // Fetch a new word
            game.masterCode.word = words.random(length: game.pegCount) ?? String(repeating: "E", count: game.pegCount)
            
            // Print the solution to the console
            print("New Game Solution: \(game.masterCode.word)")
            
            selection = 0
        } completion: {
            withAnimation(.restart) {
                restarting = false
            }
        }
    }
    
    private func submitGuessWithAnimationDelay() {
        // Prevent double tapping
        isChecking = true
        
        // Generate matches against the master code
        let matches = game.guess.match(against: game.masterCode)
        
        // Trigger the highlight with a 1-second duration
        withAnimation(.easeInOut(duration: 1.0)) {
            currentGuessMatches = matches
        } completion: {
            // This block fires automatically when the animation completes
            withAnimation {
                currentGuessMatches = nil // Clear the overlay for the next guess
                game.attemptGuess()       // Move guess into attempts array
                selection = 0
                isChecking = false
            }
        }
    }
    
    struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor: CGFloat = minimumFontSize / maximumFontSize
    }
}

extension View {
    func trackElapsedTime(in game: CodeWordBreaker) -> some View {
        self.modifier(ElapsedTimeTracker(game: game))
    }
}

struct ElapsedTimeTracker: ViewModifier {
    @Environment(\.scenePhase) var scenePhase
    let game: CodeWordBreaker
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                game.startTimer()
            }
            .onDisappear {
                game.pauseTimer()
            }
            .onChange(of: game) { oldGame, newGame in
                oldGame.pauseTimer()
                newGame.startTimer()
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .active: game.startTimer()
                case .background: game.pauseTimer()
                default: break
                }
            }
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
