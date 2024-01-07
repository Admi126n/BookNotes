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
	
	var filteredBooks: [Book] {
		books.filter { $0.finished }
	}
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(filteredBooks) { book in
					NavigationLink(value: book) {
						HStack {
							VStack(alignment: .leading) {
								Text(book.title)
									.fontDesign(.serif)
								
								Text(book.author)
									.font(.caption)
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
			.navigationDestination(for: Book.self) { book in
				DetailView(of: book)
			}
			.navigationTitle("Finished")
		}
    }
}

#Preview {
    FinishedView()
}
