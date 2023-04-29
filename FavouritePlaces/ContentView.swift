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
    @FetchRequest(entity: Places.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)])
    var places: FetchedResults<Places>
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Add New Place") {
                    addNewPlace()
                }
                List {
                    ForEach(places) {
                        place in
                        NavigationLink(destination: DetailView(place: place)) {
                            RowView(place: place)
                        }

                    }.onDelete { idx in
                        deletePlaces(idx)
                    }.onMove { idx, pos in
                        movePlaces(idx, pos)
                    }
                }
            }
            .padding()
            .navigationTitle("Favourite🌎Places")
            .navigationBarItems(leading: EditButton())

        }
    }
    
    func movePlaces(_ idx: IndexSet, _ p: Int) {
        var posArr = places.map(\.id)
        posArr.move(fromOffsets: idx, toOffset: p)
        posArr.indices.forEach { i in
            places[i].id = posArr[i]
        }
        saveData()
    }
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
