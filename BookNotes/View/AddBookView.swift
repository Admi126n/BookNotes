//
//  AddBookView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 05/01/2024.
//

import SwiftData
import SwiftUI

@frozen
fileprivate enum Field {
	case title
	case author
}

struct AddBookView: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.modelContext) var modelContext
	@FocusState private var focusedField: Field?
	@Query var books: [Book]
	@State private var title = ""
	@State private var author = ""
	@State private var genre = Genre.other
	@State private var showingAlert = false
	@State private var message = ""
	
	var disableSave: Bool {
		title.isEmpty || author.isEmpty
	}
	
    var body: some View {
		NavigationStack {
			Form {
				
				TextField("Title", text: $title)
					.textInputAutocapitalization(.words)
					.focused($focusedField, equals: .title)
					.submitLabel(.next)
				
				TextField("Author", text: $author)
					.textInputAutocapitalization(.words)
					.focused($focusedField, equals: .author)
					.submitLabel(.done)
				
				Picker("Genre", selection: $genre) {
					ForEach(Genre.allCases, id: \.rawValue) { genre in
						Text("\(genre.rawValue)")
							.tag(genre)
					}
				}
			}
			.navigationTitle("Add book")
			.toolbarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Done") {
						addBook()
					}
					.disabled(disableSave)
				}
			}
			.onSubmit {
				switch focusedField {
				case .title:
					focusedField = .author
				default:
					return
				}
			}
			.onAppear {
				focusedField = .title
			}
			.alert("Book already exist", isPresented: $showingAlert) { } message: {
				Text(message)
			}
		}
    }
	
	private func addBook() {
		let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
		let trimmedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
		
		let book = Book(title: trimmedTitle, author: trimmedAuthor, genre: genre)
		
		guard !books.contains(book) else {
			message = "You already have book \"\(trimmedTitle)\" by \(trimmedAuthor)"
			showingAlert = true
			return
		}
		
		modelContext.insert(book)
		dismiss()
	}
}

#Preview {
    AddBookView()
}
