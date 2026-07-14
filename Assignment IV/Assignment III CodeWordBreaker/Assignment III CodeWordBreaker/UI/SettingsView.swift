//
//  SettingsView.swift
//  Assignment III CodeWordBreaker
//
//  Created by mohamed mahmoud sobhy badawy on 14/07/2026.
//


import SwiftUI

struct SettingsView: View {
    // MARK: Data (Function) In
    @Environment(\.dismiss) private var dismiss
    
    // MARK: Global Settings via AppStorage
    @AppStorage("defaultPegCount") private var pegCount: Int = 5
    @AppStorage("defaultExactColor") private var exactColorHex: String = "#6600FF00"
    @AppStorage("defaultInexactColor") private var inexactColorHex: String = "#66FFFF00"
    @AppStorage("defaultNoMatchColor") private var noMatchColorHex: String = "#66808080"
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                Section("Default Number of Pegs") {
                    Stepper("Peg Count: \(pegCount)", value: $pegCount, in: 3...8)
                }
                
                Section("Default Pegs Color For Matching") {
                    ColorPicker("Exact Match", selection: Binding(
                        get: { Color(hex: exactColorHex) },
                        set: { exactColorHex = $0.toHex() }
                    ), supportsOpacity: true)
                    
                    ColorPicker("Inexact Match", selection: Binding(
                        get: { Color(hex: inexactColorHex) },
                        set: { inexactColorHex = $0.toHex() }
                    ), supportsOpacity: true)
                    
                    ColorPicker("No Match", selection: Binding(
                        get: { Color(hex: noMatchColorHex) },
                        set: { noMatchColorHex = $0.toHex() }
                    ), supportsOpacity: true)
                }
            }
            .navigationTitle("Global Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}