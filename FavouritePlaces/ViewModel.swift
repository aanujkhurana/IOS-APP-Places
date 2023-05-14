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

let defaultImage = Image(systemName: "photo").resizable() // get image from url
var downloadImages : [URL:Image] = [:] // to display image from url
let ctx = PersistenceHandler.shared.container.viewContext // for fetching data
var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1 )) // for map

///extension of places
extension Places {
    var strLocation:String {
        get {
            self.location ?? ""
        }
        set {
            self.location = newValue
        }
    }
    var strDesc:String {
        get {
            self.desc ?? ""
        }
        set {
            self.desc = newValue
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
    
    /// function to download image from url
    /// - Returns: return downloaded img
    func getImage() async ->Image {
        guard let url = self.imgurl else {return defaultImage}
        if let image = downloadImages[url] {return image}
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiImage = UIImage(data: data) else {return defaultImage}
            let image = Image(uiImage: uiImage).resizable()
            downloadImages[url] = image // error is here, run again n agian untill runs
            return image
        }catch {
            print("error in download image \(error)")
        }
        
        return defaultImage
    }
    
    
    
    /// function to update map by region.center
    func updateMap() {
        region.center.latitude = latitude
        region.center.longitude = longitude
    }
    
    /// function to update location
    /// - Returns: updated location
    func updatelocation() async -> String {
        location = await locationToCordinates(latitude, longitude)
        return location ?? ""
    }
    /// function to update cordinates
    /// - Returns: latitude and longitude
    func updateCordinates() async -> CLLocation? {
        if let cordinates = await cordinatesToLocation(location ?? "") {
            latitude = cordinates.coordinate.latitude
            longitude = cordinates.coordinate.longitude
            return cordinates
        }
        return nil
    }
    
}
//end places ext

/// functin to find latitude and longitude from location
/// - Parameter location: location name
/// - Returns: cordinates, latitude and longitude
func cordinatesToLocation(_ location: String) async -> CLLocation? {
    let coder = CLGeocoder()
    guard let marks = try? await coder.geocodeAddressString(location) else {return nil}
    guard let cordinates = marks.first?.location else {return nil}
    return cordinates
}

/// functin to search location from latitude and longitude
/// - Parameters:
///   - lat: place latitude
///   - long: place longitude
/// - Returns: location name
func locationToCordinates(_ lat: Double, _ long: Double) async -> String {
    let coder = CLGeocoder()
    let loc = CLLocation(latitude: lat, longitude: long)
    guard let marks = try? await coder.reverseGeocodeLocation(loc), let pmk = marks.first else {return "Can't find the address"}
    return pmk.name ?? pmk.country ?? pmk.administrativeArea ?? pmk.locality ?? pmk.thoroughfare ?? "Unknown place"
}

/// function to delete places
/// - Parameter place: Places
func deletePlace(place: [Places]) {
    place.forEach{
        ctx.delete($0)
    }
    saveData()
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

/// Function to load default data if no data is present
func loadDefaultData() {
    let defaultPlaces = [["Japan","This is HIHAO!! Temple in Japan","36.204824","138.252924",
                          "https://ramatniseko.com/wp-content/uploads/shutterstock_193421459_min-e1560128306371.jpg"],
                         ["Sydney","Sydney is captial of Canberra","-33.865143","151.209900",
                          "https://tse3.mm.bing.net/th?id=OIP.m3Z-u5DkkC-n83ce3T-oYgHaEo&pid=Api&P=0"],
                         ["Peru","Boston Bridge is must visit in Peru","-12.046374","-77.042793",
                          "https://images.pexels.com/photos/1462935/pexels-photo-1462935.jpeg?cs=srgb&dl=pexels-joseph-costa-1462935.jpg&fm=jpg"],
                         ["Dubai","Burj Khalifa is tallest building in Dubai","25.276987","55.296249",
                          "https://media.tacdn.com/media/attractions-splice-spp-674x446/07/74/81/8c.jpg"]]
    
    defaultPlaces.forEach {
        let place = Places(context: ctx)
        place.strLocation = $0[0]
        place.strDesc = $0[1]
        place.strLatitude = $0[2]
        place.strLongitude = $0[3]
        place.strUrl = $0[4]
    }
    saveData()
}

/// MK Coordinate extension to store latitude and longitude from region.centre
extension MKCoordinateRegion: Equatable {
    
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.Strlat == rhs.Strlat && lhs.Strlong == rhs.Strlong
    }
    
    var Strlat: String {
        get{
            "\(center.latitude)"
        }
        set{
            guard let d = Double(newValue) else {return}
            center.latitude = d
        }
    }
    var Strlong: String {
        get{
            "\(center.longitude)"
        }
        set{
            guard let d = Double(newValue) else {return}
            center.longitude = d
        }
    }
}

