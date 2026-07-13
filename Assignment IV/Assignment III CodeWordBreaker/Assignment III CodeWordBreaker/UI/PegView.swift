//
//  PegView.swift
//  StanfordCourseProject
//
//  Created by mohamed mahmoud sobhy badawy on 02/07/2026.
//


import SwiftUI

struct PegView: View {
    //MARK: - Data In
    let peg: Peg
    
    // NEW: Track highlight state
    var isHighlighted: Bool = false
    
    //MARK: - Body
    let pegShape = Circle()
    
    var body: some View {
        pegShape
            // NEW: Prioritize the green highlight color if active
            .foregroundStyle(isHighlighted ? Color.green : (Color(pegName: peg) ?? .clear))
            .overlay {
                if peg == Code.missingPeg {
                    pegShape
                        .strokeBorder(Color.gray)
                } else if Color(pegName: peg) == nil {
                    Text(peg)
                        .font(.system(size: 120))
                        .minimumScaleFactor(9.0 / 120.0)
                }
            }
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
    }
}
