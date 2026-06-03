//
//  Visit.swift
//  LandBattle
//
//  Created by Dev Mistry on 4/16/26.
//

import Foundation

struct Visit: Identifiable, Hashable {
    let id: UUID
    let playerID: UUID
    let territoryID: UUID
    let timestamp: Date

    init(
        id: UUID = UUID(),
        playerID: UUID,
        territoryID: UUID,
        timestamp: Date = .now
    ) {
        self.id = id
        self.playerID = playerID
        self.territoryID = territoryID
        self.timestamp = timestamp
    }

    var key: String {
        "\(playerID.uuidString)-\(territoryID.uuidString)"
    }

    static func key(playerID: UUID, territoryID: UUID) -> String {
        "\(playerID.uuidString)-\(territoryID.uuidString)"
    }
}
