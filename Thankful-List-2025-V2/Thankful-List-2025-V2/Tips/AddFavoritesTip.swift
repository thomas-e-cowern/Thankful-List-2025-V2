//
//  AddFavoritesTip.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/21/25.
//

import Foundation
import TipKit

struct AddFavoritesTip: Tip {
    var title: Text { Text("Favorite Thanks") }
    var message: Text? { Text("You can see the thanks your've marked as favorites here") }
    var image: Image? { Image(systemName: "heart.fill") }
}
