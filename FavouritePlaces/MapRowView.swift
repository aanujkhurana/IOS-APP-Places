//
//  MapRowView.swift
//  FavouritePlaces
//
//  Created by Anuj Khurana on 6/5/2023.
//

import SwiftUI
import MapKit


struct MapRowView: View {
    @State var latitude = 0.0
    @State var longitude = 0.0
    @State var location = ""
    @State var showAlert = false
    @ObservedObject var place: Places
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: [.all]).scaledToFill().cornerRadius(18).scenePadding()
        ZStack{
            List{
                Text("Location Name:").font(.title3).foregroundColor(.accentColor)
                Text(place.location ?? "").font(.title3).fontWeight(.medium)
                HStack{
                    Text("Latitude: ").font(.title3).foregroundColor(.accentColor)
                    Text("\(latitude)").font(.title3).fontWeight(.medium)
                }
                HStack{
                    Text("Longitude: ").font(.title3).foregroundColor(.accentColor)
                    Text("\(longitude)").font(.title3).fontWeight(.medium)}
            }.listStyle(.plain)
        }
        .onAppear {
            latitude = place.latitude
            longitude = place.longitude
            location = place.strLocation
        }
        .onDisappear{
            place.location = location
            place.longitude = longitude
            place.latitude = latitude
        }
        .task {
            region.center.longitude = longitude
            region.center.latitude = latitude
        }
    }
}
