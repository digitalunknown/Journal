//
//  JournalView.swift
//  Journal
//
//  Created by Piotr Osmenda on 8/22/24.
//

import SwiftUI

struct JournalView: View {
    @StateObject private var viewModel = JournalViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach($viewModel.journalEntries) { $entry in // Note the use of $ to pass a binding
                        NavigationLink(destination: JournalDetailView(entry: $entry, viewModel: viewModel)) {
                            CardView(entry: entry)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .navigationTitle("Journal")
        }
    }
}

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var entry: JournalEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(entry.date, style: .date)
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Spacer() // Keeps the date and emoji on opposite ends

                Text(entry.emoji) // Display the selected emoji
                    .font(.title2)
            }

            if !entry.text.isEmpty {
                Text(entry.text)
                    .lineLimit(3)
                    .font(.body)
                    .foregroundColor(colorScheme == .dark ? .white : .black)  // Correct usage here
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
}

