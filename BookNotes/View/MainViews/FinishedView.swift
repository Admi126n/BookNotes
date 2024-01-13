//
//  FinishedView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftData
import SwiftUI

/// List of all finished books with favourites marked.
struct FinishedView: View {
	@EnvironmentObject var favourites: Favourites
	@Environment(\.modelContext) var modelContext
	@Query var books: [Book]
	@State private var searchText = ""
	
	var filteredBooks: [Book] {
		books.filter { book in
			if searchText.isEmpty {
				return book.isFinished
			} else {
				return book.isFinished 
				&& (book.title.localizedCaseInsensitiveContains(searchText)
					|| book.author.localizedCaseInsensitiveContains(searchText)
					|| book.genre.rawValue.localizedCaseInsensitiveContains(searchText)
					)
			}
		}
	}
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(filteredBooks) { book in
					NavigationLink() {
						DetailView(of: book)
					} label: {
						HStack {
							VStack(alignment: .leading) {
								Text(book.title)
									.fontDesign(.serif)
									.font(.headline)
								
								Text(book.author)
									.font(.caption)
									.foregroundStyle(.secondary)
							}
							
							Spacer()
							
							if favourites.contains(book) {
								Image(systemName: "heart.fill")
									.foregroundStyle(.red)
							}
						}
					}
					.swipeActions(edge: .trailing, allowsFullSwipe: true) {
						DeleteButton {
							modelContext.delete(book)
							favourites.remove(book)
						}
					}
					.swipeActions(edge: .leading, allowsFullSwipe: true) {
						if favourites.contains(book) {
							RemoveFromFavouritesButton {
								favourites.remove(book)
							}
						} else {
							AddToFavouritesButton {
								favourites.add(book)
							}
						}
					}
				}
			}
			.searchable(text: $searchText, prompt: "Search for a title, author or genre")
			.navigationTitle("Finished")
		}
    }
}

#Preview {
    FinishedView()
}
