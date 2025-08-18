//
//  HomeView.swift
//  Thankful-List-2025-V2
//
//  Created by Thomas Cowern on 8/18/25.
//

import SwiftUI
import TipKit

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var path = NavigationPath()
    @State private var showCommonExamples = false

    private let addThanksTip = AddThanksTip()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                ScrollView { // handles smaller screens gracefully
                    VStack(spacing: 24) {
                        // App mark
                        Image("Thanks")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .accessibilityLabel("Thankful List logo")

                        // Headline
                        Text("Welcome to the Grateful List!")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)

                        // Subtitle / explainer
                        Text("The Grateful List helps you track the people, places, experiences, and things you’re grateful for.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        // Call to action
                        VStack(spacing: 12) {
                            Text("Not sure where to start? Check out the info below.")
                                .multilineTextAlignment(.center)

                            Button {
                                showCommonExamples.toggle()
                            } label: {
                                Text("Common examples")
                                    .fontWeight(.semibold)
                            }
                            .buttonStyle(.borderedProminent)
                            .accessibilityHint("Opens a sheet with common gratitude ideas to help you get started.")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: 500)    // keeps layout tidy on iPad
                    .padding(.horizontal)
                    .padding(.top, 32)
                    .padding(.bottom, 80)    // room for toolbar affordances
                }
            }
            .navigationDestination(for: Thanks.self) { thanks in
                // Ensure EditThanksView exists in your project.
//                EditThanksView(navigationPath: $path, thanks: thanks)
            }
            .sheet(isPresented: $showCommonExamples) {
                CommonThanksView()
                    .presentationDetents([.large])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let newThanks = Thanks(
                            title: "",
                            body: "",
                            date: .now,
                            isFavorite: false,
                            icon: IconImages.star.rawValue,
                            color: "#007AFF"
                        )
                        modelContext.insert(newThanks)
                        path.append(newThanks)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .popoverTip(addThanksTip)
                    .accessibilityLabel("Add new Thanks")
                    .accessibilityHint("Opens the form to add a new gratitude entry.")
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .task {
            // Preview-only TipKit configuration
            try? Tips.resetDatastore()
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
}
