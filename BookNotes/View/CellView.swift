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
	let book: BookDescription
	
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
			
			if let b = book as? Book, favourites.contains(b) {
				Image(systemName: "heart.fill")
					.foregroundStyle(.red)
			}
		}
    }
	
	init(of book: BookDescription) {
		self.book = book
	}
}

#Preview {
	CellView(of: APIBook.example)
		.environmentObject(Favourites())
}
