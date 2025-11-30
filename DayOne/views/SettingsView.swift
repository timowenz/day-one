//
//  SettingsView.swift
//  DayOne
//
//  Created by Timo Wenz on 17.11.25.
//

import SwiftUI
import SwiftData
import Foundation

struct SettingsView: View {
    @State private var showAboutScreen = false
    private var appVersion: String {
           let dict = Bundle.main.infoDictionary
           let version = dict?["CFBundleShortVersionString"] as? String ?? "Unknown"
           return version
       }
    
    private var buildVersion: String {
        let dict = Bundle.main.infoDictionary
        let build = dict?["CFBundleVersion"] as? String ?? "Unknown"
        return "(\(build))"
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        showAboutScreen = true
                    } label: {
                        Label("About", systemImage: "info.circle")
                    }
                } footer: {

                    
                    Text("Version: \(appVersion)\nBuild: \(buildVersion)")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)
                        
                }
            }
            .navigationTitle("Settings")
            .alert("About", isPresented: $showAboutScreen) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Publisher: Timo Wenz\nVersion: \(appVersion)\nBuild: \(buildVersion)")
                    .multilineTextAlignment(.center)
            }
        }
    }
}
