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
	@EnvironmentObject var favourites: Favourites
	@Environment(\.modelContext) var modelContext
	@Query var books: [Book]
	@State private var showingSheet = false
	
	var filteredBooks: [Book] {
		books.filter { !$0.finished }
	}
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(filteredBooks) { book in
					NavigationLink {
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
			.navigationTitle("To read")
			.toolbar {
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
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: Book.self, configurations: config)
		
		return ToReadView()
			.modelContainer(container)
	} catch {
		return Text("Failed to create container, \(error.localizedDescription)")
	}
}
