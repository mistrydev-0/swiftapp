//
//  Alliance.swift
//  LandBattle
//
//  Created by Dev Mistry on 4/16/26.
//

import Foundation

struct Alliance: Identifiable {
    let id = UUID()
    var name: String
    var memberIDs: [String]
}
