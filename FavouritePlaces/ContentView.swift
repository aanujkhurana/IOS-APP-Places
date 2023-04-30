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
    @FetchRequest(sortDescriptors: []) var places : FetchedResults<Places>
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(places) {
                        place in
                        NavigationLink(destination: DetailView(place: place)) {
                            RowView(place: place)
                        }

                    }.onDelete { idx in
                        deletePlaces(idx)
                    }
                }.navigationTitle("Favourite Places 🌎")
                    .navigationBarItems(leading: Button("+ Add"){addNewPlace()}, trailing: EditButton())
            }
        }
    }
    func addNewPlace() {
        let place = Places(context: ctx)
        place.title = "New Place"
        place.latitude = 0.0
        place.longitude = 0.0
        saveData()
    }
    func deletePlaces(_ idx: IndexSet) {
        idx.map{places[$0]}.forEach{place in ctx.delete(place)}
        saveData()
    }
}
