//
//  SettingsView.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 05.01.2025.
//

import SwiftUI

struct SettingsView: View {
    
    private enum LinksURL: String {
        case defaultLink = "https://www.google.com"
        case coingecko = "https://www.coingecko.com"
        case personal = "https://github.com/AlexKolch"
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                List {
                    aboutAppSection
                    coinGeckoSection
                    developerSection
                    appSection
                }
                .modifier(NavSettingsModifier())
                .listStyle(.grouped)
                .tint(.blue)
                .font(.headline)
            }
        } else {
            NavigationView {
                List {
                    aboutAppSection
                    coinGeckoSection
                    developerSection
                    appSection
                }
                .modifier(NavSettingsModifier())
                .listStyle(.grouped)
                .tint(.blue)
                .font(.headline)
            }
        }
    }
}

#Preview {
    SettingsView()
}

private extension SettingsView {
    
    var aboutAppSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image(.logo)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(.rect(cornerRadius: 20))
                Text("This application was created to monitor the cryptocurrency exchange rate.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(.accent)
            }
            .padding(.vertical, 2)
        } header: {
            Text("About app")
        }
    }
    
    var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image(.coingecko)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(.rect(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(.accent)
            }
            .padding(.vertical, 2)
            Link("Visit CoinGecko 🦎", destination: URL(string: LinksURL.coingecko.rawValue)!)
        } header: {
            Text("CoinGecko")
        }
    }
    
    var developerSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image(.developer)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(.rect(cornerRadius: 20))
                Text("This app was developed by Alexey Kolychenkov. It uses SwiftUI and is written in Swift. The project built on MVVM Architecture and benefits from multi-threading via API Combine and data saved with CoreData")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(.accent)
            }
            .padding(.vertical, 2)
            Link("Visit on GitHub 🤙", destination: URL(string: LinksURL.personal.rawValue)!)
        } header: {
            Text("Developer")
        }
    }
    
    var appSection: some View {
        Section {
            Link("Terms of Service", destination: URL(string: LinksURL.defaultLink.rawValue)!)
            Link("Privacy Policy", destination: URL(string: LinksURL.defaultLink.rawValue)!)
            Link("Company Website", destination: URL(string: LinksURL.defaultLink.rawValue)!)
            Link("Learn More", destination: URL(string: LinksURL.defaultLink.rawValue)!)
        } header: {
            Text("Info")
        }
    }
}

struct NavSettingsModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .navigationTitle("Settings")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
            })
    }
}
