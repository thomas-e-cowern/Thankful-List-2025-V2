//
//  AddThanksTip.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/18/25.
//

import Foundation
import TipKit

struct AddThanksTip: Tip {
    var title: Text { Text("Click to add a Thanks") }
    var message: Text? { Text("You can click here to add a Thanks from any view") }
    var image: Image? { Image(systemName: "pencil.circle") }
}
