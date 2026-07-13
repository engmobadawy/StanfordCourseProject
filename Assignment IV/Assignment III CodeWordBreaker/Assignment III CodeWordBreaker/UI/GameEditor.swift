//
//  GameEditor.swift
//  Assignment III CodeWordBreaker
//

import SwiftUI

struct GameEditor: View {
    // MARK: Data (Function) In
    @Environment(\.dismiss) private var dismiss
    
    // MARK: Data Shared with Me
    @Bindable var game: CodeWordBreaker
    
    // MARK: Action Function
    let onChoose: () -> Void
    
    // MARK: Data Owned by Me
    @State private var showInvalidGameAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $game.name)
                        .autocapitalization(.words)
                        .autocorrectionDisabled(false)
                        .onSubmit {
                            done()
                        }
                }
                
                Section("Number of Pegs") {
                    Stepper("Peg Count: \(game.pegCount)", value: $game.pegCount, in: 3...8)
                }
                
                Section("Pegs Color For Matching") {
                    ColorPicker("Exact Match", selection: Binding(
                        get: { Color(hex: game.exactColor) },
                        set: { game.exactColor = $0.toHex() }
                    ), supportsOpacity: true)
                    
                    ColorPicker("Inexact Match", selection: Binding(
                        get: { Color(hex: game.inexactColor) },
                        set: { game.inexactColor = $0.toHex() }
                    ), supportsOpacity: true)
                    
                    ColorPicker("No Match", selection: Binding(
                        get: { Color(hex: game.noMatchColor) },
                        set: { game.noMatchColor = $0.toHex() }
                    ), supportsOpacity: true)
                }
                
//                Section("In Exact Pegs Color") {
//                   
//                }
//                
//                Section("No Match Pegs Color") {
//                   
//                }
                
//                Section("Pegs Shape"){
//                    // Add your shape picking logic here
//                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        done()
                    }
                    .alert("Invalid Game", isPresented: $showInvalidGameAlert) {
                        Button("OK") {
                            showInvalidGameAlert = false
                        }
                    } message: {
                        Text("A game must have a name and more than one unique peg.")
                    }
                }
            }
        }
    }
    
    func done() {
        if game.isValid {
            onChoose()
            dismiss()
        } else {
            showInvalidGameAlert = true
        }
    }
}

extension CodeWordBreaker {
    var isValid: Bool {
        !name.isEmpty
    }
}


