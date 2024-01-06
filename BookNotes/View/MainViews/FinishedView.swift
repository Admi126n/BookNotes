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
	@Environment(\.modelContext) var modelContext
	@Query var books: [Book]
	
	var filteredBooks: [Book] {
		books.filter { $0.finished }
	}
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(filteredBooks) { book in
					NavigationLink {
						DetailView(of: book)
					} label: {
						VStack(alignment: .leading) {
							Text(book.title)
								.fontDesign(.serif)
							
							Text(book.author)
								.font(.caption)
						}
					}
				}
				.onDelete(perform: removeBook)
			}
			.navigationTitle("Finished")
		}
    }
	
	private func removeBook(_ indexSet: IndexSet) {
		for index in indexSet {
			let book = books[index]
			modelContext.delete(book)
		}
	}
}

#Preview {
    FinishedView()
}
