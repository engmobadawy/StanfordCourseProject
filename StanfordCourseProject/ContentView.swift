//
//  ContentView.swift
//  StanfordCourseProject
//
//  Created by mohamed mahmoud sobhy badawy on 28/06/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            pegs(colors: [.red, .green, .blue, .yellow,.purple,.pink, .yellow,.purple,.pink])
            pegs(colors: [.green, .green, .red, .blue,.black])
            pegs(colors: [.red, .green, .blue])
            pegs(colors: [.red, .green, .red , .red])
        }
        .padding()
    }
    
    func pegs(colors: [Color]) -> some View {
        HStack {
            ForEach(colors.indices, id: \.self) { index in
                Circle()
                    .foregroundStyle(colors[index])
            }
            MatchMarkers(matches: [.exact, .inExact, .exact, .exact ])
        }
    }
}

#Preview {
    ContentView()
}
