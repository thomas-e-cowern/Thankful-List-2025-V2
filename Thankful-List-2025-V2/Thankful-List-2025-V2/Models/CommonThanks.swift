//
//  CommonThanks.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/18/25.
//

import Foundation

struct CommonThanksData: Codable {
    let relationshipsConnections, family, healthWellBeing, basicNeedsSecurity: [String]
    let personalGrowthFulfillment, everydayComforts, deeperIntangibles, nature: [String]
    
    enum CodingKeys: String, CodingKey {
        case relationshipsConnections = "Relationships & Connections"
        case family = "Family"
        case healthWellBeing = "Health & Well-being"
        case basicNeedsSecurity = "Basic Needs & Security"
        case personalGrowthFulfillment = "Personal Growth & Fulfillment"
        case everydayComforts = "Everyday Comforts"
        case deeperIntangibles = "Deeper Intangibles"
        case nature = "Nature"
    }
}
