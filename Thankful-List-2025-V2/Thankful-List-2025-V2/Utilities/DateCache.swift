//
//  DateCache.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/25/25.
//

import Foundation

final class DateCache {
    static let shared = DateCache()
    let dayTime: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "EEEE 'at' h:mm a"   // Monday at 9:30 AM
        return df
    }()
}
