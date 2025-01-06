//
//  LaunchView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 06.01.2025.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var showLoadingText: Bool = false
    @State private var loadingText: [String] = "Loading your portfolio...".map { item in
        item.description //строка становится массивом строк ["L","o","a","d" ...]
    }
    
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchView: Bool
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect() //запускается сразу после LaunchScreen
    
    var body: some View {
        ZStack {
            Color.launchBackground
                .ignoresSafeArea()
            
            Image(.logoTransparent)
                .frame(width: 100, height: 100)
            
            ZStack {
                if showLoadingText {
                    HStack(spacing: 0.5) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(.launchAccent)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(.scale.animation(.easeIn))
                }
            }
            .offset(y: 70)
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in //подписываемся на паблишер таймер и будет срабатывать кложур каждые 0.1 сек
            withAnimation(.spring) {
                let lastIndex = loadingText.count - 1
                //делаем зацикливание анимации
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 { showLaunchView = false } //экран пропадает после 2 циклов анимации
                } else {
                    counter += 1
                }
            }
        }
        
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
