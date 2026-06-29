//
//  MatchMarkers.swift
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
    
    init(matches: [Match]) {
        self.exactCount = matches.count { $0 == .exact }
        self.foundCount = matches.count { $0 != .noMatch }
    }
    
    var body: some View {
        HStack {
            VStack {
                matchMaker(peg: 0)
                matchMaker(peg: 1)
            }
            VStack {
                matchMaker(peg: 2)
                matchMaker(peg: 3)
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

