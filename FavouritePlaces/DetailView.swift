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
                    //display small image (noimage) if no url
                    if (url == ""){ image.frame(width: 15,height: 15) }
                    else { image.scaledToFit().cornerRadius(12) }
                    
                    Text("Location Details:").font(.title2).foregroundColor(.accentColor)
                    Text("\(location)").font(.title2).fontWeight(.medium)
                    HStack{
                        
                        Text("Latitude: ").font(.title3).foregroundColor(.accentColor)
                        Text("\(latitude)").font(.title3).fontWeight(.medium)
                        
                        Text("Longitude: ").font(.title3).foregroundColor(.accentColor)
                        Text("\(longitude)").font(.title3).fontWeight(.medium)
                    }
                }
            }
            else {
                List{
                    
                    Text("Enter Url:").font(.title3).foregroundColor(.accentColor)
                    TextField("Url:", text: $url).font(.title3).fontWeight(.medium)
                    
                    image.scaledToFit().cornerRadius(12)
                    
                    Text("Enter Title:").font(.title2).foregroundColor(.accentColor)
                    TextField("New title:", text: $title).font(.title2).fontWeight(.medium)
                    
                    Text("Enter Location Details:").font(.title3).foregroundColor(.accentColor)
                    TextField("Location: ", text: $location).font(.title3).fontWeight(.medium)
                    
                    VStack{
                        HStack{
                            Text("Enter Latitude: ").font(.title3).foregroundColor(.accentColor)
                            TextField("Latitude: ", text: $latitude).font(.title3).fontWeight(.medium)
                        }
                        HStack{
                            Text("Enter Longitude: ").font(.title3).foregroundColor(.accentColor)
                            TextField("Longitude: ", text: $longitude).font(.title3).fontWeight(.medium)
                        }
                    }
                }
            }// end else, in edit mode
        }.navigationTitle(title)
        .navigationBarItems(trailing: EditButton())
        .onAppear{
            title = place.strTitle
            location = place.strLocation
            latitude = place.strLatitude
            longitude = place.strLongitude
            url = place.strUrl

        }
        .onDisappear{
            place.strTitle = title
            place.strUrl = url
            place.strLocation = location
            place.strLongitude = longitude
            place.strLatitude = latitude
            saveData()
            // to save data in Places model
        }
        .task {
            await image = place.getImage()
        }
    }
}
