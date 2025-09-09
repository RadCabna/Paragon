//
//  Backgrounds.swift
//  Paragon_Game
//
//  Created by Алкександр Степанов on 30.08.2025.
//

import SwiftUI

struct Backgrounds: View {
    @AppStorage("brightness") var brightness:Double = 0.3
    var backgroundNumber = 1
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width
            let isLandscape = width > height
            if isLandscape {
                ZStack {
                    Image(whatBG())
                        .resizable()
                        .ignoresSafeArea()
                    Color.black.opacity(0.3 - brightness).ignoresSafeArea()
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            } else {
                ZStack {
                    Image(whatBG())
                        .resizable()
                        .frame(width: height*1.2, height: width)
                        .rotationEffect(Angle(degrees: -90))
                    Color.black.opacity(0.3 - brightness).ignoresSafeArea()
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
    
    func whatBG() -> String{
        switch backgroundNumber {
        case 0:
            return "background_0"
        case 1:
            return "background_1"
        case 2:
            return "background_2"
        case 3:
            return "background_3"
        case 4:
            return "background_4"
        case 5:
            return "background_5"
        default:
            return "background_1"
        }
    }
}

#Preview {
    Backgrounds()
}
