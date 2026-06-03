//
//  ProfileView.swift
//  LandBattle
//
//  Created by Dev Mistry on 5/4/26.
//

import SwiftUI

struct ProfileView: View {
    var gameVM: GameViewModel

    @State private var selectedPlayerID: UUID?

    var body: some View {
        VStack(spacing: 20) {

            Picker("Player", selection: $selectedPlayerID) {
                ForEach(gameVM.players) { player in
                    Text(player.name).tag(Optional(player.id))
                }
            }
            .pickerStyle(.segmented)

            Circle()
                .fill(gameVM.colorForPlayer(selectedPlayer.id))
                .frame(width: 100, height: 100)
                .overlay(
                    Text(String(selectedPlayer.name))
                        .font(.largeTitle)
                        .foregroundColor(.white)
                )

            Text(selectedPlayer.name)
                .font(.title)
                .fontWeight(.bold)

            Text("Rookie Commander")
                .font(.subheadline)
                .foregroundColor(.gray)

            VStack(spacing: 12) {
                HStack {
                    Text("Territories Owned")
                    Spacer()
                    Text("\(ownedTerritories)")
                        .fontWeight(.semibold)
                }

                HStack {
                    Text("Total Territories")
                    Spacer()
                    Text("\(totalTerritories)")
                        .fontWeight(.semibold)
                }

                HStack {
                    Text("Alliances")
                    Spacer()
                    Text("\(allianceCount)")
                        .fontWeight(.semibold)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            Spacer()
        }
        .padding()
        .onAppear {
            selectedPlayerID = gameVM.currentPlayer.id
        }
    }

    var selectedPlayer: Player {
        gameVM.players.first { $0.id == selectedPlayerID } ?? gameVM.currentPlayer
    }

    var ownedTerritories: Int {
        gameVM.territories.filter { $0.ownerID == selectedPlayer.id }.count
    }

    var totalTerritories: Int {
        gameVM.territories.count
    }

    var allianceCount: Int {
        gameVM.alliances.count
    }
}
