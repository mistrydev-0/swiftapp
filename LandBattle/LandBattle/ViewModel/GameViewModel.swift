//
//  GameViewModel.swift
//  LandBattle
//
//  Created by Dev Mistry on 4/16/26.
//

import SwiftUI
import CoreLocation

@Observable
final class GameViewModel {
    
    var messagePlayerID: UUID?
    
    func colorForPlayer(_ id: UUID?) -> Color {
        guard let id else { return .green }

        if id == currentPlayer.id { return .blue }

        if let player = players.first(where: { $0.id == id }) {
            switch player.name {
            case "om": return .green
            case "khush": return .orange
            case "arya": return .purple
            case "shiv": return .pink
            default: return .gray
            }
        }

        return .gray
    }
    
    let currentPlayer = Player(
        id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
        name: "Dev",
        color: .blue
    )

    let om = Player(
        id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
        name: "om",
        color: .red
    )

    let khush = Player(
        id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
        name: "khush",
        color: .green
    )

    let arya = Player(
        id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
        name: "arya",
        color: .orange
    )
    
    let shiv = Player(
        id: UUID(uuidString: "55555555-5555-5555-5555-555555555555")!,
        name: "shiv",
        color: .pink
    )
    
    
    var players: [Player] {
        [om, khush, arya, shiv, currentPlayer]
    }
    
    var selectedTerritory: Territory?
    var capturedMessage: String?

    var visitCounts: [String: Int] = [:]
    var playersCurrentlyInsideTerritories: Set<String> = []
    
    var alliances: [Alliance] = []
    
    var allianceStatusText: String {
        if alliances.isEmpty {
            return "No active alliances"
        } else {
            return "\(alliances.count) active alliance(s)"
        }
    }
    
    func allianceBonus(for ownerID: UUID?, territoryID: UUID) -> Int {
        guard let ownerID else { return 0 }

        guard let alliance = alliances.first(where: {
            $0.memberIDs.contains(ownerID.uuidString)
        }) else {
            return 0
        }

        let alliedPlayerIDs = alliance.memberIDs.filter { $0 != ownerID.uuidString }

        guard !alliedPlayerIDs.isEmpty else { return 0 }

        for playerIDString in alliedPlayerIDs {
            guard let playerID = UUID(uuidString: playerIDString) else { return 0 }

            let visitKey = Visit.key(playerID: playerID, territoryID: territoryID)

            if visitCounts[visitKey, default: 0] == 0 {
                return 0
            }
        }

        return alliedPlayerIDs.count
    }
    
    func isAlliedWithDev(_ player: Player) -> Bool {
        alliances.first?.memberIDs.contains(player.id.uuidString) ?? false
    }

    func addPlayerToDevAlliance(_ player: Player) {
        guard player.id != currentPlayer.id else { return }

        if alliances.isEmpty {
            alliances.append(
                Alliance(
                    name: "Dev Alliance",
                    memberIDs: [currentPlayer.id.uuidString]
                )
            )
        }

        if let index = alliances.firstIndex(where: { $0.name == "Dev Alliance" }) {
            if !alliances[index].memberIDs.contains(player.id.uuidString) {
                alliances[index].memberIDs.append(player.id.uuidString)
            }
        }
    }

    func removePlayerFromDevAlliance(_ player: Player) {
        guard let index = alliances.firstIndex(where: { $0.name == "Dev Alliance" }) else { return }

        alliances[index].memberIDs.removeAll { $0 == player.id.uuidString }
    }
    
    var territories: [Territory] = [
        Territory(
            name: "HUB Lawn",
            latitude: 40.7976,
            longitude: -77.8599,
            radius: 120,
            ownerID: nil
        ),
        Territory(
            name: "Old Main",
            latitude: 40.7966,
            longitude: -77.8628,
            radius: 100,
            ownerID: nil
        ),
        Territory(
            name: "Westgate",
            latitude: 40.7939,
            longitude: -77.8676,
            radius: 110,
            ownerID: nil
        ),
        Territory(
            name: "Beaver Stadium",
            latitude: 40.8116,
            longitude: -77.8550,
            radius: 150,
            ownerID: nil
        ),
        Territory(
            name: "Berkey Creamery",
            latitude: 40.8039,
            longitude: -77.8622,
            radius: 90,
            ownerID: nil
        )
        
    ]

