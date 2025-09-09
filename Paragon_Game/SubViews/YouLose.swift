//
//  YouLose.swift
//  Paragon_Game
//
//  Created by Алкександр Степанов on 30.08.2025.
//

import SwiftUI

struct YouLose: View {
    @AppStorage("levelNumber") var levelNumber = 1
    var body: some View {
        ZStack {
            Image(.loseFrame)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth*0.45)
            HStack(alignment: .bottom) {
                Image(.retryButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.09)
                    .onTapGesture {
                        NavGuard.shared.currentScreen = .LEVELS
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                            NavGuard.shared.currentScreen = .GAME
                        }
                    }
                Image(.crossButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.07)
                    .onTapGesture {
                        NavGuard.shared.currentScreen = .MENU
                    }
            }
            .offset(x: screenWidth*0.035, y: screenWidth*0.095)
            Text("LEVEL \(levelNumber)")
                .font(.system(size: screenWidth*0.02, weight: .bold))
                .foregroundStyle(.white)
                .offset(y: -screenWidth*0.15)
        }
    }
}

#Preview {
    YouLose()
}
