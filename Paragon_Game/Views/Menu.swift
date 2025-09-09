//
//  Menu.swift
//  Paragon_Game
//
//  Created by Алкександр Степанов on 30.08.2025.
//

import SwiftUI

struct Menu: View {
    @State private var offsetArray: [CGFloat] = [0.5,0.5,0.5,0.5]
    @State private var elementsOpacity: CGFloat = 0
    @State private var dailyPresented = false
    @State private var achievementsPresented = false
    @State private var shopPresented = false
    @State private var settingsPresented = false
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width
            let isLandscape = width > height
            if isLandscape {
                ZStack {
                    Backgrounds(backgroundNumber: 1)
                    Group {
                        Image(.gameLogo)
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight*0.1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                            .padding(screenWidth*0.01)
                        Image(.taskButton)
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth*0.1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                            .padding(screenWidth*0.01)
                            .onTapGesture {
                                dailyPresented = true
                            }
                        Image(.menuFrame)
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth*0.5)
                        VStack {
                            Image(.plyButton)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.35)
                                .offset(x: screenWidth*offsetArray[0])
                                .onTapGesture {
                                    NavGuard.shared.currentScreen = .LEVELS
                                }
                            Image(.shopButton)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.35)
                                .offset(x: screenWidth*offsetArray[1])
                                .onTapGesture {
                                    shopPresented.toggle()
                                }
                            Image(.achievementsButton)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.35)
                                .offset(x: screenWidth*offsetArray[2])
                                .onTapGesture {
                                    achievementsPresented.toggle()
                                }
                            Image(.settingsButton)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.35)
                                .offset(x: screenWidth*offsetArray[3])
                                .onTapGesture {
                                    settingsPresented.toggle()
                                }
                        }
                        .mask(
                            Rectangle()
                                .frame(width: screenWidth*0.47, height: screenWidth*0.3)
                        )
                        .offset(y: screenWidth*0.02)
                    }
                    .opacity(elementsOpacity)
                    if dailyPresented {
                        DailyTask(dailyPresented: $dailyPresented)
                    }
                    if shopPresented {
                        Shop(shopPresented: $shopPresented)
                    }
                    if achievementsPresented {
                        Achievements(achievementsPresented: $achievementsPresented)
                    }
                    if settingsPresented {
                        Settings(settingsPresented: $settingsPresented)
                    }
                }
//                .ignoresSafeArea()
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            } else {
                
            }
        }
        
        .onAppear {
            animation()
            SoundManager.instance.playSound(sound: "musicParagon", loop: true)
        }
        
    }
    
    func animation() {
        withAnimation(Animation.easeInOut(duration: 0.6)) {
            elementsOpacity = 1
        }
        var delay: Double = 0.4
        for i in 0..<offsetArray.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(Animation.easeInOut(duration: 0.6)) {
                    offsetArray[i] = 0
                }
            }
            delay += 0.1
        }
    }
    
}

#Preview {
    Menu()
}
