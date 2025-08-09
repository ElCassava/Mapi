//
//  ContentView.swift
//  Mapi
//
//  Created by Nicholas  on 05/08/25.
//

import SwiftUI
import MapKit
//import CoreLocation

struct ContentView: View {
    
    let ADA = CLLocationCoordinate2D(latitude: -6.3020086989578905, longitude: 106.65259438562504)
    
    let home = CLLocationCoordinate2D(latitude: -6.203975397400462, longitude: 106.7119072702203)
    
    let mam = CLLocationCoordinate2D(latitude: -6.2712081003800755,longitude: 106.6218107142091)
    
    let locationManager = CLLocationManager()
    
    @State var camera: MapCameraPosition = .automatic
    @State var route: MKRoute?
    
    var body: some View {
        Map(position: $camera){
            Annotation("Apple Dev", coordinate: ADA){
                Image(systemName: "briefcase")
                    .foregroundStyle(.white)
                    .padding(2)
                    .background(.blue)
                    .contextMenu {
                        Button("Get Direction", systemImage: "road.lanes"){
                            getDirections(to: ADA)
                        }
                    }
                
                    
            }
            
            Annotation("Home", coordinate: home){
                Image(systemName: "house")
                    .foregroundStyle(.white)
                    .padding(2)
                    .background(.vece)
                    .contextMenu {
                        Button("Get Direction", systemImage: "road.lanes"){
                            getDirections(to: home)
                        }
                    }
            }
            
            Annotation("Mam", coordinate: mam){
                Image(systemName: "fork.knife")
                    .foregroundStyle(.white)
                    .padding(2)
                    .background(.red)
                    .contextMenu {
                        Button("Get Direction", systemImage: "road.lanes") {
                            getDirections(to: mam)
                        }
                    }
            
            }
            UserAnnotation()
            if let route{
                MapPolyline(route)
                    .stroke(Color.blue, lineWidth: 4)
            }
            
        }
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
        }
        .mapControls{
            MapUserLocationButton()
            MapCompass()
            MapPitchToggle()
            MapScaleView()
            
        }
        .mapStyle(.standard(elevation: .realistic))
        .safeAreaInset(edge: .bottom){
            HStack{
                Spacer()
                Button {
                    camera = .region(
                        MKCoordinateRegion(center: home, latitudinalMeters: 200, longitudinalMeters: 200)
                    )
                } label:{
                    Text("Home")
                }
                Button {
                    camera = .region(
                        MKCoordinateRegion(center: ADA, latitudinalMeters: 200, longitudinalMeters: 200)
                    )
                } label:{
                    Text("Work")
                }

                Spacer()
            }
            .padding(.top)
            .background(.thinMaterial)
        }
        
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
}

#Preview {
    ContentView()
}
