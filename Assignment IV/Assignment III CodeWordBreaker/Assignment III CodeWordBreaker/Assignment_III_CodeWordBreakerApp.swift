//
//  Assignment_III_CodeWordBreakerApp.swift
//  Assignment III CodeWordBreaker
//
//  Created by mohamed mahmoud sobhy badawy on 03/07/2026.
//

import SwiftUI
import SwiftData

@main
struct Assignment_III_CodeWordBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            
            GameChooser()
                .modelContainer(for: CodeWordBreaker.self)
        }
    }
}
