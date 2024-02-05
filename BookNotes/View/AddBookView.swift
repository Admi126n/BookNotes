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
	case author
	case category
	case title
}

struct AddBookView: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.modelContext) var modelContext
	@FocusState private var focusedField: Field?
	@Query var books: [Book]
	
	@State private var title = ""
	@State private var author = ""
	@State private var category = ""
	@State private var categories: [String] = []
	
	@State private var showingAlert = false
	@State private var message = ""
	
	var disableSave: Bool {
		title.isEmpty || author.isEmpty || categories.isEmpty
	}
	
	var filteredCategories: [String] {
		let genres = Genre.allCases.map { $0.rawValue }
		return genres.filter { genre in
			genre.localizedCaseInsensitiveContains(category) && !categories.contains(genre)
		}
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
					.submitLabel(.next)
				
				if !categories.isEmpty {
					Text(categories, format: .list(type: .and))
				}
				
				Section {
					TextField("Category", text: $category)
						.focused($focusedField, equals: .category)
						.submitLabel(.done)
				}
				
				Section {
					if !category.isEmpty {
						Button {
							withAnimation {
								categories.append(category.trimmingCharacters(in: .whitespacesAndNewlines))
								category = ""
							}
						} label: {
							HStack {
								Text(category)
								Spacer()
								Image(systemName: "plus")
							}
							.contentShape(.rect)
						}
						.disabled(categories.contains(category))
					}
					
					ForEach(filteredCategories, id: \.self) { cat in
						Button {
							withAnimation {
								categories.append(cat)
								category = ""
							}
						} label: {
							HStack {
								Text(cat)
								Spacer()
								Image(systemName: "plus")
							}
							.contentShape(.rect)
						}
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
				case .author:
					focusedField = .category
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
		
		let book = Book(title: trimmedTitle, authors: [trimmedAuthor], categories: categories)
		
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
