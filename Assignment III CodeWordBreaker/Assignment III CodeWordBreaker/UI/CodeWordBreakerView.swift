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
    var body: some View {
        VStack{
            
            view(for: game.masterCode)
            
            ScrollView {
                if !game.isOver {
                    view(for: game.guess)
                }
                
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            
            PegChooser(/*choices: game.pegChoices*/) { peg in
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
        
        .onChange(of: words.count, initial: true) { _,_  in
            
                
    
                    game.masterCode.word = words.random(length: game.pegCount) ?? String(repeating: "E", count: game.pegCount)
                    
                    print("\(game.masterCode.word) ")
                
            
        }
    }
    
//    var guessButton: some View {
//        Button {
//            withAnimation {
//                game.attemptGuess()
//                selection = 0
//            }
//        } label: {
//            Text("Guess")
//        }
//        .font(.system(size: GuessButton.maximumFontSize))
//        .minimumScaleFactor(GuessButton.scaleFactor)
//    }
    
    var guessButton: some View {
            Button {
                withAnimation {
                    // 1. Check if there is an empty peg slot
                    if let firstEmptyIndex = game.guess.pegs.firstIndex(of: Code.missingPeg) {
                        // 2. Snap the UI selection to the empty slot so the user knows to fill it
                        selection = firstEmptyIndex
                    } else {
                        // 3. If full, submit the guess and reset selection for the new turn
                        game.attemptGuess()
                        selection = 0
                    }
                }
            } label: {
                Text("Guess")
            }
            .font(.system(size: GuessButton.maximumFontSize))
            .minimumScaleFactor(GuessButton.scaleFactor)
        }
    
    // CodeWordBreakerView.swift

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
    
    func view(for code: Code) -> some View {
        HStack {
//            ForEach(code.pegs.indices, id: \.self, content: { index in
//                RoundedRectangle(cornerRadius: 10)
//                    .foregroundStyle(color(for: code.pegs[index]) ?? .clear)
//                    .overlay {
//                        if code.pegs[index] == Code.missingPeg {
//                            RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray)
//                        }else if color(for: code.pegs[index]) == nil {
//                             Circle()
//                                .fill(Color.clear)
//                                .overlay(
//                                    Text(code.pegs[index])
//                                        .font(.system(size: 120))
//                                        .minimumScaleFactor(9.0 / 120.0)
//                                )
//                        }
//                    }
//                    .contentShape(Rectangle())
//                    .aspectRatio(1, contentMode: .fit)
//                  
//                    .onTapGesture {
//                        if code.kind == .guess {
//                            game.changeGuessPeg(at: index)
//                        }
//                    }
//            })

            CodeView(code: code, selection: $selection)
            Rectangle().foregroundStyle(Color.clear).aspectRatio(contentMode: .fit)
//            Color.clear.aspectRatio(1, contentMode: .fit)
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
