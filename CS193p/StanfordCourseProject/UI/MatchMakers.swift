//
//  StanfordCourseProjectApp.swift
//  StanfordCourseProject
//
//  Created by mohamed mahmoud sobhy badawy on 28/06/2026.
//

import SwiftUI

enum Match {
    case noMatch
    case exact
    case inexact
}

struct MatchMakers: View {
    private let exactCount: Int
    private let foundCount: Int
    private let totalPegs: Int
    
    init(matches: [Match]) {
        self.exactCount = matches.filter { $0 == .exact }.count
        self.foundCount = matches.filter { $0 != .noMatch }.count
        self.totalPegs = matches.count
    }
    
    var body: some View {
        // Calculate how many columns are needed (round up if odd)
        let columns = (totalPegs + 1) / 2
        
        HStack {
            ForEach(0..<columns, id: \.self) { col in
                VStack {
                    matchMaker(peg: col * 2)
                    
                    if (col * 2 + 1) < totalPegs {
                        matchMaker(peg: col * 2 + 1)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func matchMaker(peg: Int) -> some View {
        Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }
}
