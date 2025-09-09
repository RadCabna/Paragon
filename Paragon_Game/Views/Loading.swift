//
//  Loading.swift
//  Paragon_Game
//
//  Created by Алкександр Степанов on 30.08.2025.
//

import SwiftUI

struct Loading: View {
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width
            let isLandscape = width > height
            if isLandscape {
                ZStack {
                    Backgrounds(backgroundNumber: 0)
                    Image(.gameLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width*0.25)
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            } else {
                ZStack {
                    Backgrounds(backgroundNumber: 0)
                    Image(.gameLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: height*0.25)
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}

#Preview {
    Loading()
}
