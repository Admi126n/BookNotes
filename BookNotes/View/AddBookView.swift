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

fileprivate struct CategoryButton: View {
	let category: String
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			HStack {
				Text(category)
				Spacer()
				Image(systemName: "plus")
			}
			.contentShape(.rect)
		}
	}
	
	init(title category: String, _ action: @escaping () -> Void) {
		self.category = category
		self.action = action
	}
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
	
	@StateObject private var c = Categories()
	
	var trimmedCategory: String {
		category.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	var disableSave: Bool {
		title.isEmpty || author.isEmpty || categories.isEmpty
	}
	
	var filteredCategories: [String] {
		if category.isEmpty {
			c.sortedElements.filter { cat in
				!categories.contains(cat)
			}
		} else {
			c.sortedElements.filter { cat in
				cat.localizedCaseInsensitiveContains(category) && !categories.contains(cat)
			}
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
						CategoryButton(title: trimmedCategory) {
							addCategory(trimmedCategory)
						}
						.disabled(categories.contains(trimmedCategory))
					}
					
					ForEach(filteredCategories, id: \.self) { cat in
						CategoryButton(title: cat) {
							addCategory(cat)
						}
					}
				}
			}
			.navigationTitle("Add book")
			.toolbarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Add") {
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
		c.add(categories)
		dismiss()
	}
	
	private func addCategory(_ cat: String) {
		withAnimation {
			categories.append(cat)
			category = ""
		}
	}
}

#Preview {
    AddBookView()
}
