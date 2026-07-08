//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by mohamed mahmoud sobhy badawy on 09/07/2026.
//


import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name).font(.title)
            
            if let lastAttempt = game.attempts.first {
                CodeView(code: lastAttempt) {
                    if let matches = lastAttempt.matches {
                        MatchMarkers(matches: matches)
                    }
                }
            } else {
                // Displays a blank code for newly created games
                CodeView(code: Code(kind: .unknown))
            }
          
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
}