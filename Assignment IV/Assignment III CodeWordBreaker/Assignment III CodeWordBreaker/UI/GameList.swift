import SwiftUI

struct GameList: View {
    @Binding var selection: CodeWordBreaker?
    
    @AppStorage("defaultPegCount") private var defaultPegCount: Int = 5
    @AppStorage("defaultExactColor") private var defaultExactColor: String = "#6600FF00"
    @AppStorage("defaultInexactColor") private var defaultInexactColor: String = "#66FFFF00"
    @AppStorage("defaultNoMatchColor") private var defaultNoMatchColor: String = "#66808080"
    
    @State private var games: [CodeWordBreaker] = []
    
   
    @State private var gameToEdit: CodeWordBreaker?
    @State private var draftGame: CodeWordBreaker?
    
    @State private var showingSettings: Bool = false
    
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
            .onDelete(perform: deleteGames)
            .onMove(perform: moveGames)
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button("Settings", systemImage: "gear", action: showSettings)
            }
            
            ToolbarItem(placement: .primaryAction) {
                HStack {
                    addButton
                    EditButton()
                }
            }
        }
        .sheet(item: $draftGame) { draft in
            GameEditor(game: draft) {
                saveDraft(draft)
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
    
    // MARK: - View Components
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus", action: handleAddGame)
    }
    
    func editButton(for game: CodeWordBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            handleEditGame(game)
        }
    }
    
    func deleteButton(for game: CodeWordBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            handleDeleteGame(game)
        }
    }
    
    // MARK: - Action Handlers
    
    private func handleAddGame() {
        gameToEdit = nil // Clear out any old reference
        
        let newGame = CodeWordBreaker(name: "Untitled", pegCount: defaultPegCount)
        newGame.exactColor = defaultExactColor
        newGame.inexactColor = defaultInexactColor
        newGame.noMatchColor = defaultNoMatchColor
        
        draftGame = newGame
    }
    
    private func handleEditGame(_ game: CodeWordBreaker) {
        gameToEdit = game // Remember which live game we are editing
        
        // Create a COPY so changes aren't live. This protects against "Cancel".
        let copy = CodeWordBreaker(name: game.name, pegCount: game.pegCount)
        copy.exactColor = game.exactColor
        copy.inexactColor = game.inexactColor
        copy.noMatchColor = game.noMatchColor
        
        draftGame = copy
    }
    
    private func handleDeleteGame(_ game: CodeWordBreaker) {
        withAnimation {
            games.removeAll { $0 == game }
        }
    }
    
    private func deleteGames(at offsets: IndexSet) {
        games.remove(atOffsets: offsets)
    }
    
    private func moveGames(from source: IndexSet, to destination: Int) {
        games.move(fromOffsets: source, toOffset: destination)
    }
    
    private func showSettings() {
        showingSettings = true
    }
    
    // MARK: - Save Logic
    
    private func saveDraft(_ draft: CodeWordBreaker) {
        if let gameToEdit, let index = games.firstIndex(of: gameToEdit) {
            // User hit "Done" on an existing game. Copy the draft changes over.
            games[index].name = draft.name
            games[index].pegCount = draft.pegCount
            games[index].exactColor = draft.exactColor
            games[index].inexactColor = draft.inexactColor
            games[index].noMatchColor = draft.noMatchColor
        } else {
            // User hit "Done" on a brand new game.
            games.insert(draft, at: 0)
        }
        
        // Clean up
        gameToEdit = nil
        draftGame = nil
    }
}
