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
    @State var desc = ""
    @State var latitude = ""
    @State var longitude = ""
    @State var url = ""
    @State var image = defaultImage
    
    var body: some View {
        VStack{
            if !isEditing {
                List {
                    Text("Title: \(title)")
                    Text("Description: \(desc)")
                    Text("latitude: \(latitude)")
                    Text("longitude: \(longitude)")
                    Text("Url: \(url)")
                }
            }else {
                List{
                    TextField("Name:", text: $title)
                    TextField("Description:", text: $desc)
                    TextField("latitude:", text: $latitude)
                    TextField("longitude:", text: $longitude)
                    TextField("Url:", text: $url)

                }
            }
            HStack {
                Button("\(isEditing ? "Confirm" : "Edit")"){
                    if(isEditing) {
                        place.strLongitude = longitude
                        place.strLatitude = latitude
                        place.strTitle = title
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
            image.scaledToFit().cornerRadius(20).shadow(radius: 20)
        }
        .navigationTitle("Place Detail")
        .onAppear{
            title = place.strTitle
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
