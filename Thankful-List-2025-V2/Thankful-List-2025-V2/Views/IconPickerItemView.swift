//
//  IconPickerItemView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/20/25.
//

import SwiftUI

struct IconPickerItemView: View {
    
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title) // Example of larger font
        }
    }
}

#Preview {
    IconPickerItemView(icon: IconImages.swirl.rawValue)
}
