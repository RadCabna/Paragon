//
//  DailyTask.swift
//  Paragon_Game
//
//  Created by Алкександр Степанов on 04.09.2025.
//

import SwiftUI

struct DailyTask: View {
    @Binding var dailyPresented: Bool
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            Image(.dailyTaskFrame)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth*0.45)
            Image(.crossButton)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth*0.07)
                .offset(x: screenWidth*0.21, y: -screenWidth*0.13)
                .onTapGesture {
                    dailyPresented.toggle()
                }
        }
    }
}

#Preview {
    DailyTask(dailyPresented: .constant(true))
}
