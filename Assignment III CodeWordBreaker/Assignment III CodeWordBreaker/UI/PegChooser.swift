//
//  PegChooser.swift
//  StanfordCourseProject
//
//  Created by mohamed mahmoud sobhy badawy on 02/07/2026.
//


import SwiftUI

struct PegChooser: View {
    
    //MARK: - Data In
    let choices1 = ["Q","W","E","R","T","Y","U","I","O","P"]
    let choices2 = ["A","S","D","F","G","H","J","K","L"]
    let choices3 = ["Z","X","C","V","B","N","M"]
    
    
    //MARK: - Data Out Function
    let onChoose: ((Peg) -> Void)?
    
    //MARK: - Body
    var body: some View {
        VStack{
            HStack {
                ForEach(choices1, id: \.self) { peg in
                    Button {
                        onChoose?(peg)
                    } label: {
                        PegView(peg: peg)
                    }
                }
            }
            
            HStack {
                ForEach(choices2, id: \.self) { peg in
                    Button {
                        onChoose?(peg)
                    } label: {
                        PegView(peg: peg)
                    }
                }
            }
            
            
            HStack {
                ForEach(choices3, id: \.self) { peg in
                    Button {
                        onChoose?(peg)
                    } label: {
                        PegView(peg: peg)
                    }
                }
            }
            
        }

    }
}
