//
//  CoinImageView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 13.07.2024.
//

import SwiftUI

struct CoinImageView: View {
    
    @StateObject var vm: CoinImageViewModel
    
    init(coin: Coin) {
        self._vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundStyle(.secondaryText)
            }
        }
    }
}

#Preview {
    CoinImageView(coin: MocPreview.coin).padding()
}
