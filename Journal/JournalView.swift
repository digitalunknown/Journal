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
                    if isSearching {
                        SearchBar(text: $searchText)
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                    }

                    ForEach(sectionOrder, id: \.self) { category in
                        if let entries = categorizedEntries[category], !entries.isEmpty { // Directly use the test here
                            Section(header: Text(category)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .padding(.top, 10)
                                        .padding(.horizontal, 20)) {
                                ForEach(entries) { entry in
                                    NavigationLink(destination: JournalDetailView(entry: binding(for: entry), viewModel: viewModel)) {
                                        CardView(entry: binding(for: entry), clearDayAction: {
                                            clearDay(entry)
                                        })
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                }
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

    private func clearDay(_ entry: JournalEntry) {
        viewModel.clearDay(entry)
    }

    private var sectionOrder: [String] {
        return ["This week", "Last week", "Past"]
    }

    private var categorizedEntries: [String: [JournalEntry]] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2  // Set Monday as the first day of the week
        
        let now = Date()
        
        var sections: [String: [JournalEntry]] = [
            "This week": [],
            "Last week": [],
            "Past": []
        ]
        
        for entry in filteredEntries {
            let weekOfYear = calendar.component(.weekOfYear, from: entry.date)
            let currentWeekOfYear = calendar.component(.weekOfYear, from: now)
            let yearOfEntry = calendar.component(.year, from: entry.date)
            let currentYear = calendar.component(.year, from: now)
            
            if yearOfEntry == currentYear {
                if weekOfYear == currentWeekOfYear {
                    sections["This week"]?.append(entry)
                } else if weekOfYear == currentWeekOfYear - 1 {
                    sections["Last week"]?.append(entry)
                } else {
                    sections["Past"]?.append(entry)
                }
            } else {
                sections["Past"]?.append(entry)
            }
        }
        
        return sections
    }

    private var filteredEntries: [JournalEntry] {
        if searchText.isEmpty {
            return viewModel.journalEntries
        } else {
            return viewModel.journalEntries.filter { entry in
                entry.text.lowercased().contains(searchText.lowercased()) ||
                entry.date.formatted(date: .abbreviated, time: .omitted).contains(searchText)
            }
        }
    }

    private func binding(for entry: JournalEntry) -> Binding<JournalEntry> {
        guard let index = viewModel.journalEntries.firstIndex(where: { $0.id == entry.id }) else {
            fatalError("Entry not found")
        }
        return $viewModel.journalEntries[index]
    }

    private func isEntryInCategory(_ entry: JournalEntry, category: String) -> Bool {
        switch category {
        case "This week":
            return categorizedEntries["This week"]?.contains(where: { $0.id == entry.id }) ?? false
        case "Last week":
            return categorizedEntries["Last week"]?.contains(where: { $0.id == entry.id }) ?? false
        case "Past":
            return categorizedEntries["Past"]?.contains(where: { $0.id == entry.id }) ?? false
        default:
            return false
        }
    }
}
