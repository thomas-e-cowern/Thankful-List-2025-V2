//
//  ThanksRowView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/20/25.
//

import SwiftUI

struct ThanksRowView: View {
    
    var thanks: Thanks
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: thanks.icon)
                    .font(.title)
                    .foregroundStyle(thanks.hexColor.opacity(0.8))
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading) {
                    Text(thanks.title)
                    
                    Text("\(thanks.date, style: .date)")
                        .font(.caption)
                }
                
                Spacer()
                Image(systemName: thanks.isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(.red)
            }
        }
    }
}


#Preview {
    ThanksRowView(thanks: Thanks.sampleThanks[1])
}
