//
//  HorizontalScrollViewCell.swift
//  BookNotes
//
//  Created by Adam Tokarski on 19/02/2024.
//

import SwiftUI

fileprivate struct ImageFrame: ViewModifier {
	func body(content: Content) -> some View {
		content
			.scaledToFit()
			.frame(width: 100, height: 150)
	}
}

extension View {
	func scaledCover() -> some View {
		modifier(ImageFrame())
	}
}

struct HorizontalScrollViewCell: View {
	let title: String
	let imageData: Data?
	let imageURL: URL?
	
	var body: some View {
		ZStack {
			Color(.secondarySystemBackground)
			
			VStack {
				if let data = imageData {
					Image(uiImage: UIImage(data: data)!)
						.scaledCover()
				} else if let imageLink = imageURL {
					AsyncImage(url: imageLink, transaction: .init(animation: .easeIn)) { phase in
						switch phase {
						case .empty:
							ProgressView()
						case .success(let image):
							image
						case .failure(_):
							Image(systemName: "text.book.closed")
						@unknown default:
							Image(systemName: "text.book.closed")
						}
					}
					.scaledCover()
				} else {
					Spacer()
					
					Image(systemName: "text.book.closed")
						.font(.largeTitle)
				}
				
				Spacer()
				
				Text(title)
					.font(.headline)
					.fontDesign(.serif)
					.lineLimit(1)
			}
			.padding()
		}
		.frame(width: 150, height: 250)
		.clipShape(.rect(cornerRadius: 10))
	}
	
	init(_ book: APIBook) {
		self.title = book.title
		self.imageURL = book.imageLink
		
		self.imageData = nil
	}
	
	init(_ book: Book) {
		self.title = book.title
		self.imageData = book.imageData
		
		self.imageURL = nil
	}
}

#Preview {
	HorizontalScrollViewCell(APIBook.example)
}
