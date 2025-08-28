//
//  AddSortTip.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/21/25.
//

import Foundation
import TipKit

struct AddSortTip: Tip {
    var title: Text { Text("Click to sort") }
    var message: Text? { Text("You can sort by name or date by clicking on the icon in the toolbar") }
    var image: Image? { Image(systemName: "lines.measurement.vertical") }
}
