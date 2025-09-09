//
//  SelectPers.swift
//  Paragon_Game
//
//  Created by Алкександр Степанов on 03.09.2025.
//

import SwiftUI

struct SelectPers: View {
    @State private var persLevelData = UserDefaults.standard.array(forKey: "persLevelData") as? [Int] ?? [1,1]
    @State private var persInfoData = UserDefaults.standard.array(forKey: "persInfoData") as? [Int] ?? [1,2]
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: screenWidth*0.04) {
                    Spacer()
                    ForEach(0..<persInfoData.count, id: \.self) { item in
                        ZStack {
                            Image(.selectPersFrame)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.2)
                        Image(whatPers(item: persInfoData[item]))
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.15)
                            Image(persLevelData[item] == 1 ? "level1Plate" : "level2Plate")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.07)
                                .overlay(
                                    Text("LVL \(persLevelData[item])")
                                        .foregroundStyle(Color.white)
                                        .font(.system(size: screenWidth*0.02, weight: .bold))
                                        
                                )
                                .offset(x: -screenWidth*0.09, y: -screenWidth*0.115)
                            Image(.persButton)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.15)
                                .overlay(
                                    Text("Improve")
                                        .foregroundStyle(Color.white)
                                        .font(.system(size: screenWidth*0.02, weight: .bold))
                                )
                                .offset(y: screenWidth*0.1)
                        }
                    }
                }
                .padding(.leading, persInfoData.count == 2 ? screenWidth*0.17 : persInfoData.count == 3 ? screenWidth*0.045 : 0 )
                .padding(.trailing, screenWidth*0.05)
                .padding(.vertical)
            }
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
    
}

#Preview {
    SelectPers()
}