    func ownerName(for territory: Territory) -> String {
        switch territory.ownerID {
        case currentPlayer.id:
            return currentPlayer.name
        case om.id:
            return om.name
        case khush.id:
            return khush.name
        case arya.id:
            return arya.name
        case shiv.id:
            return shiv.name
        default:
            return "Unclaimed"
        }
    }

    func colorForTerritory(_ territory: Territory) -> Color {
        switch territory.ownerID {
        case currentPlayer.id:
            return currentPlayer.color
        case om.id:
            return om.color
        case khush.id:
            return khush.color
        case arya.id:
            return arya.color
        case shiv.id:
            return shiv.color
        default:
            return .gray
        }
    }

    func checkTerritoryCapture(for userLocation: CLLocation) {
        for index in territories.indices {
            let territoryLocation = CLLocation(
                latitude: territories[index].latitude,
                longitude: territories[index].longitude
            )

            let distance = userLocation.distance(from: territoryLocation)
            let territoryID = territories[index].id
            let isInside = distance <= territories[index].radius
            let key = entryKey(playerID: currentPlayer.id, territoryID: territoryID)
            let wasAlreadyInside = playersCurrentlyInsideTerritories.contains(key)

            if isInside && !wasAlreadyInside {
                playersCurrentlyInsideTerritories.insert(key)
                handleVisit(by: currentPlayer, to: territoryID)
            }

            if !isInside && wasAlreadyInside {
                playersCurrentlyInsideTerritories.remove(key)
            }
        }
    }

    func simulateVisit(by player: Player, to territoryID: UUID) {
        let key = entryKey(playerID: player.id, territoryID: territoryID)

        if !playersCurrentlyInsideTerritories.contains(key) {
            playersCurrentlyInsideTerritories.insert(key)
            handleVisit(by: player, to: territoryID)
        } else {
            capturedMessage = "⛔\(player.name) is already inside this territory."
            messagePlayerID = player.id
            clearMessageAfterDelay()
        }
    }

    func simulateLeave(by player: Player, from territoryID: UUID) {
        let key = entryKey(playerID: player.id, territoryID: territoryID)
        playersCurrentlyInsideTerritories.remove(key)

        capturedMessage = "🚶🏻‍♂️\(player.name) left \(territoryName(for: territoryID))"
        clearMessageAfterDelay()
    }

    func visitCount(for player: Player, in territory: Territory) -> Int {
        visitCounts[Visit.key(playerID: player.id, territoryID: territory.id)] ?? 0
    }

    private func handleVisit(by player: Player, to territoryID: UUID) {
        guard let index = territories.firstIndex(where: { $0.id == territoryID }) else { return }

        let key = Visit.key(playerID: player.id, territoryID: territoryID)
        visitCounts[key, default: 0] += 1

        let attackPower = visitCounts[key]!
        let defensePower = territories[index].strength + allianceBonus(
            for: territories[index].ownerID,
            territoryID: territories[index].id
        )
        
        if territories[index].ownerID == nil {
            territories[index].ownerID = player.id
            territories[index].strength = attackPower
            capturedMessage = "🎉\(player.name) captured \(territories[index].name)!"
            messagePlayerID = player.id
        } else if territories[index].ownerID == player.id {
            territories[index].strength = attackPower
            capturedMessage = "💪🏻\(player.name) strengthened \(territories[index].name)! (Power \(attackPower))"
            messagePlayerID = player.id
        } else {
            if attackPower > defensePower {
                territories[index].ownerID = player.id
                territories[index].strength = attackPower
                capturedMessage = "🔥\(player.name) took over \(territories[index].name)! (Power \(attackPower))"
                messagePlayerID = player.id
            } else {
                capturedMessage = "🛡️\(territories[index].name) defended! (\(attackPower) vs \(defensePower))"
                messagePlayerID = player.id
            }
        }

        clearMessageAfterDelay()

        if selectedTerritory?.id == territoryID {
            selectedTerritory = territories[index]
        }
    }

    private func clearMessageAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.capturedMessage = nil
        }
    }

    private func territoryName(for territoryID: UUID) -> String {
        territories.first(where: { $0.id == territoryID })?.name ?? "territory"
    }

    private func entryKey(playerID: UUID, territoryID: UUID) -> String {
        "\(playerID.uuidString)-\(territoryID.uuidString)"
    }
    
    
}
