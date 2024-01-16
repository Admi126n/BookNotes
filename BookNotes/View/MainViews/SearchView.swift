//
//  SearchView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftUI

/// Listed books based on user search input (provided by Google Books API).
struct SearchView: View {
	@State private var searchText = ""
	@State private var sortOrder = SortDescriptor(\Book.title)
	
    var body: some View {
		NavigationStack {
			BooksListView(sortAll: sortOrder, search: searchText)
				.searchable(text: $searchText, prompt: "Search for a title, author or genre")
				.navigationTitle("Search")
				.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						Menu("Sort", systemImage: "arrow.up.arrow.down") {
							Picker("Sort", selection: $sortOrder) {
								Text("Title")
									.tag(SortDescriptor(\Book.title))
								
								Text("Author")
									.tag(SortDescriptor(\Book.author))
								
								Text("Genre")
									.tag(SortDescriptor(\Book.genre))
							}
							.pickerStyle(.inline)
						}
					}
				}
		}
    }
}

#Preview {
	SearchView()
}
