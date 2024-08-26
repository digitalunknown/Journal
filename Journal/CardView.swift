//
//  CardView.swift
//  Journal
//
//  Created by Piotr Osmenda on 8/23/24.
//

import SwiftUI

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var entry: JournalEntry
    var clearDayAction: () -> Void
    
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
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }

        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .contextMenu {
            Button(action: clearDayAction) {
                Text("Clear this day")
                Image(systemName: "trash")
            }
        }
    }
}
