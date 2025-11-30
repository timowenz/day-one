//
//  ContentView.swift
//  DayOne
//
//  Created by Timo Wenz on 08.11.25.
//

import SwiftData
import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Habits", systemImage: "repeat")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
