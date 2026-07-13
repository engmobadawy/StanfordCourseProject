//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 4/30/25.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeWordBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name)
                .font(.title)
                .lineLimit(1)
            lastAttemptSection(for: game.attempts.first)
            
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
    
    @ViewBuilder
    private func lastAttemptSection(for attempt: Code?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Last Attempt:")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            if let attempt {
                CodeView(code: attempt) { }
                    .frame(maxHeight: 70)
            } else {
                // Reserves the space equivalent to a fully expanded CodeView
                Color.clear
                    .frame(height: 70)
            }
        }
        .padding(.top, 4)
        .opacity(attempt == nil ? 0 : 1)
    }
}
