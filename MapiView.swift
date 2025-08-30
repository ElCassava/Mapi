//
//  ContentView.swift
//  Mapi
//
//  Created by Nicholas  on 05/08/25.
//

import SwiftUI
import MapKit
//import CoreLocation

struct MapiView: View {
    
    let ADA = CLLocationCoordinate2D(latitude: -6.3020086989578905, longitude: 106.65259438562504)
    
    let home = CLLocationCoordinate2D(latitude: -6.203975397400462, longitude: 106.7119072702203)
    
    let mam = CLLocationCoordinate2D(latitude: -6.2712081003800755,longitude: 106.6218107142091)
    @StateObject private var viewModel = MapiViewModel()
    
    var body: some View {
        Map(position: $viewModel.camera){
            Annotation("Apple Dev", coordinate: ADA){
                Image(systemName: "briefcase")
                    .foregroundStyle(.white)
                    .padding(2)
                    .background(.blue)
                    .contextMenu {
                        Button("Get Direction", systemImage: "road.lanes"){
                            viewModel.getDirections(to: ADA)
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
                            viewModel.getDirections(to: home)
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
                            viewModel.getDirections(to: mam)
                        }
                    }
            
            }
            UserAnnotation()
            if let route = viewModel.route{
                MapPolyline(route)
                    .stroke(Color.blue, lineWidth: 4)
            }
            
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
                    viewModel.moveCamera(to: home)
                } label:{
                    Text("Home")
                }
                Button {
                    viewModel.moveCamera(to: ADA)
                } label:{
                    Text("Work")
                }

                Spacer()
            }
            .padding(.top)
            .background(.thinMaterial)
        }
        
    }
}

#Preview {
    MapiView()
}
