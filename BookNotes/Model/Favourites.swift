//
//  Favourites.swift
//  BookNotes
//
//  Created by Adam Tokarski on 07/01/2024.
//

import Foundation

class Favourites: ObservableObject {
	private let saveKey = "Favorites"
	private let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
	
	private(set) var elements: Set<String> = []
	
	init() {
		if let data = try? Data(contentsOf: dataPath.appending(path: saveKey)) {
			if let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
				elements = decoded
				return
			}
		}
		
		elements = []
	}
	
	// TODO: mark favourites by title and author
	func contains(_ book: Book) -> Bool {
		elements.contains(book.title)
	}
	
	func add(_ book: Book) {
		objectWillChange.send()
		elements.insert(book.title)
		save()
	}
	
	func remove(_ book: Book) {
		objectWillChange.send()
		elements.remove(book.title)
		save()
	}
	
	func save() {
		do {
			let encoded = try JSONEncoder().encode(elements)
			try encoded.write(to: dataPath.appending(path: saveKey), options: [.atomic])
		} catch {
			print(error.localizedDescription)
		}
	}
}
