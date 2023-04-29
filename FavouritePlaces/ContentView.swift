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
    @FetchRequest(entity: Places.entity(), sortDescriptors: [
        NSSortDescriptor(key: "id", ascending: true)
        ])
    var places: FetchedResults<Places>
    @State var isAdding = false
    @State var name = ""
    @State var address = ""
    var body: some View {
        NavigationView {
            VStack {
                if isAdding {
                    Text("New contact Name")
                    TextField("name:", text: $name)
                    Button("Confirm New place") {
                        addNewPlace()
                        isAdding = false
                    }
                } else {
                    Button("Add New Place") {
                        isAdding = true
                    }
                }
                List {
                    ForEach(places) {
                        place in
                        NavigationLink(destination: DetailView(place: place)) {
                            Text(place.title ?? "")
                            RowView(place: place)
                        }

                    }.onDelete { idx in
                        deleteContact(idx)
                    }.onMove { idx, pos in
                        moveContact(idx, pos)
                    }
                }
            }
            .padding()
            .navigationTitle("Favourite🌎Places")
            .navigationBarItems(leading: EditButton())

        }
    }
    
    func moveContact(_ idx: IndexSet, _ p: Int) {
        var posArr = places.map(\.id)
        posArr.move(fromOffsets: idx, toOffset: p)
        posArr.indices.forEach { i in
            places[i].id = posArr[i]
        }
        saveData()
    }
    func sortContacts()->Int16 {
        var pos:Int16 = 1
        places.forEach { place in
            place.id = pos
            pos += 1
        }
        return pos
    }
    func addNewPlace() {
        guard name != "" else {
            return
        }
        let place = Places(context: ctx)
        place.title = name
        place.id = sortContacts()
        saveData()
        name = ""
        address = ""
    }
    func deleteContact(_ idx: IndexSet) {
        idx.map{places[$0]}.forEach{place in ctx.delete(place)}
        saveData()
    }
}
