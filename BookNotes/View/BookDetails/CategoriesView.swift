//
//  CategoriesView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 28/01/2024.
//

import SwiftUI

struct CategoriesView: View {
	private let book: BookDescription
	
	var body: some View {
		Text(book.categories, format: .list(type: .and))
			.bold()
	}
	
	init(_ book: BookDescription) {
		self.book = book
	}
}

#Preview {
	CategoriesView(APIBook.example)
}
