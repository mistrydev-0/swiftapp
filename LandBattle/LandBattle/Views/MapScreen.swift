//
//  MapScreenView.swift
//  LandBattle
//
//  Created by Dev Mistry on 4/13/26.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapScreen: View {
    
    var gameVM: GameViewModel
    
    private func entryKey(playerID: UUID, territoryID: UUID) -> String {
        "\(playerID.uuidString)-\(territoryID.uuidString)"
    }
    
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.7982, longitude: -77.8599),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    )

    @State private var locationVM = LocationViewModel()
    @State private var currentRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7982, longitude: -77.8599),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottom){
                Map(position: $cameraPosition) {
                    UserAnnotation()
                    
                    ForEach(gameVM.territories) { territory in
                        Annotation(territory.name, coordinate: territory.coordinate) {
                            VStack(spacing: 4) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(gameVM.colorForTerritory(territory))

                                Text(territory.name)
                                    .font(.caption)
                                    .padding(4)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(6)
                            }
                            .onTapGesture {
                                gameVM.selectedTerritory = territory
                            }
                        }

                        MapCircle(center: territory.coordinate, radius: territory.radius)
                            .foregroundStyle(gameVM.colorForTerritory(territory).opacity(0.2))
                            .stroke(gameVM.colorForTerritory(territory), lineWidth: 2)
                    }
                }
                .mapControls {
                    MapCompass()
                    MapPitchToggle()
                    MapUserLocationButton()
                }
                .onAppear {
                    locationVM.requestPermission()
                }
                .onChange(of: locationVM.currentLocation) { _, newLocation in
                    guard let newLocation else { return }
                    gameVM.checkTerritoryCapture(for: newLocation)
                }
                .onMapCameraChange { context in
                    currentRegion = context.region
                }
                .onTapGesture {
                    gameVM.selectedTerritory = nil
                }
                
                if let message = gameVM.capturedMessage {
                    VStack {
                        Text(message)
                            .font(.headline)
                            .padding()
                            .background(gameVM.colorForPlayer(gameVM.messagePlayerID))
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.top, 80) // adjust this value
                }
                
                if let territory = gameVM.selectedTerritory {
                    TerritoryCardView(
                        territory: territory,
                        ownerName: gameVM.ownerName(for: territory),
                        playerVisitCount: gameVM.visitCount(
                            for: gameVM.currentPlayer,
                            in: territory
                        ),
                        players: gameVM.players,
                        onVisit: { player in
                            gameVM.simulateVisit(by: player, to: territory.id)
                        },
                        onLeave: { player in
                            gameVM.simulateLeave(by: player, from: territory.id)
                            
                        },
                        allianceBonus: gameVM.allianceBonus(
                            for: territory.ownerID,
                            territoryID: territory.id
                        )
                    )
                    .padding()
                }
            }
            .navigationTitle("Territory Map")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("My Location") {
                        centerOnUser()
                    }
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        zoomIn()
                    } label: {
                        Image(systemName: "plus.magnifyingglass")
                    }

                    Button {
                        zoomOut()
                    } label: {
                        Image(systemName: "minus.magnifyingglass")
                    }

                    Button("Center") {
                        centerOnSampleArea()
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                TerritoryPickerView(
                    territories: gameVM.territories,
                    ownerName: { territory in
                        gameVM.ownerName(for: territory)
                    },
                    onSelect: { territory in
                        gameVM.selectedTerritory = territory
                        focusOnTerritory(territory)
                    }
                )
            }
        }
    }

    private func focusOnTerritory(_ territory: Territory) {
        cameraPosition = .region(
            MKCoordinateRegion(
                center: territory.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        )
    }

    private func centerOnSampleArea() {
        cameraPosition = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 40.7982, longitude: -77.8599),
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        )
    }

    private func centerOnUser() {
        guard let currentLocation = locationVM.currentLocation else { return }

        cameraPosition = .region(
            MKCoordinateRegion(
                center: currentLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }
    
    private func zoomIn() {
        let newSpan = MKCoordinateSpan(
            latitudeDelta: max(currentRegion.span.latitudeDelta * 0.5, 0.001),
            longitudeDelta: max(currentRegion.span.longitudeDelta * 0.5, 0.001)
        )

        currentRegion = MKCoordinateRegion(
            center: currentRegion.center,
            span: newSpan
        )

        cameraPosition = .region(currentRegion)
    }

    private func zoomOut() {
        let newSpan = MKCoordinateSpan(
            latitudeDelta: min(currentRegion.span.latitudeDelta * 2.0, 1.0),
            longitudeDelta: min(currentRegion.span.longitudeDelta * 2.0, 1.0)
        )

        currentRegion = MKCoordinateRegion(
            center: currentRegion.center,
            span: newSpan
        )

        cameraPosition = .region(currentRegion)
    }
}
