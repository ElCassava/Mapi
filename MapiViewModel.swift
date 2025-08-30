//
//  MapiViewModel.swift
//  Mapi
//
//  Created by Nicholas  on 30/08/25.
//

import SwiftUI
import MapKit

class MapiViewModel: ObservableObject {
    
    @Published var camera: MapCameraPosition = .automatic
    @Published var route: MKRoute?
    
    private let locationManager = CLLocationManager()
    
    init() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getUserLocation() async -> CLLocationCoordinate2D?{
        let updates = CLLocationUpdate.liveUpdates()
        
        do{
            let update = try await updates.first{$0.location?.coordinate != nil}
            return update?.location?.coordinate
        } catch {
            print("Cannot get user location")
            return nil
        }
    }
    
    func getDirections(to destination: CLLocationCoordinate2D){
        Task{
            guard let userLocation = await getUserLocation() else {return}
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: userLocation))
            request.destination = MKMapItem(placemark: .init(coordinate: destination))
            request.transportType = .automobile
            
            do {
                let directions = try await MKDirections(request: request).calculate()
                route = directions.routes.first
            } catch {
                print ("Error calculating directions")
            }
            
        }
    }
    
    func moveCamera(to coordinate: CLLocationCoordinate2D) {
            camera = .region(
                MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            )
        }
}
