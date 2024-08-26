//
//  JournalViewModel.swift
//  Journal
//
//  Created by Piotr Osmenda on 8/22/24.
//

import SwiftUI

class JournalViewModel: ObservableObject {
    @Published var journalEntries: [JournalEntry] = [] {
        didSet {
            saveEntries()
        }
    }
    
    private let userDefaultsKey = "JournalEntries"

    init() {
        loadEntries()
    }

    func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let entries = try? decoder.decode([JournalEntry].self, from: data) {
                journalEntries = entries
            }
        }
        
        ensure30Days()
    }

    func saveEntries() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(journalEntries) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    func updateEntry(_ entry: JournalEntry) {
        if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
            journalEntries[index] = entry
        } else {
            journalEntries.append(entry)
        }
        saveEntries()
    }

    func clearDay(_ entry: JournalEntry) {
        if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
            journalEntries[index].text = ""
            journalEntries[index].emoji = ""
            journalEntries[index].imageFileNames = []
            saveEntries()
        }
    }

    private func ensure30Days() {
        let today = Date()
        let calendar = Calendar.current
        let dates = (0..<30).map { calendar.date(byAdding: .day, value: -$0, to: today)! }

        for date in dates {
            if !journalEntries.contains(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
                let newEntry = JournalEntry(id: UUID(), date: date, text: "", emoji: "", imageFileNames: [])
                journalEntries.append(newEntry)
            }
        }

        journalEntries.sort { $0.date > $1.date }
    }
}
