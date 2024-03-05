//
//  FinishedView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftUI

/// List of all finished books with favourites marked.
struct FinishedView: View {
	@State private var searchText = ""
	@State private var sortOrder = SortDescriptor(\Book.title)
	
	var body: some View {
		NavigationStack {
			BooksListView(sortFinished: sortOrder, search: searchText)
				.searchable(text: $searchText, prompt: "Search for a title, author or category")
				.navigationTitle("Finished")
				.toolbar {
					ToolbarItem(placement: .topBarTrailing) {
						Menu("Sort", systemImage: "arrow.up.arrow.down") {
							Picker("Sort", selection: $sortOrder) {
								Text("Title")
									.tag(SortDescriptor(\Book.title))
								
								Text("Author")
									.tag(SortDescriptor(\Book.joinedAuthors))
								
								Text("Category")
									.tag(SortDescriptor(\Book.joinedCategories))
								
								Text("Date")
									.tag(SortDescriptor(\Book.safeFinishDate, order: .reverse))
								
								Text("Rating")
									.tag(SortDescriptor(\Book.rating, order: .reverse))
							}
							.pickerStyle(.inline)
						}
					}
				}
		}
	}
}

#Preview {
    FinishedView()
}
