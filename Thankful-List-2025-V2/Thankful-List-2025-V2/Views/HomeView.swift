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
    @State private var isTipVisible = true

    private let addThanksTip = AddThanksTip()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // Decorative background
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .accessibilityHidden(true)

                ScrollView {
                    VStack(spacing: 20) {

                        // Tip card — announce briefly, hide if not visible
                        TipCardView(isTipVisible: $isTipVisible, tip: addThanksTip)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Tip: Add a thanks")
                            .accessibilityHint("Shows guidance to help you add your first entry.")
                            .accessibilityHidden(!isTipVisible)
                            .accessibilityIdentifier("Home.TipCard")

                        // Logo is decorative (title conveys the app)
                        Image("Thanks")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 96)
                            .accessibilityHidden(true)

                        // Headline (Rotor: Headings)
                        Text("Welcome to the Grateful List!")
                            .font(.largeTitle.bold())
                            .multilineTextAlignment(.center)
                            .accessibilityHeading(.h1)
                            .accessibilityIdentifier("Home.Headline")

                        // Subtitle / explainer
                        Text("Track the people, places, experiences, and things you’re grateful for — big or small.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .accessibilityIdentifier("Home.Subtitle")

                        // Focused content card
                        VStack(spacing: 16) {
                            Text("Not sure where to start?")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .accessibilityHeading(.h2)
                                .accessibilityIdentifier("Home.StartHeading")

                            Text("Tap below to see common examples to spark ideas.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .accessibilityIdentifier("Home.StartSubhead")

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
                            .accessibilityLabel("Show common gratitude examples")
                            .accessibilityHint("Opens a sheet with example ideas to help you begin.")
                            .accessibilityIdentifier("Home.CommonExamplesButton")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(.thinMaterial)
                                .accessibilityHidden(true) // decorative
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(Color.gray.opacity(0.15))
                                .accessibilityHidden(true) // decorative
                        )
                        .popoverTip(addThanksTip)

                        // Gentle reminder
                        Text("There’s no right or wrong — anything you’re thankful for is valid.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .accessibilityIdentifier("Home.Reminder")
                    }
                    .frame(maxWidth: 500)
                    .padding(.horizontal)
                    .padding(.top, 32)
                    .padding(.bottom, 80)
                }
                // Helpful: ensure VoiceOver reads main content before toolbar
                .accessibilitySortPriority(1)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .popoverTip(addThanksTip, arrowEdge: .trailing)
            .navigationDestination(for: Thanks.self) { thank in
                AddEditThanksView(navigationPath: $path, thanks: thank)
            }
            .sheet(isPresented: $showCommonExamples) {
                CommonThanksView()
                    .presentationDetents([.large])
                    .accessibilityAddTraits(.isModal)
                    .accessibilityLabel("Common gratitude examples")
                    .accessibilityHint("Swipe down or use the Close button to dismiss.")
            }
            .addThanksToolbar(path: $path) // See note below
            .accessibilityIdentifier("Home.View")
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
