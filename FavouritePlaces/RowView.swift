//
//  RowView.swift
//  FavouritePlaces
//
//  Created by Anuj Khurana on 30/4/2023.
//

import SwiftUI

struct RowView: View {
    @State var image = defaultImage
    @ObservedObject var place: Places
    var body: some View {
        HStack{
            image.frame(width: 25, height: 25).border(.black)
            Text(place.strTitle)
        }
        .task {
            image = await place.getImage()
        }
    }
}
