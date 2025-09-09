//
//  Levels.swift
//  Paragon_Game
//
//  Created by Алкександр Степанов on 04.09.2025.
//

import SwiftUI

struct Levels: View {
    @AppStorage("levelNumber") var levelNumber = 1
    @AppStorage("count") var count = 0
    @State private var startLevelPresented = false
    @State private var levelsData = UserDefaults.standard.array(forKey: "levelsData") as? [Int] ?? [1,0,0,0,0,0,0,0,0]
    let offsetArray: [CGFloat] = [-0.08,0.08,-0.08,0.08,-0.08,0.08,-0.08,0.08,-0.08,]
    var body: some View {
        ZStack {
            Backgrounds(backgroundNumber: 1)
            HStack {
                Image(.restartButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.08)
                Spacer()
                Image(.countFrame)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.25)
                    .overlay(
                        Text("\(count)")
                            .font(.system(size: screenWidth*0.04, weight: .medium))
                            .foregroundStyle(Color.white)
                            .offset(x: -screenWidth*0.02)
                    )
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, screenWidth*0.02)
            .padding(.top)
            HStack(spacing: 0) {
                ForEach(0..<levelsData.count, id: \.self) { item in
                    if levelsData[item] == 1 {
                        Image(.openLevel)
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth*0.095)
                            .overlay(
                                Text("\(item + 1)")
                                    .foregroundStyle(Color.white)
                                    .font(.system(size: screenWidth*0.035, weight: .bold))
                            )
                            .offset(y: screenWidth*offsetArray[item])
                            .onTapGesture {
                                levelNumber = item + 1
                                startLevelPresented.toggle()
                            }
                    } else {
                        Image(.closeLevel)
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth*0.095)
                            .overlay(
                                Text("\(item + 1)")
                                    .foregroundStyle(Color.white)
                                    .font(.system(size: screenWidth*0.035, weight: .bold))
                            )
                            .offset(y: screenWidth*offsetArray[item])
                    }
                }
            }
            .offset(y: screenWidth*0.03)
            HStack(spacing: 0) {
                ForEach(0..<8, id: \.self) { item in
                if item%2 == 0 {
                    Image(.arrowdown)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth*0.1)
                } else {
                    Image(.arrowUp)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth*0.1)
                }
                }
            }
            .offset(y: screenWidth*0.03)
            if startLevelPresented {
                StartLevel(startLevelPresented: $startLevelPresented)
            }
        }
    }
}

#Preview {
    Levels()
}
