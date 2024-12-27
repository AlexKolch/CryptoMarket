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
        .onChange(of: vm.searchText, perform: { value in
            if value == "" {
                removeSelectedCoin()
            }
        })
        // for ios 17 or newer
//        .onChange(of: vm.searchText) { _, newValue in
//            if newValue == "" {
//                removeSelectedCoin()
//            }
//        }
    }
}

private extension Cover {
    
     var coinLogoList: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(.vertical, 6)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                //определяем нажатую монету в списке
//                                selectedCoin = coin 
                                updatedAmountHolding(at: coin)
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
    
    ///Обновить значение inputAmount исходя из имеющегося кол-ва монет
    func updatedAmountHolding(at coin: CoinModel) {
        selectedCoin = coin
        //проверяем что монета есть в портфеле и если находим такие достаем их кол-во
        if let portfolioCoins = vm.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoins.currentCountHoldings {
            inputAmount = "\(amount)"
        } else {
            inputAmount = "" //если нету монеты то присвоим пустую строку
        }
    }
    
    func saveButtonPressed() {
        guard
            let coin = selectedCoin,
            let amount = Double(inputAmount)
        else { return } //получили данные о выбранной монете
        
        //update portfolio to CoreData
        vm.updatePortfolio(coin: coin, amount: amount)
        
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
