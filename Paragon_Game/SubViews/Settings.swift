//
//  Settings.swift
//  Paragon_Game
//
//  Created by Алкександр Степанов on 07.09.2025.
//

import SwiftUI

struct Settings: View {
    @AppStorage("count") var count = 0
    @AppStorage("sound") var sound = false
    @AppStorage("volume") var volume: Double = 0
    @AppStorage("brightness") var brightness:Double = 0.3
    @ObservedObject var soundManager = SoundManager.instance
    @Binding var settingsPresented: Bool
    var body: some View {
        ZStack {
            Backgrounds(backgroundNumber: 1)
            HStack {
                Image(.restartButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.08)
                    .onTapGesture {
                        settingsPresented.toggle()
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
            .padding()
            Image(.settingsFrame)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth*0.5)
                .offset(y: screenWidth*0.05)
                .overlay(
                    VStack(spacing: 0) {
                        HStack {
                            Text("Sound")
                                .font(.system(size: screenWidth*0.035, weight: .medium))
                                .foregroundStyle(Color.text)
                                .offset(x: -screenWidth*0.02)
                            Spacer()
                            Image(!sound ? .buttonOn : .buttonOff)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.07)
                                .overlay(
                                    Text("Off")
                                        .font(.system(size: screenWidth*0.022, weight: .medium))
                                        .foregroundStyle(sound ? Color.text : .white)
                                )
                                .onTapGesture {
                                    sound = false
                                    SoundManager.instance.mute()
                                }
                            Image(sound ? .buttonOn : .buttonOff)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.07)
                                .overlay(
                                    Text("On")
                                        .font(.system(size: screenWidth*0.022, weight: .medium))
                                        .foregroundStyle(!sound ? Color.text : .white)
                                )
                                .onTapGesture {
                                    sound = true
                                    SoundManager.instance.unmute()
                                }
                        }
                        .frame(maxWidth: screenWidth*0.3)
                        HStack {
                            Text("Volume")
                                .font(.system(size: screenWidth*0.035, weight: .medium))
                                .foregroundStyle(Color.text)
                                .offset(x: -screenWidth*0.02)
                            Spacer()
                        }
                        .frame(maxWidth: screenWidth*0.3)
                        SmoothImageSlider(
                            value: Binding(
                                               get: { Double(soundManager.volume) },
                                               set: { soundManager.setVolume(Float($0)) }
                                           ),
                                           range: 0...1
                        )
                        HStack {
                            Text("Brigtness")
                                .font(.system(size: screenWidth*0.035, weight: .medium))
                                .foregroundStyle(Color.text)
                                .offset(x: -screenWidth*0.02)
                            Spacer()
                        }
                        .frame(maxWidth: screenWidth*0.3)
                        SmoothImageSlider(value: $brightness, range: 0...0.3)
                    }
                        .offset(y: screenWidth*0.07)
                )
        }
    }
}

#Preview {
    Settings(settingsPresented: .constant(true))
}

struct SmoothImageSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    
    @State private var isDragging = false
    @State private var dragOffset: CGFloat = 0
    
    var leftMargin: CGFloat = 0
    var rightMargin: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let imageWidth = screenWidth * 0.4
            let thumbWidth = screenWidth * 0.05
            let halfThumbWidth = thumbWidth / 2
            
            // Учитываем размер ползунка при расчете доступной области
            let availableWidth = imageWidth - leftMargin - rightMargin - thumbWidth
            
            let normalizedValue = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
            let thumbPosition = leftMargin + halfThumbWidth + CGFloat(normalizedValue) * availableWidth
            
            ZStack(alignment: .leading) {
                Image(.sliderBack)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageWidth)
                
                Image(.slider)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: thumbWidth)
                                    .shadow(radius: 3)
                                    .scaleEffect(isDragging ? 1.2 : 1.0)
                                    .offset(x: thumbPosition ) // Центрируем ползунок
                                    .animation(.easeInOut(duration: 0.1), value: isDragging)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if !isDragging {
                                    isDragging = true
                                    // Вычисляем разность между позицией пальца и центром ползунка
                                    dragOffset = gesture.location.x - thumbPosition
                                }
                                
                                // Применяем смещение для плавного движения
                                let adjustedX = gesture.location.x - dragOffset
                                
                                // Ограничиваем движение с учетом размера ползунка
                                let minX = leftMargin + halfThumbWidth
                                let maxX = leftMargin + halfThumbWidth + availableWidth - screenWidth*0.04
                                let clampedX = max(minX, min(maxX, adjustedX))
                                
                                let progress = (clampedX - minX) / availableWidth
                                let newValue = range.lowerBound + (range.upperBound - range.lowerBound) * Double(progress)
                                
                                value = max(range.lowerBound, min(range.upperBound, newValue))
                            }
                            .onEnded { _ in
                                isDragging = false
                                dragOffset = 0
                            }
                    )
            }
        }
        .frame(width: screenWidth * 0.4, height: screenWidth*0.06)
    }
}
