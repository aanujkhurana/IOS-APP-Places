//
//  MapVIew.swift
//  FavouritePlaces
//
//  Created by Anuj Khurana on 5/5/2023.
//

import SwiftUI
import MapKit

struct MapEditView: View {
    
    @State var latitude = ""
    @State var longitude = ""
    @State var location = ""
    @State var showAlert = false
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05 ))
    @ObservedObject var place: Places
    @Environment(\.editMode) var editMode
    
    var body: some View {
        VStack{
            if (editMode?.wrappedValue == .active){
                Map(coordinateRegion: $region, interactionModes: [.all]).cornerRadius(18).frame(maxHeight: 250).scenePadding()

                List{
                    Text("Enter Location Name:").font(.title3).foregroundColor(.accentColor)
                    TextField("Location: ", text: $location).font(.title3).fontWeight(.medium)
                    Button("Find Location")
                    {searchbyLocation()}.padding(10).fontWeight(.medium).background(Color.red).foregroundColor(.white).cornerRadius(6)
                    HStack{
                        Text("Enter Latitude: ").font(.title3).foregroundColor(.accentColor)
                        TextField("Latitude: ", text: $latitude).font(.title3).fontWeight(.medium)
                        
                    }
                    HStack{
                            Text("Enter Longitude: ").font(.title3).foregroundColor(.accentColor)
                            TextField("Longitude: ", text: $longitude).font(.title3).fontWeight(.medium)
            
                    }
                    Button("Find Cordinates")
                    {searchbyCordinates()}.padding(10).fontWeight(.medium).background(Color.green).foregroundColor(.white).cornerRadius(6)
                }.listStyle(.plain)
            }
            else{MapRowView(place: place)}
        }
        Spacer()
        .navigationTitle("📍Map")
        .navigationBarItems(trailing: EditButton())
        .onAppear {
            latitude = place.strLatitude
            longitude = place.strLongitude
            location = place.strLocation
//            delta = place.gldDlta
        }
        .onDisappear{
            place.strLocation = location
            place.strLongitude = longitude
            place.strLatitude = latitude
            saveData()
        }
        .task {
            region.center.longitude = place.longitude
            region.center.latitude = place.latitude
//            region.span.latitudeDelta = delta
//            region.span.longitudeDelta = delta
        }
        .alert("Can't find location \(location)", isPresented: $showAlert) {
            Button("Ok", role: .cancel){}
        }
    } // end body
    
    func searchbyCordinates() {
        place.strLongitude = longitude
        place.strLatitude = latitude
        place.updateMap()
        Task {
            location = await place.updatelocation()
        }
    }

    func searchbyLocation() {
        place.location = location
        Task {
            guard let _ = await place.updateCordinates() else { showAlert = true; return}
            latitude = place.strLatitude
            longitude = place.strLongitude
            place.updateMap()
        }
    }
} //end struct


