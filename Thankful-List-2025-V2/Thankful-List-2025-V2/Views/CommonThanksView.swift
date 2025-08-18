//
//  CommonThanksView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/18/25.
//

import SwiftUI

struct CommonThanksView: View {
    
    @StateObject private var store = GratitudeStore() // loads CommonThanksData.json
    
    var body: some View {
        NavigationView {
            Group {
                if let err = store.errorMessage {
                    Text(err).foregroundStyle(.red).padding()
                } else {
                    List {
                        ForEach(store.data.keys.sorted(), id: \.self) { category in
                            Section(category) {
                                ForEach(store.data[category] ?? [], id: \.self) { item in
                                    Text(item)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Common Thanks")
        }
    }
}

#Preview {
    CommonThanksView()
}
