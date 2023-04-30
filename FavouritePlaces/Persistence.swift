//
//  Persistence.swift
//  FavouritePlaces
//
//  Created by Anuj Khurana on 26/4/2023.
//

import SwiftUI
import CoreData

struct PersistenceHandler {
    static let shared = PersistenceHandler()
    let container: NSPersistentContainer
    init() {
        container = NSPersistentContainer(name:"Model")
        container.loadPersistentStores { _, error in
            if let e = error {
                fatalError("Error in load data \(e).")
            }
        }
    }
}

//func saveData() {
//    let ctx = PersistenceHandler.shared.container.viewContext
//    do{
//        try ctx.save()
//    } catch {
//        fatalError("Error in save data with \(error)")
//    }
//}
