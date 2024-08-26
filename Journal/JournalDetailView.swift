//
//  JournalDetailView.swift
//  Journal
//
//  Created by Piotr Osmenda on 8/22/24.
//

import SwiftUI
import PhotosUI

struct JournalDetailView: View {
    @Binding var entry: JournalEntry
    @ObservedObject var viewModel: JournalViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingImagePicker = false
    @State private var isShowingImageSheet = false
    @State private var selectedImageIndex = 0
    
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
                .frame(minHeight: 200)
            
            HStack(spacing: 10) {
                ForEach(entry.images.indices, id: \.self) { index in
                    Image(uiImage: entry.images[index])
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 100)
                        .cornerRadius(12)
                        .onTapGesture {
                            selectedImageIndex = index
                            isShowingImageSheet = true
                        }
                }
            }
            .padding()
            .sheet(isPresented: $isShowingImageSheet) {
                ImageSheetView(images: entry.images, selectedIndex: $selectedImageIndex, isPresented: $isShowingImageSheet) {
                    entry.images.remove(at: selectedImageIndex)
                }
            }
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            showingImagePicker = true
        }) {
            Image(systemName: "photo.badge.plus.fill")
                .imageScale(.medium)
        })
        .sheet(isPresented: $showingImagePicker, onDismiss: {
            viewModel.updateEntry(entry)  // Save the entry after adding images
        }) {
            MultiImagePicker(images: $entry.images, maxSelection: 3 - entry.images.count)
        }
        .onDisappear {
            viewModel.updateEntry(entry)  // Save the entry when the view disappears
        }
    }
}

