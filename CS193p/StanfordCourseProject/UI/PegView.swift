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
    
    //MARK: - Body
    
    let pegShape = Circle() // RoundedRectangle(cornerRadius: 10)
    
    var body: some View {
      
        pegShape
            .foregroundStyle(Color(pegName: peg) ?? .clear)
        .overlay {
            if peg == Code.missingPeg {
                pegShape
                    .strokeBorder(Color.gray)
            }else if Color(pegName: peg) == nil {
              
                Text(peg)
                    .font(.system(size: 120))
                    .minimumScaleFactor(9.0 / 120.0)
            }
        }
        .contentShape(pegShape)
        .aspectRatio(1, contentMode: .fit)
     
    }
    
//    func color(for peg: String) -> Color? {
//        switch peg.lowercased() {
//        case "red": return .red
//        case "blue": return .blue
//        case "yellow": return .yellow
//        case "green": return .green
//        case "purple": return .purple
//        case "orange": return .orange
//        case "clear": return .clear
//        default: return nil
//        }
//    }
}

