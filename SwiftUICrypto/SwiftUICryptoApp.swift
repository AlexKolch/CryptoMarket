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
    @State private var isShowLaunchView: Bool = true
    
    //Override navBar's color appearance
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(.accent)]
        UINavigationBar.appearance().tintColor = UIColor(Color.accent)
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
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
                ///ЭКРАН ЗАГРУЗКИ
                ZStack {
                    if isShowLaunchView {
                        LaunchView(showLaunchView: $isShowLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0) //hack поднять этот стек выше нав. стека, чтобы видеть анимацию закрывания экрана
            }
            
        }
    }
}
