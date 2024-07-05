//
//  SwiftUICryptoApp.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 05.07.2024.
//

import SwiftUI

@main
struct SwiftUICryptoApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    HomeView()
                        .toolbar(.hidden)
                }
            } else {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
            }
        }
    }
}
