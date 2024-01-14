//
//  ToReadView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftData
import SwiftUI

/// List of books to read.
struct ToReadView: View {
	@State private var showingSheet = false
	@State private var searchText = ""
	@State private var sortOrder = SortDescriptor(\Book.title)
	
	var body: some View {
		NavigationStack {
			List {
				BookListView(sort: sortOrder, searchText: searchText, false)
			}
			.searchable(text: $searchText, prompt: "Search for a title, author or genre")
			.navigationTitle("To read")
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
				
				ToolbarItem(placement: .topBarTrailing) {
					Button("Add book", systemImage: "plus") {
						showingSheet = true
					}
				}
			}
			.sheet(isPresented: $showingSheet) {
				AddBookView()
			}
		}
	}
}

#Preview {
	ToReadView()
}
