//
//  ImageSheetView.swift
//  Journal
//
//  Created by Piotr Osmenda on 8/23/24.
//

import SwiftUI

struct ImageSheetView: View {
    var images: [UIImage]
    @Binding var selectedIndex: Int
    @Binding var isPresented: Bool
    var onDelete: () -> Void  // Callback function to handle image deletion
    
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $selectedIndex) {
                    ForEach(images.indices, id: \.self) { index in
                        Image(uiImage: images[index])
                            .resizable()
                            .scaledToFit()
                            .tag(index)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
            }
            .navigationBarItems(
                leading: Button(action: {
                    onDelete()  // Call the delete callback
                    isPresented = false  // Dismiss the sheet
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.subheadline)
                },
                trailing: Button(action: {
                    isPresented = false  // Dismiss the sheet
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            )
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

