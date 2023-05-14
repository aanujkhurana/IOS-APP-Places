//
//  MapRowView.swift
//  FavouritePlaces
//
//  Created by Anuj Khurana on 6/5/2023.
//

import SwiftUI
import MapKit


struct MapView: View {
    
    @State var latitude = ""
    @State var longitude = ""
    @State var location = ""
    @State var showAlert = false
    @ObservedObject var place: Places
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1, longitude: 1), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @Environment(\.editMode) var editMode
    
    var body: some View {
        VStack{
            //outside edit mode
            if (editMode?.wrappedValue == .inactive){
                VStack{
                    Map(coordinateRegion: $region)
                    HStack{
                        Text("Latitude: ").font(.title3).foregroundColor(.accentColor)
                        Text("\(latitude)").font(.title3).fontWeight(.medium)
                    }
                    HStack{
                        Text("Longitude: ").font(.title3).foregroundColor(.accentColor)
                        Text("\(longitude)").font(.title3).fontWeight(.medium)}
                }
            //in edit mode
            } else {
                VStack{
                    Map(coordinateRegion: $region)
                    HStack{
                        Text("Latitude: ").font(.title3).foregroundColor(.accentColor)
                        TextField("Latitude:",text: $region.Strlat)
                            .font(.title3)
                            .fontWeight(.medium)
                            .textFieldStyle(.roundedBorder)
                            .padding(.leading)
                    }
                    HStack{
                        Text("Longitude: ").font(.title3).foregroundColor(.accentColor)
                        TextField("Longitude:",text: $region.Strlong)
                            .font(.title3)
                            .fontWeight(.medium)
                            .textFieldStyle(.roundedBorder)
                            .padding(.leading)
                    }
                }
                    .onDisappear{
                        latitude = region.Strlat
                        longitude = region.Strlong
                        saveData()
                    }
            }
        }
        .navigationTitle("📍Map \(location)")
        .navigationBarItems(trailing: EditButton())
        .onAppear {
            latitude = place.strLatitude
            longitude = place.strLongitude
            location = place.strLocation
        }
        .onDisappear{
            place.strLongitude = longitude
            place.strLatitude = latitude
            saveData()
        }
        .task {
            region.center.longitude = place.longitude
            region.center.latitude = place.latitude
        }
    }
    
//    /// function to update map by cordinates
//    func searchbyCordinates() {
//        place.strLongitude = longitude
//        place.strLatitude = latitude
//        place.updateMap()
//        Task {
//            location = await place.updatelocation()
//        }
//    }
//
//    /// function to update map by locaion
//    func searchbyLocation() {
//        place.location = location
//        Task {
//            guard let _ = await place.updateCordinates() else { showAlert = true; return}
//            latitude = place.strLatitude
//            longitude = place.strLongitude
//            place.updateMap()
//        }
//    }

}
