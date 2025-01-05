//
//  XMarkButton.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 15.12.2024.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        Button {
            if #available(iOS 16.0, *) {
                self.dismiss()
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .tint(.accent)
        }
    }
}

#Preview {
    XMarkButton()
}
