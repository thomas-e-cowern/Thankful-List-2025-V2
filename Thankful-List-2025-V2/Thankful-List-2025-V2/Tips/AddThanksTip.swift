//
//  AddThanksTip.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/18/25.
//

import Foundation
import TipKit

struct AddThanksTip: Tip {
    var title: Text { Text("Click the + icon above to add a somthing you are thankful for") }
    var message: Text? { Text("You can click the + to add a thanks from any view") }
    var image: Image? { Image(systemName: "pencil.circle") }
}
