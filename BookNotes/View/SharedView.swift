//
//  ShareView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 08/01/2024.
//

import SwiftData
import SwiftUI

struct SharedView: View {
	let displayScale: CGFloat
	let book: Book
	
    var body: some View {
		VStack(alignment: .leading) {
			Text(book.title)
				.font(.title)
				.fontDesign(.serif)
			
			Text("by \(book.authors, format: .list(type: .and))")
				.foregroundStyle(.secondary)
			
			if book.isFinished {
				RatingView(rating: .constant(book.rating))
					.padding(.top, 3)
			}
		}
		.padding()
		.background(
			RadialGradient(
				colors: [.white, .gray],
				center: .center,
				startRadius: 70,
				endRadius: book.isFinished ? 200 : 100
			)
		)
	}
	
	init(of book: Book, _ displayScale: CGFloat = 4.0) {
		self.book = book
		self.displayScale = displayScale
	}
	
	@MainActor func render() -> Image? {
		let renderer = ImageRenderer(content: body)
		renderer.scale = displayScale
		
		if let uiImage = renderer.uiImage {
			return Image(uiImage: uiImage)
		}
		
		return nil
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: Book.self, configurations: config)
		
		let book = Book(title: "Example", author: "Example", genre: .other)
		
		return SharedView(of: book)
			.modelContainer(container)
	} catch {
		return Text("Failed to create container, \(error.localizedDescription)")
	}
}
