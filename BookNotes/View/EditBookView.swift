//
//  EditBookView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 25/02/2024.
//

import SwiftData
import SwiftUI
import PhotosUI

struct EditBookView: View {
	@Binding var book: Book
	@Environment(\.dismiss) var dismiss
	@State private var authors: String
	
	@State private var pickerItem: PhotosPickerItem?
	@State private var imageData: Data?
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Title") {
					TextField("Title", text: $book.title)
				}
				
				Section("Author") {
					TextField("Author", text: $authors)
				}
				
				Section("Cover") {
					PhotosPicker(selection: $pickerItem,
								 matching: .any(of: [.images, .screenshots])) {
						if let imageData = book.imageData {
							HStack(spacing: 10) {
								Image(uiImage: UIImage(data: imageData)!)
									.resizable()
									.scaledToFit()
									.frame(width: 100)
									.clipShape(.rect(cornerRadius: 5))
								
								Label("Edit cover", systemImage: "photo.on.rectangle")
							}
						} else {
							Label("Add cover", systemImage: "photo.badge.plus")
						}
					}
					.swipeActions(edge: .trailing, allowsFullSwipe: true) {
						if book.imageData != nil {
							DeleteButton {
								book.setImageData(nil)
								pickerItem = nil
							}
						}
					}
				}
				
				// Categories
				
				if book.isFinished {
					Section("Rating") {
						RatingView(rating: $book.rating)
					}
				}
			}
			.toolbar {
				Button("Done") {
					dismiss()
				}
			}
			.onChange(of: authors) {
				book.setAuthors(authors)
			}
			.onChange(of: pickerItem) {
				Task {
					imageData = try await pickerItem?.loadTransferable(type: Data.self)
					book.setImageData(imageData)
				}
			}
		}
	}
	
	init(book: Binding<Book>) {
		self._book = book
		self._authors = State(initialValue: book.wrappedValue.joinedAuthors)
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: Book.self, configurations: config)
		
		let book = Book(title: "Example", authors: "Example authors")
		
		return EditBookView(book: .constant(book))
			.modelContainer(container)
	} catch {
		return Text("Failed to create container, \(error.localizedDescription)")
	}
}
