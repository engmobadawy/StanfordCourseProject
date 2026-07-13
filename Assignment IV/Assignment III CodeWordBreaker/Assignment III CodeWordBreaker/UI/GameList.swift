//
//  GameList.swift
//  CodeBreaker
//
//

import SwiftUI

struct GameList: View {
    // MARK: Data Shared with Me
    @Binding var selection: CodeWordBreaker?
    
    // MARK: Data Owned by Me
    @State private var games: [CodeWordBreaker] = []
    
    // Used to track which game is being edited so we can replace it upon save
    @State private var gameToEdit: CodeWordBreaker?
    
    // The stable draft object bound directly to the sheet
    @State private var draftGame: CodeWordBreaker?
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu {
                    editButton(for: game)
                    deleteButton(for: game)
                }
                .swipeActions(edge: .leading) {
                    editButton(for: game).tint(.accentColor)
                }
            }
            .onDelete { offsets in
                games.remove(atOffsets: offsets)
            }
            .onMove { offsets, destination in
                games.move(fromOffsets: offsets, toOffset: destination)
            }
        }
        .onChange(of: games) { _, _ in
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .listStyle(.plain)
        .toolbar {
            addButton
            EditButton()
        }
        .onAppear { addSampleGames() }
        .sheet(item: $draftGame) { draft in
            GameEditor(game: draft) {
                saveDraft(draft)
            }
        }
    }
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            gameToEdit = nil // Clear reference since this is a new game
            draftGame = CodeWordBreaker(name: "Untitled", pegCount: 5)
        }
    }
    
    func editButton(for game: CodeWordBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game // Keep track of the original
            
            // Create the standalone draft once
            let copy = CodeWordBreaker(name: game.name, pegCount: game.pegCount)
            copy.exactColor = game.exactColor
            copy.inexactColor = game.inexactColor
            copy.noMatchColor = game.noMatchColor
            copy.pegChoices = game.pegChoices
            
            draftGame = copy
        }
    }
    
    func deleteButton(for game: CodeWordBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll { $0 == game }
            }
        }
    }
    
    private func saveDraft(_ draft: CodeWordBreaker) {
        if let gameToEdit, let index = games.firstIndex(of: gameToEdit) {
            // Update existing game
            games[index] = draft
        } else {
            // Insert new game
            games.insert(draft, at: 0)
        }
        
        // Clean up state
        gameToEdit = nil
        draftGame = nil
    }
    
    func addSampleGames() {
        // Add sample game logic here if needed
    }
}

#Preview {
    @Previewable @State var selection: CodeWordBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
