//
//  Achievements.swift
//  Paragon_Game
//
//  Created by Алкександр Степанов on 06.09.2025.
//

import SwiftUI

struct Achievements: View {
    @AppStorage("count") var count = 0
    @State private var achievementsData = UserDefaults.standard.array(forKey: "achievementsData") as? [Int] ?? [1,0,0,0,0]
    @State private var achievementsImageArray = Arrays.achievementsImageArray
    @Binding var achievementsPresented: Bool
    var body: some View {
        ZStack {
            Backgrounds(backgroundNumber: 2)
            Image(.achievementsFrame)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth*0.3)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, screenWidth*0.04)
            HStack {
                Image(.restartButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.08)
                    .onTapGesture {
                        achievementsPresented.toggle()
                    }
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
            .padding(.top, screenWidth*0.02)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: screenWidth*0.01) {
                    ForEach(0..<achievementsData.count, id: \.self) { item in
                        ZStack {
                            Image(.skinFrame)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.28)
                            if achievementsData[item] == 0 {
                                Image(achievementsImageArray[item].off)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: screenWidth*0.2, maxHeight: screenWidth*0.23)
                            }
                            if achievementsData[item] == 1 {
                                Image(achievementsImageArray[item].on)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: screenWidth*0.2, maxHeight: screenWidth*0.23)
                                Image(.shopActionButton)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screenWidth*0.17)
                                    .overlay(
                                        Text("Get")
                                            .font(.system(size: screenWidth*0.025, weight: .medium))
                                            .foregroundStyle(Color.white)
                                    )
                                    .offset(y: screenWidth*0.1)
                                    .onTapGesture {
                                        getAchieve(item: item)
                                    }
                                Image(.achievementsCost)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screenWidth*0.08)
                                    .offset(x: screenWidth*0.08, y: screenWidth*0.1)
                            }
                            if achievementsData[item] == 2 {
                                Image(achievementsImageArray[item].on)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: screenWidth*0.2, maxHeight: screenWidth*0.23)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .offset(y: screenWidth*0.05)
        }
    }
    
    func getAchieve(item: Int) {
        if achievementsData[item] == 1 {
            count += 10
            achievementsData[item] = 2
            UserDefaults.standard.set(achievementsData, forKey: "achievementsData")
        }
    }
    
}

#Preview {
    Achievements(achievementsPresented: .constant(true))
}
