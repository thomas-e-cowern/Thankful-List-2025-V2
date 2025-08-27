//
//  TipCardView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/27/25.
//

import SwiftUI
import TipKit

struct TipCardView: View {
    @Binding var isTipVisible: Bool
    let tip: SettingsTip

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if isTipVisible {
            VStack(alignment: .leading, spacing: 12) {
                TipView(tip)
                    .onAppear {
                        if !reduceMotion {
                            withAnimation(.spring(response: 0.32, dampingFraction: 0.88)) {
                                isTipVisible = true
                            }
                        } else {
                            isTipVisible = true
                        }
                    }
                    .onDisappear {
                        if !reduceMotion {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                isTipVisible = false
                            }
                        } else {
                            isTipVisible = false
                        }
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Color.gray.opacity(0.15))
            )
            .transition(
                .asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.98, anchor: .top)),
                    removal: .opacity.combined(with: .scale(scale: 0.92, anchor: .top))
                )
            )
            .animation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.9), value: isTipVisible)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Tip")
        }
    }
}

#Preview {
    TipCardView(isTipVisible: .constant(false), tip: SettingsTip())
}
