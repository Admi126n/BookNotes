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
	@State private var fetchedBooks: [APIBook] = []
	
	var filteredBooks: [Book] {
		books.filter {
			if searchText.isEmpty {
				return true
			} else {
				return $0.title.localizedCaseInsensitiveContains(searchText)
				|| $0.author.localizedCaseInsensitiveContains(searchText)
				|| $0.genre.localizedCaseInsensitiveContains(searchText)
			}
		}
	}
	
	var body: some View {
		NavigationStack {
			Group {
				if filteredBooks.isEmpty && fetchedBooks.isEmpty {
					ContentUnavailableView("There are no books", systemImage: "book")
				} else {
					List {
						if !filteredBooks.isEmpty {
							Section("Your books") {
								ForEach(filteredBooks) { book in
									NavigationLink {
										DetailView(book: book)
									} label: {
										HStack {
											CellView(of: book)
											
											if book.isFinished {
												Spacer()
												
												Image(systemName: "checkmark")
													.foregroundStyle(.green)
											}
										}
									}
								}
							}
						}
						
						if !fetchedBooks.isEmpty {
							Section("Books from internet") {
								ForEach(fetchedBooks, id: \.self) { book in
									NavigationLink {
										DetailViewApi(book: book)
									} label: {
										Text(book.title)
									}
								}
							}
						}
					}
				}
			}
			.searchable(text: $searchText, prompt: "Search for a title, author or genre")
			.navigationTitle("Search")
			.onSubmit(of: .search) {
				Task {
					let results = await APIConnector.getApiResults(for: searchText)
					
					Task { @MainActor in
						fetchedBooks = results
					}
				}
			}
		}
	}
}

#Preview {
	SearchView()
}
