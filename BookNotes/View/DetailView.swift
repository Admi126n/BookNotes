//
//  DetailView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftUI

/// Book detail view.
struct DetailView: View {
	let book: Book
	
    var body: some View {
		VStack {
			Text(book.title)
				.font(.title)
			
			Text(book.author)
		}
    }
}

#Preview {
	DetailView(book: Book.example)
}
