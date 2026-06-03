//
//  AllianceView.swift
//  LandBattle
//
//  Created by Dev Mistry on 4/28/26.
//

import SwiftUI

struct AllianceView: View {
    @Bindable var gameVM: GameViewModel

    var body: some View {
        NavigationStack {
            List {
                Section("Players") {
                    ForEach(gameVM.players) { player in
                        if player.id != gameVM.currentPlayer.id {
                            Button {
                                if gameVM.isAlliedWithDev(player) {
                                    gameVM.removePlayerFromDevAlliance(player)
                                } else {
                                    gameVM.addPlayerToDevAlliance(player)
                                }
                            } label: {
                                HStack {
                                    Circle()
                                        .fill(player.color)
                                        .frame(width: 14, height: 14)

                                    Text(player.name)

                                    Spacer()

                                    if gameVM.isAlliedWithDev(player) {
                                        Text("Allied")
                                            .font(.caption)
                                            .foregroundStyle(.green)
                                    } else {
                                        Text("Tap to ally")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }

                Section("Dev Alliance") {
                    let allianceCount = gameVM.alliances.first?.memberIDs.count ?? 1
                    Text("Max Bonus: +\(max(allianceCount - 1, 0))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Alliances")
        }
    }
}
