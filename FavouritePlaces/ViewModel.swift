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
let ctx = PersistenceHandler.shared.container.viewContext

///extension of places
extension Places {
    var strTitle:String {
        get {
            self.title ?? "<No Title>"
        }
        set {
            self.title = newValue
        }
    }
    var strLocation:String {
        get {
            self.location ?? "<No Location>"
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
            guard let uiImage = UIImage(data: data) else {return defaultImage}
            let image = Image(uiImage: uiImage).resizable()
            downloadImages[url] = image
            return image
        }catch {
            print("error in download image \(error)")
        }
        
        return defaultImage
    }
}

func loadDefaultData() {
    let defaultPlaces = [["Japan","HIHao Temple","51.71","-141.2",
                          "https://ramatniseko.com/wp-content/uploads/shutterstock_193421459_min-e1560128306371.jpg"],
                         ["Karela","Cameroon Park","71.6","-721.22",
                          "https://tse3.mm.bing.net/th?id=OIP.m3Z-u5DkkC-n83ce3T-oYgHaEo&pid=Api&P=0"],
                         ["Peru","Boston Bridge","61.6","-321.2",
                          "https://images.pexels.com/photos/1462935/pexels-photo-1462935.jpeg?cs=srgb&dl=pexels-joseph-costa-1462935.jpg&fm=jpg"],
                         ["Dubai","Burj Khalifa","241.1","-181.2",
                          "https://media.tacdn.com/media/attractions-splice-spp-674x446/07/74/81/8c.jpg"]]
    
    defaultPlaces.forEach {
        let place = Places(context: ctx)
        place.strTitle = $0[0]
        place.strLocation = $0[1]
        place.strLatitude = $0[2]
        place.strLongitude = $0[3]
        place.strUrl = $0[4]
    }
    saveData()
}

func deletePlace(place: [Places]) {
    place.forEach{
        ctx.delete($0)
    }
    saveData()
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
