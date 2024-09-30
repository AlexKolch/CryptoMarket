//
//  SearchBarView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 30.09.2024.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ? .secondaryText : .accent
                )
            
            TextField("Search by name or symbol...", text: $searchText)
                .autocorrectionDisabled(true)
                .foregroundStyle(.accent)
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10.0)
                        .foregroundStyle(.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing() //скрывает клавиатуру
                            searchText = ""
                        }
                }
        }
        .font(.headline)
        .padding()
        .background(
        RoundedRectangle(cornerRadius: 25.0)
            .fill(.myBackground)
            .shadow(color: .secondaryText, radius: 10)
            .opacity(0.20)
        ).padding()
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
