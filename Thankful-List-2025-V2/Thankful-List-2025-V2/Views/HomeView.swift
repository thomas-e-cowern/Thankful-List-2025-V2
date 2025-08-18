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
                // Soft background
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // App mark
                        Image("Thanks")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 96)
                            .accessibilityLabel("Thankful List logo")

                        // Headline
                        Text("Welcome to the Grateful List!")
                            .font(.largeTitle.bold())
                            .multilineTextAlignment(.center)

                        // Subtitle / explainer
                        Text("Track the people, places, experiences, and things you’re grateful for — big or small.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        // Focused content card
                        VStack(spacing: 16) {
                            Text("Not sure where to start?")
                                .font(.headline)
                                .multilineTextAlignment(.center)

                            Text("Tap below to see common examples to spark ideas.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)

                            Button {
                                showCommonExamples.toggle()
                            } label: {
                                Label("Common Examples", systemImage: "lightbulb")
                                    .font(.headline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .accessibilityHint("Opens a sheet with common gratitude ideas to help you get started.")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(Color.gray.opacity(0.15))
                        )

                        // Gentle reminder
                        Text("There’s no right or wrong — anything you’re thankful for is valid.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: 500)
                    .padding(.horizontal)
                    .padding(.top, 32)
                    .padding(.bottom, 80)
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Thanks.self) { thanks in
                // TODO: Enable when EditThanksView is available.
                // EditThanksView(navigationPath: $path, thanks: thanks)
                Text("EditThanksView goes here for: \(thanks.title)")
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
                            .imageScale(.large)
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
