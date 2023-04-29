//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by Anuj Khurana on 26/4/2023.
//

import SwiftUI
import CoreData
struct DetailView: View {
    @Environment(\.managedObjectContext) var ctx
    var place: Places
    @State var title = ""
    @State var isEditing = false
    @State var id = ""
    @State var url = ""
    @State var image = defaultImage
    var body: some View {
        VStack{
            if !isEditing {
                List {
                    Text("Name: \(title)")
                    Text("id: \(id)")
                    Text("Url: \(url)")
                }
            }else {
                List{
                    TextField("Name:", text: $title)
                    TextField("id:", text: $id)
                    TextField("Url:", text: $url)

                }
            }
            HStack {
                Button("\(isEditing ? "Confirm" : "Edit")"){
                    if(isEditing) {
                        place.strId = id
                        place.strTitle = title
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
            id = place.strId
            url = place.strUrl
        }
        .task {
            await image = place.getImage()
        }
    }
}
