//
//  CodeView.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 4/16/25.
//

//
//  CodeView.swift
//  CodeBreaker
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    // MARK: Data In
    let code: Code
    var guessMatches: [Match]? = nil
    
    // Expect Strings for hex values
    var exactColor: String
    var inexactColor: String
    var noMatchColor: String
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    // MARK: Data (sort of) In Function
    @ViewBuilder let ancillaryView: () -> AncillaryView
    
    // MARK: Data Owned by Me
    @Namespace private var selectionNamespace
    
    init(
        code: Code,
        selection: Binding<Int> = .constant(-1),
        guessMatches: [Match]? = nil,
        exactColor: String = "#6600FF00",
        inexactColor: String = "#66FFFF00",
        noMatchColor: String = "#66808080",
        @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ) {
        self.code = code
        self._selection = selection
        self.guessMatches = guessMatches
        self.exactColor = exactColor
        self.inexactColor = inexactColor
        self.noMatchColor = noMatchColor
        self.ancillaryView = ancillaryView
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(peg: code.pegs[index])
                    .padding(Selection.border)
                    .background { // selection background
                        Group {
                            if selection == index, code.kind == .guess {
                                Selection.shape
                                    .foregroundStyle(Selection.color)
                                    .matchedGeometryEffect(id: "selection", in: selectionNamespace)
                            }
                        }
                        .animation(.selection, value: selection)
                    }
                    .overlay {
                        if let matches = guessMatches, matches.indices.contains(index) {
                            Selection.shape
                            .foregroundStyle(
                                (matches[index] == .exact ? Color(hex: exactColor) :
                                 matches[index] == .inexact ? Color(hex: inexactColor) :
                                 Color(hex: noMatchColor))
                            )
                        }
                    }
                    .overlay { // hidden code obscuring
                        Selection.shape
                            .foregroundStyle(code.isHidden ? Color.gray : .clear)
                            .transaction { transaction in
                                if code.isHidden {
                                    transaction.animation = nil
                                }
                            }
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                        }
                    }
            }
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay {
                    ancillaryView()
                }
        }
    }
}

fileprivate struct Selection {
    static let border: CGFloat = 5
    static let cornerRadius: CGFloat = 10
    static let color: Color = Color.gray.opacity(0.85) 
    static let shape = RoundedRectangle(cornerRadius: cornerRadius)
}
