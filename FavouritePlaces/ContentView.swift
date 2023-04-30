//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Anuj Khurana on 26/4/2023.
//
import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var ctx
    @FetchRequest( sortDescriptors: [
    NSSortDescriptor(key: "title", ascending: true)
    ]) var places:FetchedResults<Places>
    @State var image = defaultImage
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(places) {
                        place in
                        NavigationLink(destination: DetailView(place: place)) {
                            HStack{
                                image.frame(width: 50, height: 50).clipShape(Circle())
                                Text(place.title ?? "Unknown Title")
                            }
                            .task {
                                image = await place.getImage()
                            }
                        }

                    }.onDelete { idx in
                        deletePlaces(idx)
                    }
//                    .onMove { idx, pos in
//                        movePlaces(idx, pos)
//                    }
                }
            }
            .padding()
            .navigationTitle("Favourite Places 🌎")
            .navigationBarItems(leading: Button("+ Add"){addNewPlace()}, trailing: EditButton())

        }
    }
    
//    func movePlaces(_ idx: IndexSet, _ p: Int) {
//        var posArr = places.map(\.id)
//        posArr.move(fromOffsets: idx, toOffset: p)
//        posArr.indices.forEach { i in
//            places[i].id = posArr[i]
//        }
//        saveData()
//    }
    
    func addNewPlace() {
        let place = Places(context: ctx)
        place.title = "New Place"
        place.desc = "No Description"
        place.latitude = 0.0
        place.longitude = 0.0
        saveData()
    }
    func deletePlaces(_ idx: IndexSet) {
        idx.map{places[$0]}.forEach{place in ctx.delete(place)}
        saveData()
    }
}
