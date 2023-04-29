//
//  ViewModel.swift
//  FavouritePlaces
//
//  Created by Anuj Khurana on 29/4/2023.
//

import Foundation
import CoreData
import SwiftUI

let defaultImage = Image(systemName: "photo").resizable()
var downloadImages :[URL:Image] = [:]

extension Places {
    var strTitle:String {
        get {
            self.title ?? "unknown"
        }
        set {
            self.title = newValue
        }
    }
    var strId : String {
        get {
            "\(self.id)"
        }
        set {
            guard let id = Int16(newValue) else {
                return
            }
            self.id = id
        }
    }
    var strUrl: String {
        get{
            self.imgurl?.absoluteString ?? ""
        }
        set {
            guard let url = URL(string: newValue) else {return}
            self.imgurl = url
        }
    }
    var rowDisplay:String {
        "Name: \(self.strTitle) (age: \(self.strId))"
    }
    func getImage() async ->Image {
        guard let url = self.imgurl else {return defaultImage}
        if let image = downloadImages[url] {return image}
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiimg = UIImage(data: data) else {return defaultImage}
            let image = Image(uiImage: uiimg).resizable()
            downloadImages[url]=image
            return image
        }catch {
            print("error in download image \(error)")
        }
        
        return defaultImage
    }
}
func createInitAnimals() {
    
}
//func saveData() {
//    let ctx = PersistenceHandler.shared.container.viewContext
//    do {
//        try ctx.save()
//    }catch {
//        print("Error to save with \(error)")
//    }
//}


