//
//  SearchBar.swift
//  Journal
//
//  Created by Piotr Osmenda on 8/23/24.
//
import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search"  // Updated placeholder text
        
        // Remove the background and lines
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = UIColor.systemGray5  // Light gray background
        searchBar.searchTextField.layer.cornerRadius = 12
        searchBar.searchTextField.clipsToBounds = true
        
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
