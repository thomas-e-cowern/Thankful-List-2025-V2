//
//  ThanksSortOption.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/25/25.
//

import SwiftUI
import SwiftData

// Your existing options, moved out so they can be reused.
enum ThanksSortOption: CaseIterable, Hashable {
    case titleAsc, titleDesc, dateAsc, dateDesc

    var label: String {
        switch self {
        case .titleAsc:  return "Name A → Z"
        case .titleDesc: return "Name Z → A"
        case .dateAsc:   return "Date Oldest → Newest"
        case .dateDesc:  return "Date Newest → Oldest"
        }
    }

    var descriptors: [SortDescriptor<Thanks>] {
        switch self {
        case .titleAsc:
            [SortDescriptor(\Thanks.title, order: .forward)]
        case .titleDesc:
            [SortDescriptor(\Thanks.title, order: .reverse)]
        case .dateAsc:
            [SortDescriptor(\Thanks.date)]
        case .dateDesc:
            [SortDescriptor(\Thanks.date, order: .reverse)]
        }
    }
}
