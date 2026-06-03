//
//  TerritoryPickerView.swift
//  LandBattle
//
//  Created by Dev Mistry on 4/24/26.
//

import SwiftUI

struct TerritoryPickerView: View {
    let territories: [Territory]
    let ownerName: (Territory) -> String
    let onSelect: (Territory) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(territories) { territory in
                    Button {
                        onSelect(territory)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(territory.name)
                                .font(.headline)

                            Text(ownerName(territory))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
}
