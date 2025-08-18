//
//  IconImages.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/18/25.
//

import Foundation

enum IconImages: String, CaseIterable, Identifiable {
    case star = "star.fill"
    case swirl = "swirl.circle.righthalf.filled.inverse"
    case circle = "circle.dotted.circle.fill"
    case person = "person.fill"
    case sun = "sun.min.fill"
    case pencil = "pencil.circle"
    case keyboard = "keyboard"
    case flag = "flag.pattern.checkered"
    case chain = "personalhotspot"
    case walk = "figure.walk"
    case run = "figure.run"
    case moon = "moonphase.waxing.gibbous.inverse"
    case bird = "bird.fill"
    var id: Self { self }
}
