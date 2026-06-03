//
//  Territory.swift
//  LandBattle
//
//  Created by Dev Mistry on 4/13/26.
//

import Foundation
import CoreLocation

struct Territory: Identifiable, Hashable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    let radius: Double
    var ownerID: UUID?
    var strength: Int

    init(
        id: UUID = UUID(),
        name: String,
        latitude: Double,
        longitude: Double,
        radius: Double = 100,
        ownerID: UUID? = nil,
        strength: Int = 0
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.ownerID = ownerID
        self.strength = strength
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
