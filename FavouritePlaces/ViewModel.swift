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
var downloadImages : [URL:Image] = [:]

///extension of places to store entities and download image as default image
extension Places {
    var strTitle:String {
        get {
            self.title ?? "unknown"
        }
        set {
            self.title = newValue
        }
    }
    var strLocation:String {
        get {
            self.location ?? "unknown"
        }
        set {
            self.location = newValue
        }
    }
    var strLatitude : String {
        get {
            "\(self.latitude)"
        }
        set {
            guard let latitude = Float(newValue) else {
                return
            }
            self.latitude = latitude
        }
    }
    var strLongitude : String {
        get {
            "\(self.longitude)"
        }
        set {
            guard let longitude = Float(newValue) else {
                return
            }
            self.longitude = longitude
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
    
    /// function to download image from url
    /// - Returns: return downloaded img
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
func createInitPlaces() {
    
}

/// Function to save data anywhere change is made
func saveData() {
    let ctx = PersistenceHandler.shared.container.viewContext
    do {
        try ctx.save()
    }catch {
        print("Error to save with \(error)")
    }
}
