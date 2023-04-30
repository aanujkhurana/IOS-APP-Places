//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by Anuj Khurana on 26/4/2023.
//

import SwiftUI
import CoreData
struct DetailView: View {
    
    var place: Places
    @Environment(\.managedObjectContext) var ctx
    
    @State var isEditing = false
    @State var title = ""
    @State var location = ""
    @State var desc = ""
    @State var latitude = ""
    @State var longitude = ""
    @State var url = ""
    @State var image = defaultImage
    
    var body: some View {
        VStack{
            if !isEditing {
                List {
                    image.scaledToFit().cornerRadius(20).shadow(radius: 20)
                    Text("Title: \(title)")
                    Text("Description: \(desc)")
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
                    Text("Enter Place Details:").font(.headline)
                    TextField("Location: ", text: $location)
                    TextField("Description: ", text: $desc)
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
            HStack {
                Button("\(isEditing ? "Confirm" : "Edit")"){
                    if(isEditing) {
                        place.strTitle = title
                        place.strLocation = location
                        place.strLongitude = longitude
                        place.strLatitude = latitude
                        place.strDesc = desc
                        place.strUrl = url
                        saveData()
                        Task {
                            image = await place.getImage()
                        }
                    }
                    isEditing.toggle()
                }
            }
        }
        .navigationTitle(title)
        .onAppear{
            title = place.strTitle
            location = place.strLocation
            desc = place.strDesc
            latitude = place.strLatitude
            longitude = place.strLongitude
            url = place.strUrl
        }
        .task {
            await image = place.getImage()
        }
    }
}
