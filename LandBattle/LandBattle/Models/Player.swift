//
//  Player.swift
//  LandBattle
//
//  Created by Dev Mistry on 4/16/26.
//

import Foundation
import SwiftUI

struct Player: Identifiable, Hashable {
    let id: UUID
    let name: String
    let color: Color
}
