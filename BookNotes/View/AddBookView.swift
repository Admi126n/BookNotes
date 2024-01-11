//
//  AddBookView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 05/01/2024.
//

import SwiftData
import SwiftUI

struct AddBookView: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.modelContext) var modelContext
	
	@State private var title = ""
	@State private var author = ""
	
	var disableSave: Bool {
		title.isEmpty || author.isEmpty
	}
	
    var body: some View {
		NavigationStack {
			Form {
				TextField("Title", text: $title)
					.textInputAutocapitalization(.words)
				
				TextField("Author", text: $author)
					.textInputAutocapitalization(.words)
			}
			.navigationTitle("Add book")
			.toolbarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Save") {
						let book = Book(title: title, author: author, genre: "fantasy")
						
						modelContext.insert(book)
						dismiss()
					}
					.disabled(disableSave)
				}
			}
		}
    }
}

#Preview {
    AddBookView()
}
