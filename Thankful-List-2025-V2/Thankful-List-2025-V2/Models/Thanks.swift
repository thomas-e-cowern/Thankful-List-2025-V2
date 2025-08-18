//
//  ThanksModel.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/18/25.
//

import SwiftUI
import SwiftData

@Model
class Thanks: Identifiable {
    var id = UUID()
    var title: String
    var reason: String
    var date: Date
    var isFavorite: Bool
    var icon: String
    var color: String
    
    @Attribute(.externalStorage) var photo: Data?
    
    init(title: String, body: String, date: Date, isFavorite: Bool, icon: String, color: String) {
        self.title = title
        self.reason = body
        self.date = date
        self.isFavorite = isFavorite
        self.icon = icon
        self.color = color
    }
    
    var hexColor: Color {
        Color(hex: self.color) ?? .blue
    }
}

extension Thanks {
    
    static var sampleThanks: [Thanks] {
        [
            Thanks(title: "My home", body: "I am thankful for the roof over my head", date: Date(), isFavorite: false, icon: "person.fill", color: "#FFA500"),
            Thanks(title: "My car", body: "My car takes me where I need to go", date: Date(), isFavorite: true, icon: "car.fill", color: "00FF00"),
            Thanks(title: "My freinds", body: "They help my out", date: Date(), isFavorite: true, icon: "house.fill", color: "0000FF"),
            Thanks(title: "Food", body: "It nourishes my body", date: Date(), isFavorite: false, icon: "figure.table.tennis.circle.fill", color: "0000FF"),
            Thanks(title: "TV", body: "It keeps me entertained", date: Date(), isFavorite: false, icon: "figure.american.football", color: "00FF00"),
            Thanks(title: "Radio", body: "For when the TV doesn't work", date: Date(), isFavorite: true, icon: "figure.baseball.circle.fill", color: "#FFA500")
        ]
    }
}
