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
    private var timer: Timer?

    init() {
        loadEntries()
        startDailyCheckTimer()
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
            journalEntries[index].text = ""  // Clear the text
            journalEntries[index].images.removeAll()  // Clear the images
            journalEntries[index].emoji = ""  // Clear the emoji
            saveEntries()  // Save the updated journal entries
        }
    }

    private func ensure30Days() {
        let today = Date()
        let calendar = Calendar.current
        let dates = (0..<30).map { calendar.date(byAdding: .day, value: -$0, to: today)! }

        for date in dates {
            if !journalEntries.contains(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
                let newEntry = JournalEntry(date: date, text: "", emoji: "", imageFileNames: [])
                journalEntries.append(newEntry)
            }
        }

        journalEntries.sort { $0.date > $1.date }
    }

    // Start a timer to check for a new day at midnight
    private func startDailyCheckTimer() {
        let calendar = Calendar.current
        let now = Date()
        var midnightComponents = calendar.dateComponents([.year, .month, .day], from: now)
        midnightComponents.hour = 0
        midnightComponents.minute = 0
        midnightComponents.second = 0

        guard let midnight = calendar.date(from: midnightComponents) else {
            return
        }

        let nextMidnight = calendar.date(byAdding: .day, value: 1, to: midnight)!
        let timeInterval = nextMidnight.timeIntervalSince(now)

        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
            self?.addNewDayIfNeeded()
            self?.startDailyCheckTimer() // Restart the timer for the next day
        }
    }

    // Add a new day entry if today's entry is not already present
    private func addNewDayIfNeeded() {
        let today = Date()
        let calendar = Calendar.current

        if !journalEntries.contains(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            let newEntry = JournalEntry(date: today, text: "", emoji: "", imageFileNames: [])
            journalEntries.append(newEntry)
            journalEntries.sort { $0.date > $1.date }
            saveEntries()
        }
    }
}
