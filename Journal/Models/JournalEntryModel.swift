//
//  JournalEntryModel.swift
//  Journal
//
//  Created by Piotr Osmenda on 8/23/24.
//

import SwiftUI

struct JournalEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var text: String
    var emoji: String = ""  // Default emoji
    var imageFileNames: [String] = []  // Store file names of images

    var images: [UIImage] {
        get {
            imageFileNames.compactMap { loadImageFromDocumentsDirectory(fileName: $0) }
        }
        set {
            imageFileNames = newValue.compactMap { saveImageToDocumentsDirectory(image: $0) }
        }
    }
}

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
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}

