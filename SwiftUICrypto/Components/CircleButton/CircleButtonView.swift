//
//  CircleButtonView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 05.07.2024.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundStyle(.myBackground)
            )
            .shadow(color: .accent.opacity(0.25), radius: 10, x: 0.0, y: 0.0)
            .padding()
         
    }
}

#Preview {
    Group {
        CircleButtonView(iconName: "info").previewLayout(.sizeThatFits)
        CircleButtonView(iconName: "plus").previewLayout(.sizeThatFits)
//            .preferredColorScheme(.dark)
    }
}
