//
//  CircleBtnAnimateView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 05.07.2024.
//Анимированный круг при появлении

import SwiftUI

struct AnimateCircleView: View {
    
    @Binding var isAnimate: Bool
    
    var body: some View {
       Circle()
            .stroke(lineWidth: 5.0)
            .scale(isAnimate ? 1.0 : 0.0)
            .opacity(isAnimate ? 0.0 : 1.0)
            .animation(isAnimate ? .easeOut(duration: 1.0).delay(-0.3) : .none,
                       value: isAnimate)
//            .onAppear {
//                isAnimate.toggle() //для тестового просмотра
//            }
    }
}

#Preview {
    AnimateCircleView(isAnimate: .constant(true))
        .foregroundStyle(.red)
        .frame(width: 100, height: 100)
}
