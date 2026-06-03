//
//  PlayerDragCard.swift
//  LandBattle
//
//  Created by Dev Mistry on 4/28/26.
//

import SwiftUI

struct PlayerDragCard: View {
    let player: Player

    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.title2)

            Text(player.name)
                .font(.headline)

            Spacer()

            Image(systemName: "line.3.horizontal")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
