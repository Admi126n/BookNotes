//
//  CategoriesListView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 11/02/2024.
//

import SwiftUI

struct CategoriesListView: View {
	@StateObject var categories = Categories()
	
    var body: some View {
		List {
			ForEach(categories.sortedElements, id: \.self) {
				Text($0)
			}
			.onDelete(perform: deleteCategory)
		}
		.toolbar { EditButton()	}
    }
	
	private func deleteCategory(indexSet: IndexSet) {
		for i in indexSet {
			let el = categories.sortedElements[i]
			categories.remove(el)
		}
	}
}

#Preview {
    CategoriesListView()
}
