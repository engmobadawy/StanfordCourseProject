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
    case inExact
}

struct MatchMarkers: View {
    var matches: [Match]
    private var exactCount: Int { matches.count(where: { $0 == .exact }) }
    private var foundCount: Int { matches.count(where: { $0 != .noMatch }) }

    var body: some View {
        Grid {
            // Top Row: Even indices (0, 2, 4...)
            GridRow {
                ForEach(0..<matches.count, id: \.self) { index in
                    if index % 2 == 0 {
                        matchMarker(peg: index, exactCount: exactCount, foundCount: foundCount)
                    }
                }
            }
            
            // Bottom Row: Odd indices (1, 3, 5...)
            GridRow {
                ForEach(0..<matches.count, id: \.self) { index in
                    if index % 2 != 0 {
                        matchMarker(peg: index, exactCount: exactCount, foundCount: foundCount)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func matchMarker(peg: Int, exactCount: Int, foundCount: Int) -> some View {
        Circle()
            .strokeBorder(peg < foundCount ? Color.primary : Color.clear, lineWidth: 2)
            .background {
                Circle()
                    .fill(peg < exactCount ? Color.primary : Color.clear)
            }
            .aspectRatio(1, contentMode: .fit)
    }
}
