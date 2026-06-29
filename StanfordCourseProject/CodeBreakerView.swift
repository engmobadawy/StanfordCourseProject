//
//  CodeBreakerView.swift
//  StanfordCourseProject
//
//  Created by mohamed mahmoud sobhy badawy on 28/06/2026.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game: CodeBreaker = CodeBreaker(pegChoices: [.green, .red, .blue, .yellow])
    
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
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self, content: { index in
                RoundedRectangle(cornerRadius: 10)
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(code.pegs[index])
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            })

            MatchMakers(matches: code.matches)
                .overlay {
                    if code.kind == .guess {
                        guessButton
                    }
                }
        }
    }
}


#Preview {
    CodeBreakerView()
}
