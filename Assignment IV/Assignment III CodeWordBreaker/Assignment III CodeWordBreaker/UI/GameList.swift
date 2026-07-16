import SwiftUI
import SwiftData

struct GameList: View {
    @Binding var selection: CodeWordBreaker?
    let searchText: String
    
    @AppStorage("defaultPegCount") private var defaultPegCount: Int = 5
    @AppStorage("defaultExactColor") private var defaultExactColor: String = "#6600FF00"
    @AppStorage("defaultInexactColor") private var defaultInexactColor: String = "#66FFFF00"
    @AppStorage("defaultNoMatchColor") private var defaultNoMatchColor: String = "#66808080"
    
    @Environment(\.modelContext) var modelContext
    @Query private var games: [CodeWordBreaker]
    
    @State private var gameToEdit: CodeWordBreaker?
    @State private var draftGame: CodeWordBreaker?
    @State private var showingSettings: Bool = false
    
    enum SortOption: CaseIterable {
        case name
        case recent
        case completed
        
        var title: String {
            switch self {
            case .name: "Sort by Name"
            case .recent: "Recent"
            case .completed: "Completed"
            }
        }
    }
    
    init(sortBy: SortOption = .name, searchText: String = "", selection: Binding<CodeWordBreaker?>) {
        _selection = selection
        self.searchText = searchText
        
        let completedOnly = sortBy == .completed
        
        // SwiftData handles the basic completion filter at the database level
        let predicate = #Predicate<CodeWordBreaker> { game in
            (!completedOnly || game.isOver)
        }
        
        switch sortBy {
        case .name: _games = Query(filter: predicate, sort: \CodeWordBreaker.name)
        case .recent, .completed: _games = Query(filter: predicate, sort: \CodeWordBreaker.lastAttemptDate, order: .reverse)
        }
    }
    
    // MARK: - Filtered Results
    
    // The view simply asks the model for the matching logic
    var searchResults: [CodeWordBreaker] {
        games.filter { $0.matches(search: searchText) }
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(searchResults) { game in
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
        gameToEdit = nil
        let newGame = CodeWordBreaker(name: "Untitled", pegCount: defaultPegCount)
        newGame.exactColor = defaultExactColor
        newGame.inexactColor = defaultInexactColor
        newGame.noMatchColor = defaultNoMatchColor
        draftGame = newGame
    }
    
    private func handleEditGame(_ game: CodeWordBreaker) {
        gameToEdit = game
        let copy = CodeWordBreaker(name: game.name, pegCount: game.pegCount)
        copy.exactColor = game.exactColor
        copy.inexactColor = game.inexactColor
        copy.noMatchColor = game.noMatchColor
        draftGame = copy
    }
    
    private func handleDeleteGame(_ game: CodeWordBreaker) {
        withAnimation {
            modelContext.delete(game)
        }
    }
    
    private func deleteGames(at offsets: IndexSet) {
        for offset in offsets {
            let gameToDelete = searchResults[offset]
            modelContext.delete(gameToDelete)
        }
    }
    
    private func showSettings() {
        showingSettings = true
    }
    
    // MARK: - Save Logic
    
    private func saveDraft(_ draft: CodeWordBreaker) {
        draft.applyPegCountChange()
        
        if let gameToEdit, let index = games.firstIndex(of: gameToEdit) {
            games[index].name = draft.name
            
            if games[index].pegCount != draft.pegCount {
                games[index].pegCount = draft.pegCount
                games[index].applyPegCountChange()
            }
            
            games[index].exactColor = draft.exactColor
            games[index].inexactColor = draft.inexactColor
            games[index].noMatchColor = draft.noMatchColor
        } else {
            modelContext.insert(draft)
        }
        
        gameToEdit = nil
        draftGame = nil
    }
}
