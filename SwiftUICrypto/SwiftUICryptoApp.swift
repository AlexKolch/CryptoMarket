//
//  SwiftUICryptoApp.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 05.07.2024.
//

import SwiftUI

@main
struct SwiftUICryptoApp: App {
    
    @StateObject private var vm = HomeViewModel() //общий источник данных для всех дочерних вью
    
    //Override navBar's color appearance
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    HomeView()
                        .toolbar(.hidden)
                }.environmentObject(vm)
            } else {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }.environmentObject(vm)
            }
        }
    }
}
