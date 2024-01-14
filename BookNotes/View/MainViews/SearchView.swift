//
//  SearchView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftData
import SwiftUI

/// Listed books based on user search input (provided by Google Books API).
struct SearchView: View {
	@Query var books: [Book]
	@State private var searchText = ""
	
	var filteredBooks: [Book] {
		books.filter {
			$0.title.localizedCaseInsensitiveContains(searchText)
			|| $0.author.localizedCaseInsensitiveContains(searchText)
			|| $0.genre.localizedCaseInsensitiveContains(searchText)
		}
	}
	
    var body: some View {
		NavigationStack {
			List(filteredBooks) { book in
				NavigationLink {
					DetailView(of: book)
				} label: {
					HStack {
						CellView(of: book)
						
						Spacer()
						
						if book.isFinished {
							Image(systemName: "checkmark")
								.foregroundStyle(.green)
						}
					}
				}
			}
			.searchable(text: $searchText, prompt: "Search for a title, author or genre")
		}
    }
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: Book.self, configurations: config)
		
		return SearchView()
			.modelContainer(container)
	} catch {
		return Text("Failed to create container, \(error.localizedDescription)")
	}
}
