//
//  BookCellView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 14/01/2024.
//

import SwiftData
import SwiftUI

struct CellView: View {
	@EnvironmentObject var favourites: Favourites
	let book: Book
	
    var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Text(book.title)
					.fontDesign(.serif)
					.font(.headline)
				
				Text(book.authors, format: .list(type: .and))
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
	
	init(of book: Book) {
		self.book = book
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: Book.self, configurations: config)
		
		let book = Book(title: "Example", author: "Example", genre: .scienceFiction)
		
		return CellView(of: book)
			.modelContainer(container)
			.environmentObject(Favourites())
	} catch {
		return Text("Failed to create container, \(error.localizedDescription)")
	}
}
