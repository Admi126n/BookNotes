//
//  AuthorsView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 28/01/2024.
//

import SwiftUI

struct AuthorsView: View {
	private let book: BookDescription
	
	var body: some View {
		Text(book.authors, format: .list(type: .and))
			.foregroundStyle(.secondary)
			.font(.headline)
	}
	
	init(_ book: BookDescription) {
		self.book = book
	}
}

#Preview {
	AuthorsView(APIBook.example)
}
