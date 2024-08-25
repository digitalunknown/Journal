//
//  ImagePicker.swift
//  Journal
//
//  Created by Piotr Osmenda on 8/23/24.
//

import SwiftUI
import PhotosUI

struct MultiImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Environment(\.presentationMode) var presentationMode
    var maxSelection: Int
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: MultiImagePicker

        init(parent: MultiImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            self.parent.presentationMode.wrappedValue.dismiss()

            for result in results.prefix(self.parent.maxSelection) {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let uiImage = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.images.append(uiImage)
                            }
                        }
                    }
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = maxSelection  // Set the maximum selection limit
        configuration.filter = .images  // Filter to only show images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}
