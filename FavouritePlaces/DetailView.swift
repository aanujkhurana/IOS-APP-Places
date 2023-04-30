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
    @State var title = ""
    @State var location = ""
    @State var latitude = ""
    @State var longitude = ""
    @State var url = ""
    @State var image = defaultImage
    
    @Environment(\.editMode) var editMode
     
    var body: some View {
        VStack{
            if (editMode?.wrappedValue == .inactive) {
                List {
                    //display small image if no url
                    if (url == ""){image.frame(width: 25,height: 25)}
                    else {image.scaledToFit().cornerRadius(12)}
                    HStack{
                        Text("Location Details:").font(.headline).foregroundColor(.accentColor)
                        Text("\(location)").bold()
                    }
                    HStack{
                            Text("Latitude: ").font(.headline).foregroundColor(.accentColor)
                            Text("\(latitude)").bold()
                        }
                    HStack{
                            Text("Longitude: ").font(.headline).foregroundColor(.accentColor)
                            Text("\(longitude)").bold()
                        }
                }
            }
            else {
                List{
                    Text("Enter Title:").font(.headline).foregroundColor(.accentColor)
                    TextField("New title:", text: $title)
                    Text("Enter Url:").font(.headline).foregroundColor(.accentColor)
                    TextField("Url:", text: $url)
                    Text("Enter Location Details:").font(.headline).foregroundColor(.accentColor)
                    TextField("Location: ", text: $location)
                    VStack{
                        HStack{
                            Text("Latitude: ").font(.headline).foregroundColor(.accentColor)
                            TextField("Latitude: ", text: $latitude)
                        }
                        HStack{
                            Text("Longitude: ").font(.headline).foregroundColor(.accentColor)
                            TextField("Longitude: ", text: $longitude)
                        }
                    }
                    image.scaledToFit().cornerRadius(12)
                }
            }// end else, in edit mode
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
            // to save data in Places model
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
