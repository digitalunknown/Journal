//
//  JournalEntryModel.swift
//  Journal
//
//  Created by Piotr Osmenda on 8/23/24.
//

import SwiftUI

struct JournalEntry: Identifiable, Codable {
    var id: UUID = UUID()  // Provide a default value for 'id'
    let date: Date
    var text: String
    var emoji: String
    var imageFileNames: [String]

    // Initializer
    init(id: UUID = UUID(), date: Date, text: String = "", emoji: String = "", imageFileNames: [String] = []) {
        self.id = id
        self.date = date
        self.text = text
        self.emoji = emoji
        self.imageFileNames = imageFileNames
    }

    // Existing properties retained for backward compatibility or phased out as needed
    var images: [UIImage] {
        get {
            imageFileNames.compactMap { loadImageFromDocumentsDirectory(fileName: $0) }
        }
        set {
            imageFileNames = newValue.compactMap { saveImageToDocumentsDirectory(image: $0) }
        }
    }
}

// Helper functions for saving and loading images
func loadImageFromDocumentsDirectory(fileName: String) -> UIImage? {
    let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
    if let data = try? Data(contentsOf: fileURL) {
        return UIImage(data: data)
    }
    return nil
}

func saveImageToDocumentsDirectory(image: UIImage) -> String? {
    let fileName = UUID().uuidString + ".jpg"
    if let data = image.jpegData(compressionQuality: 1.0) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving image: \(error)")
        }
    }
    return nil
}

func getDocumentsDirectory() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}
