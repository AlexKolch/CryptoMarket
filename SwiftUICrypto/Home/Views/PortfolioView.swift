//
//  PortfolioView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 15.12.2024.
//

import SwiftUI

struct PortfolioView: View {
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
              Cover()
            }
        } else {
            NavigationView {
             Cover()
            }
        }
    }
    
}

struct Cover: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var inputAmount: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                SearchBarView(searchText: $vm.searchText)
                coinLogoList
                
                if selectedCoin != nil {
                  portfolioInputSection
                }
            }
        }
        .navigationTitle("Edit Portfolio")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                XMarkButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                 saveButton
            }
        }
    }
}

private extension Cover {
    
     var coinLogoList: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(.vertical, 6)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin //при нажатии на монету присваиваем ее в переменную состояния
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                            //если id нажатой монеты совпадает, сделать ей рамку
                                .stroke(selectedCoin?.id == coin.id ? .myGreen : .clear, lineWidth: 1)
                        }
                }
            }
            .offset(x: 8)
            .padding(.vertical, 4)
        }
    }
    
    var portfolioInputSection: some View {
        VStack(spacing: 20.0) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $inputAmount)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none, value: selectedCoin)
        .padding()
        .font(.headline)
    }
    
    ///toolbar Btn
    var saveButton: some View {
        Button("Save".uppercased()) {
            saveButtonPressed()
        }
        .font(.headline)
        .opacity((selectedCoin != nil && selectedCoin?.currentCountHoldings != Double(inputAmount)) ?
                 1.0 : 0.0
        )
        .overlay(alignment: .center) {
            Image(systemName: "checkmark").opacity(showCheckmark ? 1.0 : 0.0)
                .foregroundStyle(.accent)
        }
    }
    
    func getCurrentValue() -> Double {
        let value: Double
        if let quantity = Double(inputAmount) {
            value = (selectedCoin?.currentPrice ?? 0) * quantity
        } else {
            value = 0
        }
        return value
    }
    
    func saveButtonPressed() {
        guard let selectedCoin else { return }
        /*
         here will be code save to portfolio
         */
        
        //show checkmark
        withAnimation(.easeIn) {
            removeSelectedCoin()
            withAnimation(.easeIn.delay(0.8)) {
                showCheckmark = true
            }
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
    
    func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
        inputAmount = ""
    }
}

#Preview {
    PortfolioView()
        .environmentObject(HomeViewModel())
}
