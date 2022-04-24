//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by Patompong Manprasatkul on 24/04/2022.
//

import SwiftUI

struct FlagImage: View {
    let name: String
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .cornerRadius(16)
            .shadow(radius: 5)
    }
}

struct FlagImage_Previews: PreviewProvider {
    static var previews: some View {
        FlagImage(name: "US")
    }
}
