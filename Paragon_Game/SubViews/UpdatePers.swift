//
//  UpdatePers.swift
//  Paragon_Game
//
//  Created by Алкександр Степанов on 03.09.2025.
//

import SwiftUI

struct UpdatePers: View {
    @AppStorage("count") var count = 0
    @State private var persLevelData = UserDefaults.standard.array(forKey: "persLevelData") as? [Int] ?? [1,1]
    @State private var persInfoData = UserDefaults.standard.array(forKey: "persInfoData") as? [Int] ?? [1,2]
    @Binding var showImprove: Bool
    @Binding var persIndex: Int
    var body: some View {
        ZStack {
            Image(.updatePersPlate)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth*0.48)
            Text(whatName(item: persInfoData[persIndex]))
                .font(Font.system(size: screenWidth*0.02, weight: .bold))
                .textCase(.uppercase)
                .foregroundStyle(Color.white)
                .offset(y: -screenWidth*0.162)
            HStack {
                ZStack {
                    Image(.selectPersFrame)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth*0.2)
                    Image(whatPers(item: persInfoData[persIndex]))
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth*0.15)
                    Image(persLevelData[persIndex] == 1 ? "level1Plate" : "level2Plate")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth*0.07)
                        .overlay(
                            Text("LVL \(persLevelData[persIndex])")
                                .foregroundStyle(Color.white)
                                .font(.system(size: screenWidth*0.02, weight: .bold))
                            
                        )
                        .offset(x: -screenWidth*0.09, y: -screenWidth*0.115)
                }
//                .offset(x: -screenWidth*0.09)
                VStack {
                    HStack {
                        Image(.level1Plate)
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth*0.06)
                            .overlay(
                                Text("LVL \(persLevelData[persIndex])")
                                    .foregroundStyle(Color.white)
                                    .font(.system(size: screenWidth*0.016, weight: .bold))
                                
                            )
                        Image(.arrowBack)
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth*0.04)
                            .scaleEffect(x: -1)
                        Image(.level2Plate)
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth*0.06)
                            .overlay(
                                Text("LVL \(persLevelData[persIndex]+1)")
                                    .foregroundStyle(Color.white)
                                    .font(.system(size: screenWidth*0.016, weight: .bold))
                                
                            )
                    }
                    HStack {
                        Text("Radius")
                            .foregroundStyle(Color.white)
                            .font(.system(size: screenWidth*0.016, weight: .bold))
                        Spacer()
                        ZStack {
                            Image(.persButton)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.12)
                                .overlay(
                                    HStack {
                                        Text("+1")
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: screenWidth*0.016, weight: .bold))
                                        Spacer()
                                        Text("80")
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: screenWidth*0.016, weight: .bold))
                                    }
                                        .padding(.horizontal)
                                )
                            
                            Image(.star)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.045)
                                .offset(x: screenWidth*0.06)
                        }
                        .onTapGesture {
                            makeUpdate(cost: 80)
                        }
                    }
                    .frame(maxWidth: screenWidth*0.195)
                    HStack {
                        Text("Damage")
                            .foregroundStyle(Color.white)
                            .font(.system(size: screenWidth*0.016, weight: .bold))
                        Spacer()
                        ZStack {
                            Image(.persButton)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.12)
                                .overlay(
                                    HStack {
                                        Text("+4")
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: screenWidth*0.016, weight: .bold))
                                        Spacer()
                                        Text("40")
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: screenWidth*0.016, weight: .bold))
                                    }
                                        .padding(.horizontal)
                                )
                            
                            Image(.star)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.045)
                                .offset(x: screenWidth*0.06)
                        }
                        .onTapGesture {
                            makeUpdate(cost: 40)
                        }
                    }
                    .frame(maxWidth: screenWidth*0.195)
                    HStack {
                        Text("HP")
                            .foregroundStyle(Color.white)
                            .font(.system(size: screenWidth*0.016, weight: .bold))
                        Spacer()
                        ZStack {
                            Image(.persButton)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.12)
                                .overlay(
                                    HStack {
                                        Text("+15")
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: screenWidth*0.016, weight: .bold))
                                        Spacer()
                                        Text("60")
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: screenWidth*0.016, weight: .bold))
                                    }
                                        .padding(.horizontal)
                                )
                            
                            Image(.star)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.045)
                                .offset(x: screenWidth*0.06)
                        }
                        .onTapGesture {
                            makeUpdate(cost: 60)
                        }
                    }
                    .frame(maxWidth: screenWidth*0.195)
                }
            }
            Image(.crossButton)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth*0.07)
                .offset(x: screenWidth*0.24, y: -screenWidth*0.15)
                .onTapGesture {
                    showImprove.toggle()
                }
        }
    }
    
    func makeUpdate(cost: Int) {
        if count >= cost {
            count -= cost
            persLevelData[persIndex] += 1
            UserDefaults.standard.set(persLevelData, forKey: "persLevelData")
        }
    }
    
    func whatPers(item: Int) -> String {
        switch item {
        case 1:
            return "yourWarrior"
        case 2:
            return "yourArcher"
        case 3:
            return "yourWarrior_2"
        case 4:
            return "yourArcher_2"
        case 5:
            return "yourArcher_3"
        default:
            return ""
        }
    }
    
    func whatName(item: Int) -> String {
        switch item {
        case 1:
            return "Warrior"
        case 2:
            return "Archer"
        case 3:
            return "rWarrior"
        case 4:
            return "Archer"
        case 5:
            return "Archer"
        default:
            return ""
        }
    }
    
}

#Preview {
    UpdatePers(showImprove: .constant(true), persIndex: .constant(0))
}
