//
//  JournalView.swift
//  Journal
//
//  Created by Piotr Osmenda on 8/22/24.
//

import SwiftUI

struct JournalView: View {
    @StateObject private var viewModel = JournalViewModel()
    @State private var searchText = ""
    @State private var isSearching = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // Conditionally show the search bar
                    if isSearching {
                        SearchBar(text: $searchText)
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                    }

                    // List of journal entries (including placeholders)
                    ForEach(filteredEntries, id: \.id) { entry in
                        NavigationLink(destination: JournalDetailView(entry: binding(for: entry), viewModel: viewModel)) {
                            CardView(entry: entry)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .navigationTitle("Journal")
            .navigationBarItems(trailing: Button(action: {
                withAnimation {
                    isSearching.toggle()
                }
            }) {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
            })
        }
    }

    // Filter entries based on search text
    var filteredEntries: [JournalEntry] {
        if searchText.isEmpty {
            return viewModel.journalEntries
        } else {
            return viewModel.journalEntries.filter { entry in
                entry.text.lowercased().contains(searchText.lowercased()) ||
                entry.date.formatted(date: .abbreviated, time: .omitted).contains(searchText)
            }
        }
    }

    // Helper function to get binding for a journal entry
    private func binding(for entry: JournalEntry) -> Binding<JournalEntry> {
        guard let index = viewModel.journalEntries.firstIndex(where: { $0.id == entry.id }) else {
            fatalError("Entry not found")
        }
        return $viewModel.journalEntries[index]
    }
}
