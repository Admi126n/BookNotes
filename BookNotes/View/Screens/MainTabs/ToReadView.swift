//
//  ToReadView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftUI

/// List of books to read.
///
/// View has search bar and button for changing sort order.
/// Available sort orders: `.authors`, `.categories`, `.title`
struct ToReadView: View {
	
	@State private var searchText = ""
	@State private var showingAddBookSheet = false
	@State private var sortOrder = SortDescriptor(\Book.title)
	
	var body: some View {
		NavigationStack {
			BooksListView(sortUnfinished: sortOrder, search: searchText)
				.searchable(text: $searchText, prompt: "Search for a title, author or category")
				.navigationTitle("To read")
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
							}
							.pickerStyle(.inline)
						}
					}
					
					ToolbarItem(placement: .topBarTrailing) {
						Button("Add book", systemImage: "plus") {
							showingAddBookSheet = true
						}
					}
				}
				.sheet(isPresented: $showingAddBookSheet) {
					AddBookView()
				}
		}
	}
}

#Preview {
	ToReadView()
}
