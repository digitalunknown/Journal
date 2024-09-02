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
    var maxSelection: Int = 3  // Allow up to 3 images by default

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: MultiImagePicker

        init(parent: MultiImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            for result in results.prefix(parent.maxSelection) {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let uiImage = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.images.append(uiImage)
                            }
                        } else if let error = error {
                            print("Error loading image: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("Cannot load image for this result: \(result)")
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = maxSelection  // Set the maximum selection limit to 3
        configuration.filter = .images  // Filter to only show images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}
