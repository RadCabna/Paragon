//
//  Shop.swift
//  Paragon_Game
//
//  Created by Алкександр Степанов on 02.09.2025.
//

import SwiftUI

struct Shop: View {
    @AppStorage("count") var count = 0
    @AppStorage("bgNumber") var bgNumber = 2
    @State private var shopGroupNumber: Int = 1
    @State private var shopWarrior = Arrays.shopWarrior
    @State private var shopBackgrounds = Arrays.shopBackgrounds
    @State private var shopWarriorData = UserDefaults.standard.array(forKey: "shopWarriorData") as? [Int] ?? [0,0,0]
    @State private var shopBackgroundsData = UserDefaults.standard.array(forKey: "shopBackgroundsData") as? [Int] ?? [0,0,0]
    @State private var persLevelData = UserDefaults.standard.array(forKey: "persLevelData") as? [Int] ?? [1,1]
    @State private var persInfoData = UserDefaults.standard.array(forKey: "persInfoData") as? [Int] ?? [1,2]
    @Binding var shopPresented: Bool
    var body: some View {
        ZStack {
            Backgrounds(backgroundNumber: 1)
            Image(.shopPlate)
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
                        shopPresented.toggle()
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
                    .onTapGesture {
                        count += 100
                        UserDefaults.standard.removeObject(forKey: "shopWarriorData")
                        UserDefaults.standard.removeObject(forKey: "shopBackgroundsData")
                        UserDefaults.standard.removeObject(forKey: "persLevelData")
                        UserDefaults.standard.removeObject(forKey: "persInfoData")
                    }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, screenWidth*0.01)
            .padding(.top)
            HStack {
                Image(shopGroupNumber == 1 ? .mapsPlateOn : .mapsPlateOff)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.17)
                    .onTapGesture {
                        shopGroupNumber = 1
                    }
                Image(shopGroupNumber == 2 ? .hirePlateOn : .hirePlateOff)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.17)
                    .onTapGesture {
                        shopGroupNumber = 2
                    }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, screenWidth*0.1)
            if shopGroupNumber == 2 {
                HStack(spacing: screenWidth*0.03) {
                    ForEach(0..<shopWarriorData.count, id: \.self) { item in
                        ZStack {
                            Image(.skinFrame)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.25)
                            Image(shopWarrior[item])
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.12)
                            if shopWarriorData[item] == 0 {
                                Image(.shopCost)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screenWidth*0.08)
                                    .offset(x: -screenWidth*0.09, y: -screenWidth*0.08)
                            }
                            Image(.shopActionButton)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.15)
                                .overlay(
                                    Text(shopWarriorData[item] == 0 ? "Buy" : "Hired")
                                        .font(.system(size: screenWidth*0.02, weight: .medium))
                                        .foregroundStyle(Color.white)
                                )
                                .offset(y: screenWidth*0.09)
                        }
                        .onTapGesture {
                            hireWarrior(item: item)
                        }
                    }
                }
                .offset(y: screenWidth*0.08)
            }
            if shopGroupNumber == 1 {
                HStack(spacing: screenWidth*0.03) {
                    ForEach(0..<shopBackgroundsData.count, id: \.self) { item in
                        ZStack {
                            Image(shopBackgrounds[item])
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.22)
                            Image(.shopCost)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.08)
                                .offset(x: -screenWidth*0.09, y: -screenWidth*0.1)
                            if shopBackgroundsData[item] == 0 {
                                Image(.shopActionButton)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screenWidth*0.15)
                                    .overlay(
                                        Text("Buy")
                                            .font(.system(size: screenWidth*0.02, weight: .medium))
                                            .foregroundStyle(Color.white)
                                    )
                                    .offset(y: screenWidth*0.12)
                                    .onTapGesture {
                                        buyBackground(item: item)
                                    }
                            }
                            if shopBackgroundsData[item] == 1 {
                                Image(.shopActionButton)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screenWidth*0.15)
                                    .overlay(
                                        Text("Select")
                                            .font(.system(size: screenWidth*0.02, weight: .medium))
                                            .foregroundStyle(Color.white)
                                    )
                                    .offset(y: screenWidth*0.12)
                                    .onTapGesture {
                                        selectBackground(item: item)
                                    }
                            }
                            if shopBackgroundsData[item] == 2 {
                                Image(.shopActionButton)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screenWidth*0.15)
                                    .overlay(
                                        Text("Selected")
                                            .font(.system(size: screenWidth*0.02, weight: .medium))
                                            .foregroundStyle(Color.white)
                                    )
                                    .offset(y: screenWidth*0.12)
                            }
                        }
                    }
                }
                .offset(y: screenWidth*0.08)
            }
        }
    }
    
    func buyBackground(item: Int) {
        if count >= 100 && shopBackgroundsData[item] == 0 {
            count -= 100
            shopBackgroundsData[item] = 1
            UserDefaults.standard.set(shopBackgroundsData, forKey: "shopBackgroundsData")
        }
    }
    
    func selectBackground(item: Int) {
        if shopBackgroundsData[item] == 1 {
            for i in 0..<shopBackgroundsData.count {
                if shopBackgroundsData[i] == 2 {
                    shopBackgroundsData[i] = 1
                }
            }
            shopBackgroundsData[item] = 2
            UserDefaults.standard.set(shopBackgroundsData, forKey: "shopBackgroundsData")
            bgNumber = item+3
        }
    }
    
    func hireWarrior(item: Int) {
        if shopWarriorData[item] == 0 && count >= 100 {
            count -= 100
            shopWarriorData[item] = 1
            persInfoData.append(whatWarrior(item: item))
            persLevelData.append(1)
            UserDefaults.standard.set(shopWarriorData, forKey: "shopWarriorData")
            UserDefaults.standard.set(persInfoData, forKey: "persInfoData")
            UserDefaults.standard.set(persLevelData, forKey: "persLevelData")
        }
    }
    
//    "yourWarrior_2",
//    "yourArcher_2",
//    "yourArcher_3"
    
    func whatWarrior(item: Int) -> Int {
        let name = shopWarrior[item]
        switch name {
        case "yourWarrior_2":
            return 3
        case "yourArcher_2":
            return 4
        default:
            return 5
        }
    }
}

#Preview {
    Shop(shopPresented: .constant(true))
}
