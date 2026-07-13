//
//  GameChooser.swift
//  Assignment III CodeWordBreaker
//
//  Created by mohamed mahmoud sobhy badawy on 13/07/2026.
//


//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 4/30/25.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me    
    @State private var selection: CodeWordBreaker? = nil
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            GameList(selection: $selection)
                .navigationTitle("CodeWordBreaker")
        } detail: {
            if let selection {
                CodeWordBreakerView(game: selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a game!")
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    GameChooser()
}
