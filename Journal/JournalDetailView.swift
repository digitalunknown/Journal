//
//  JournalEntry.swift
//  Journal
//
//  Created by Piotr Osmenda on 8/22/24.
//

import SwiftUI

struct JournalDetailView: View {
    @Binding var entry: JournalEntry
    @ObservedObject var viewModel: JournalViewModel
    @Environment(\.presentationMode) var presentationMode

    let emojiOptions = ["🤩", "😁", "🤨", "😟", "😤"]

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.date, style: .date)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding([.top, .leading], 10)

            Picker("Mood", selection: $entry.emoji) {
                ForEach(emojiOptions, id: \.self) { emoji in
                    Text(emoji).tag(emoji)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)

            TextEditor(text: $entry.text)
                .padding(10)

            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            viewModel.updateEntry(entry)
        }
    }
}
