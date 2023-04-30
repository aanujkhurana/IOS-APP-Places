//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by Anuj Khurana on 26/4/2023.
//

import SwiftUI
import CoreData
struct DetailView: View {
    
    @ObservedObject var place: Places
//    @Environment(\.managedObjectContext) var ctx
    @Environment(\.editMode) var editMode
    @State var title = ""
    @State var location = ""
    @State var latitude = ""
    @State var longitude = ""
    @State var url = ""
    @State var image = defaultImage
    
    var body: some View {
        VStack{
            if (editMode?.wrappedValue == .inactive) {
                List {
                    if (url == ""){image.frame(width: 25,height: 25)}
                    else {image.scaledToFit().cornerRadius(20).shadow(radius: 20)}
                    Text("Title: \(title)")
                    Text("location: \(location)")
                    VStack{
                        Text("Latitude: \(latitude)")
                        Text("Longitude: \(longitude)")
                    }
                }
            }else {
                List{
                    TextField("New title:", text: $title)
                    TextField("Url:", text: $url)
                    Text("Enter Location Details:").font(.headline)
                    TextField("Location: ", text: $location)
                    VStack{
                        HStack{
                            Text("Latitude: ")
                            TextField("Latitude: ", text: $latitude)
                        }
                        HStack{
                            Text("Longitude: ")
                            TextField("Longitude: ", text: $longitude)
                        }
                    }

                }
            }
        }
        .navigationTitle(title)
        .navigationBarItems(trailing: EditButton())
        .onAppear{
            title = place.strTitle
            location = place.strLocation
            latitude = place.strLatitude
            longitude = place.strLongitude
            url = place.strUrl
            saveData()
        }
        .onDisappear{
            place.strTitle = title
            place.strUrl = url
            place.strLocation = location
            place.strLongitude = longitude
            place.strLatitude = latitude
            saveData()
        }
        .task {
            await image = place.getImage()
        }
    }
}
