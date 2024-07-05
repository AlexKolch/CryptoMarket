//
//  HomeView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 05.07.2024.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio = false

    var body: some View {
        ZStack {
            Color.myBackground
                .ignoresSafeArea()
            ///content layer
            VStack {
              homeHeader
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }
}

private extension HomeView {
    
    var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .transaction { transaction in
                    transaction.animation = nil
                }
                .background {
                    AnimateCircleView(isAnimate: $showPortfolio)
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Current prices")
                .font(.headline).fontWeight(.heavy).foregroundStyle(.accent)
                .transaction { transaction in
                    transaction.animation = nil
                }
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
}
