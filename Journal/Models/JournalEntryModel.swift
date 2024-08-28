//
//  JournalEntryModel.swift
//  Journal
//
//  Created by Piotr Osmenda on 8/23/24.
//

import SwiftUI

// Enum to represent either a text block or an image block
enum JournalContentBlock: Identifiable, Codable {
    case text(String)
    case image(String) // Store the file name of the image

    var id: UUID {
        switch self {
        case .text(let text):
            return UUID(uuidString: text.hashValue.description) ?? UUID()
        case .image(let fileName):
            return UUID(uuidString: fileName.hashValue.description) ?? UUID()
        }
    }

    // Codable conformance
    enum CodingKeys: CodingKey {
        case type, content
    }

    enum BlockType: String, Codable {
        case text
        case image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(BlockType.self, forKey: .type)

        switch type {
        case .text:
            let text = try container.decode(String.self, forKey: .content)
            self = .text(text)
        case .image:
            let fileName = try container.decode(String.self, forKey: .content)
            self = .image(fileName)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let text):
            try container.encode(BlockType.text, forKey: .type)
            try container.encode(text, forKey: .content)
        case .image(let fileName):
            try container.encode(BlockType.image, forKey: .type)
            try container.encode(fileName, forKey: .content)
        }
    }
}

struct JournalEntry: Identifiable, Codable {
    var id: UUID
    let date: Date
    var contentBlocks: [JournalContentBlock] = []
    var emoji: String = ""  // Default emoji

    // Existing properties retained for backward compatibility or phased out as needed
    var text: String = ""
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
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}
