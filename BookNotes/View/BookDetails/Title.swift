//
//  Title.swift
//  BookNotes
//
//  Created by Adam Tokarski on 28/01/2024.
//

import SwiftUI

struct Title: View {
	private let book: BookDescription
	
	var body: some View {
		Text(book.title)
			.font(.largeTitle)
			.fontDesign(.serif)
			.bold()
			.fixedSize(horizontal: false, vertical: true)
	}
	
	init(_ book: BookDescription) {
		self.book = book
	}
}

#Preview {
	Authors(APIBook.example)
}
