//
//  RowView.swift
//  FavouritePlaces
//
//  Created by Anuj Khurana on 29/4/2023.
//

import SwiftUI

struct RowView: View {
    var place:Places
    @State var image = defaultImage
    var body: some View {
        HStack{
            image.frame(width: 40, height: 40).clipShape(Circle())
            Text(place.rowDisplay)
        }
        .task {
            image = await place.getImage()
        }
    }
}

