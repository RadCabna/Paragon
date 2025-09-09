//
//  StartLevel.swift
//  Paragon_Game
//
//  Created by Алкександр Степанов on 04.09.2025.
//

import SwiftUI

struct StartLevel: View {
    @AppStorage("levelNumber") var levelNumber = 1
    @Binding var startLevelPresented: Bool
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            Image(.startLevelFrame)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth*0.4)
            Text("LEVEL \(levelNumber)")
                .foregroundStyle(Color.white)
                .font(.system(size: screenWidth*0.03, weight: .bold))
                .offset(y: -screenWidth*0.145)
            HStack {
                HStack(alignment: .bottom) {
                    Image(.retryButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth*0.09)
                        .onTapGesture {
                            startLevelPresented.toggle()
                        }
                    Image(.startButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth*0.11)
                        .onTapGesture {
                            NavGuard.shared.currentScreen = .GAME
                        }
                    Image(.crossButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth*0.09)
                        .onTapGesture {
                            NavGuard.shared.currentScreen = .MENU
                        }
                }
                .offset(y: screenWidth*0.13)
            }
        }
    }
}

#Preview {
    StartLevel(startLevelPresented: .constant(true))
}
