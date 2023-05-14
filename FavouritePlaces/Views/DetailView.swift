//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by Anuj Khurana on 26/4/2023.
//

import SwiftUI
import CoreData
import MapKit
import CoreLocation

struct DetailView: View {
    
    @ObservedObject var place: Places
    
    @State var location = ""
    @State var desc = ""
    @State var latitude = ""
    @State var longitude = ""
    @State var url = ""
    @State var image = defaultImage
    
    @Environment(\.editMode) var editMode
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:1, longitude: 1), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1 ))
     
    var body: some View {
        VStack{
            if (editMode?.wrappedValue == .inactive) {
                List {
                    //display small image (noimage) if no url
                    if (url == ""){ image.frame(width: 15,height: 15) }
                    else { image.scaledToFit().cornerRadius(12) }
                    
                    Text("Location Description:").font(.title2).foregroundColor(.accentColor)
                    Text("\(desc)").font(.title2).fontWeight(.medium)
                    Text("Map:").font(.title2).foregroundColor(.accentColor)
                    
                        NavigationLink(destination: MapView(place: place)) {
                            Map(coordinateRegion: $region) // display small map
                            Text("Map of \(location)").font(.title3).fontWeight(.medium)
                        }
                }
            }
            else {
                List{
//                    url for image
                    Text("Enter Url:").font(.title3).foregroundColor(.accentColor)
                    TextField("Url:", text: $url).font(.title3).fontWeight(.medium)
//                    image from url
                    image.scaledToFit().cornerRadius(12)
//                      location name
                    Text("Enter Locaion:").font(.title2).foregroundColor(.accentColor)
                    TextField("location:", text: $location).font(.title2).fontWeight(.medium)
//                    location description
                    Text("Enter Location details:").font(.title3).foregroundColor(.accentColor)
                    TextField("Location details ", text: $desc).font(.title3).fontWeight(.medium).frame(height: 50)
                }

            }// end else, in edit mode
        }.navigationTitle(location)
        .navigationBarItems(trailing: EditButton())
        .onAppear{
            region.center.latitude = place.latitude
            region.center.longitude = place.longitude
            location = place.strLocation
            desc = place.strDesc
            latitude = place.strLatitude
            longitude = place.strLongitude
            url = place.strUrl

        }
        .onDisappear{
            place.strLocation = location
            place.strUrl = url
            place.strDesc = desc
            saveData() // to save data in Places model
        }
        .task {
            await image = place.getImage()
        }
    }
    
    /// function to map and cordinates with location
//    func locToMap() {
//        place.title = title
//        Task {
//            guard let _ = await place.updateCordinates() else {return}
//            latitude = place.strLatitude
//            longitude = place.strLongitude
//            place.updateMap()
//        }
//    }
}
