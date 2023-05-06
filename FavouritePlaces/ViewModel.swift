//
//  ViewModel.swift
//  FavouritePlaces
//
//  Created by Anuj Khurana on 29/4/2023.
//

import Foundation
import CoreData
import SwiftUI
import CoreLocation
import MapKit

let defaultImage = Image(systemName: "photo").resizable()
var downloadImages : [URL:Image] = [:]
let ctx = PersistenceHandler.shared.container.viewContext
var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1 ))
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
    var strLatitude: String {
        get {
            String(format: "%.4f", self.latitude)
        }
        set {
            guard let lat = Double(newValue), lat <= 90, lat >= -90 else {return}
            latitude = lat
        }
    }

    var strLongitude: String {
        get {
            String(format: "%.4f", self.longitude)
        }
        set {
            guard let long = Double(newValue), long <= 180, long >= -180 else {return}
            longitude = long
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
    
    var gldDlta: Double {
        get{
            100.0 / self.delta
        }
        set {
            self.delta = 100.0/newValue
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
            downloadImages[url] = image // error is here
            return image
        }catch {
            print("error in download image \(error)")
        }
        
        return defaultImage
    }
    
    
    
    func updateMap() {
        region.center.latitude = latitude
        region.center.longitude = longitude
    }
    
    func updatelocation() async -> String {
        location = await locationToCordinates(latitude, longitude)
        return location ?? ""
    }
    func updateCordinates() async -> CLLocation? {
        if let loc = await cordinatesToLocation(location ?? "") {
            latitude = loc.coordinate.latitude
            longitude = loc.coordinate.longitude
            return loc
        }
        return nil
    }
    
}
//end places ext

func cordinatesToLocation(_ address: String) async -> CLLocation? {
    let coder = CLGeocoder()
    guard let marks = try? await coder.geocodeAddressString(address) else {return nil}
    guard let loc = marks.first?.location else {return nil}
    return loc
}

func locationToCordinates(_ lat: Double, _ long: Double) async -> String {
    let coder = CLGeocoder()
    let loc = CLLocation(latitude: lat, longitude: long)
    guard let marks = try? await coder.reverseGeocodeLocation(loc), let pmk = marks.first else {return "Can't find the address"}
    return pmk.name ?? pmk.country ?? pmk.administrativeArea ?? pmk.locality ?? pmk.thoroughfare ?? "Unknown place"
}

func loadDefaultData() {
    let defaultPlaces = [["Japan","HIHao Temple","0","0",
                          "https://ramatniseko.com/wp-content/uploads/shutterstock_193421459_min-e1560128306371.jpg"],
                         ["Karela","Cameroon Park","0","0",
                          "https://tse3.mm.bing.net/th?id=OIP.m3Z-u5DkkC-n83ce3T-oYgHaEo&pid=Api&P=0"],
                         ["Peru","Boston Bridge","0","0",
                          "https://images.pexels.com/photos/1462935/pexels-photo-1462935.jpeg?cs=srgb&dl=pexels-joseph-costa-1462935.jpg&fm=jpg"],
                         ["Dubai","Burj Khalifa","0","0",
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

