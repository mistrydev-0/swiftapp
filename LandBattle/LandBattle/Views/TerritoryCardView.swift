//
//  TerritoryCardView.swift
//  LandBattle
//
//  Created by Dev Mistry on 4/24/26.
//

import SwiftUI

struct TerritoryCardView: View {
    let territory: Territory
    let ownerName: String
    let playerVisitCount: Int
    let players: [Player]
    let onVisit: (Player) -> Void
    let onLeave: (Player) -> Void
    let allianceBonus: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(territory.name)
                .font(.title3)
                .fontWeight(.bold)

            Text("Owner: \(ownerName)")
                .font(.subheadline)

            Text("Strength: \(territory.strength)")
                .font(.subheadline)
            
            Text("Alliance Bonus: +\(allianceBonus)")
                .font(.subheadline)
            
            Text("Total Defense: \(territory.strength + allianceBonus)")
                .font(.subheadline)
                .fontWeight(.semibold)

            Text("Radius: \(Int(territory.radius)) meters")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Your Visits: \(playerVisitCount)")
                .font(.caption)

            HStack(spacing: 10) {
                ForEach(players) { player in
                    Button(shortName(for: player)) {
                        onVisit(player)
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            HStack(spacing: 10) {
                ForEach(players) { player in
                    Button(shortName(for: player)) {
                        onLeave(player)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 4)
    }

    private func shortName(for player: Player) -> String {
        switch player.name {
        case "Friend1":
            return "F1"
        case "Friend2":
            return "F2"
        case "Friend3":
            return "F3"
        case "Friend4":
            return "F4"
        default:
            return player.name
        }
    }
}
