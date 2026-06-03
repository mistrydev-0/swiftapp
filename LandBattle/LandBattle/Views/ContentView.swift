//
//  ContentView.swift
//  LandBattle
//
//  Created by Dev Mistry on 4/13/26.
//

import SwiftUI

struct ContentView: View {
    @State private var gameVM = GameViewModel()

    var body: some View {
        TabView {
            MapScreen(gameVM: gameVM)
                .tabItem {
                    Label("Map", systemImage: "map")
                }

            AllianceView(gameVM: gameVM)
                .tabItem {
                    Label("Alliances", systemImage: "person.3.fill")
                }

            ProfileView(gameVM: gameVM)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}
#Preview {
    ContentView()
}
