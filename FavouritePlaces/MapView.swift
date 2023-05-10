//
//  MapRowView.swift
//  FavouritePlaces
//
//  Created by Anuj Khurana on 6/5/2023.
//

import SwiftUI
import MapKit


struct MapView: View {
    
    @State var latitude = 0.0
    @State var longitude = 0.0
    @State var location = ""
    @State var showAlert = false
    @ObservedObject var place: Places
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1, longitude: 1), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @Environment(\.editMode) var editMode
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter}()
    
    var body: some View {
        VStack{
            Map(coordinateRegion: $region, interactionModes: [.all]).scaledToFill().cornerRadius(18).scenePadding()
            if (editMode?.wrappedValue == .inactive){
                List{
                    Text("Location Name:").font(.title3).foregroundColor(.accentColor)
                    Text(location).font(.title3).fontWeight(.medium)
                    HStack{
                        Text("Latitude: ").font(.title3).foregroundColor(.accentColor)
                        Text("\(latitude)").font(.title3).fontWeight(.medium)
                    }
                    HStack{
                        Text("Longitude: ").font(.title3).foregroundColor(.accentColor)
                        Text("\(longitude)").font(.title3).fontWeight(.medium)}
                }.listStyle(.plain)
            } else {
                List{
                    Text("Enter Location Name:").font(.title3).foregroundColor(.accentColor)
                    TextField("Location: ", text: $location)
                        .font(.title3).fontWeight(.medium).textFieldStyle(.roundedBorder)
                        .onSubmit {
                            searchbyLocation()
                        }
                    HStack{
                        Text("Enter Latitude: ").font(.title3).foregroundColor(.accentColor)
                        TextField("Latitude:",value: $region.center.latitude,formatter:formatter)
                            .font(.title3)
                            .fontWeight(.medium)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack{
                        Text("Enter Longitude: ").font(.title3).foregroundColor(.accentColor)
                        TextField("Longitude:",value: $region.center.longitude,formatter:formatter)
                            .font(.title3)
                            .fontWeight(.medium)
                            .textFieldStyle(.roundedBorder)}
                    .onSubmit {
                        searchbyCordinates()
                    }
                }.listStyle(.plain)
                    .onDisappear{
                        latitude = region.center.latitude
                        longitude = region.center.longitude
                        if (latitude != 0){
                            searchbyCordinates()
                        }else {searchbyLocation()}
                    }
            }
        }
        .navigationTitle("📍Map")
        .navigationBarItems(trailing: EditButton())
        .onAppear {
            latitude = place.latitude
            longitude = place.longitude
            location = place.strLocation
        }
        .onDisappear{
            place.strLocation = location
            place.location = location
            place.longitude = longitude
            place.latitude = latitude
            saveData()
        }
        .task {
            region.center.longitude = longitude
            region.center.latitude = latitude
        }
        .alert("Can't find location \(location)", isPresented: $showAlert) {
            Button("Ok", role: .cancel){}
        }
    }
    func searchbyCordinates() {
        place.longitude = longitude
        place.latitude = latitude
        place.updateMap()
        Task {
            location = await place.updatelocation()
        }
    }

    func searchbyLocation() {
        place.location = location
        Task {
            guard let _ = await place.updateCordinates() else { showAlert = true; return}
            latitude = place.latitude
            longitude = place.longitude
            place.updateMap()
        }
    }
}
