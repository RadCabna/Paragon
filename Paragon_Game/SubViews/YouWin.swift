//
//  YouWin.swift
//  Paragon_Game
//
//  Created by Алкександр Степанов on 30.08.2025.
//

import SwiftUI

struct YouWin: View {
    @AppStorage("levelNumber") var levelNumber = 1
    @AppStorage("count") var count = 0
    @State private var levelsData = UserDefaults.standard.array(forKey: "levelsData") as? [Int] ?? [1,0,0,0,0,0,0,0,0]
    var body: some View {
        ZStack {
            Image(.winFrame)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth*0.45)
            HStack(alignment: .bottom) {
                Image(.retryButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.07)
                    .onTapGesture {
                        updateLevels()
                        NavGuard.shared.currentScreen = .LEVELS
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                            NavGuard.shared.currentScreen = .GAME
                        }
                    }
                Image(.nextButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.09)
                    .onTapGesture {
                        updateLevels()
                        levelNumber += 1
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
                        updateLevels()
                        NavGuard.shared.currentScreen = .MENU
                    }
            }
            .offset(y: screenWidth*0.095)
            Text("LEVEL \(levelNumber)")
                .font(.system(size: screenWidth*0.02, weight: .bold))
                .foregroundStyle(.white)
                .offset(y: -screenWidth*0.15)
        }
    }
    
    func updateLevels() {
        count += 50
        levelsData[levelNumber] = 1
        UserDefaults.standard.set(levelsData, forKey: "levelsData")
    }
    
}

#Preview {
    YouWin()
}
