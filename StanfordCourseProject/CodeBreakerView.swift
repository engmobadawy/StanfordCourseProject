//
//  CodeBreakerView.swift
//  StanfordCourseProject
//
//  Created by mohamed mahmoud sobhy badawy on 28/06/2026.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game: CodeBreaker = CodeBreaker()
    var body: some View {
        VStack{
            
            view(for: game.masterCode)
            
            ScrollView {
                view(for: game.guess)
                
                ForEach(game.attempts.indices.reversed(), id: \.self, content: { index in
                    view(for: game.attempts[index])
                })
            }
        }
        .padding()
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    var restButton: some View {
        Button("Rest") {
            withAnimation {
                game.rest()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self, content: { index in
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(color(for: code.pegs[index]) ?? .clear)
                    .overlay {
                        if code.pegs[index] == Code.missingPeg {
                            RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray)
                        }else if color(for: code.pegs[index]) == nil {
                             Circle()
                                .fill(Color.clear)
                                .overlay(
                                    Text(code.pegs[index])
                                        .font(.system(size: 120))
                                        .minimumScaleFactor(9.0 / 120.0)
                                )
                        }
                    }
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                  
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            })

            
            Rectangle().foregroundStyle(Color.clear).aspectRatio(contentMode: .fit)
                .overlay{
                    if let matches = code.matches {
                        MatchMakers(matches: matches)
                            
                                 
                            }
                    if code.kind == .master {
                       restButton
                   } else if code.kind == .guess {
                       guessButton
                   }
                    }
                }
        
    }
    
    
    
    
    func color(for peg: String) -> Color? {
        switch peg.lowercased() {
        case "red": return .red
        case "blue": return .blue
        case "yellow": return .yellow
        case "green": return .green
        case "purple": return .purple
        case "orange": return .orange
        case "clear": return .clear
        default: return nil
        }
    }
}


#Preview {
    CodeBreakerView()
}
