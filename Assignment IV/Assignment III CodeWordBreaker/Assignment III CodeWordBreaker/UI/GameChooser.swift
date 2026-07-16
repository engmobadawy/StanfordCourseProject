//
//  GameChooser.swift
//  Assignment III CodeWordBreaker
//
//  Created by mohamed mahmoud sobhy badawy on 13/07/2026.
//




import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State private var selection: CodeWordBreaker? = nil
    
    @State private var sortOption: GameList.SortOption = .name
    @State private var search: String = ""

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Picker("Sort By", selection: $sortOption.animation(.default)) {
                ForEach(GameList.SortOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
           
            GameList(sortBy: sortOption, searchText: search, selection: $selection)
                .navigationTitle("Code Breaker")
                .searchable(text: $search)
                .animation(.easeOut, value: search)
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
