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
	
	private var elements: Set<Element> = []
	
	var count: Int {
		elements.count
	}
	
	/// Sorted set of authors of books saved as favourite
	var favouriteAuthors: [String] {
		Set(elements.map { $0.author }).sorted()
	}
	
	init() {
		if let data = try? Data(contentsOf: dataPath.appending(path: saveKey)) {
			if let decoded = try? JSONDecoder().decode(Set<Element>.self, from: data) {
				elements = decoded
				return
			}
		}
		
		elements = []
	}
	
	func contains(_ book: Book) -> Bool {
		elements.contains(.init(book.title, book.joinedAuthors))
	}
	
	func add(_ book: Book) {
		objectWillChange.send()
		elements.insert(.init(book.title, book.joinedAuthors))
		save()
	}
	
	func remove(_ book: Book) {
		objectWillChange.send()
		elements.remove(.init(book.title, book.joinedAuthors))
		save()
	}
	
	/// Saves `elements` in app storage
	private func save() {
		do {
			let encoded = try JSONEncoder().encode(elements)
			try encoded.write(to: dataPath.appending(path: saveKey), options: [.atomic])
		} catch {
			print(error.localizedDescription)
		}
	}
}

// MARK: - Helper struct

/// Contains `title` and `author` properties. Instances of this structs are used for saving favourites books
fileprivate struct Element: Codable, Hashable {
	let title: String
	let author: String
	
	init(_ title: String, _ author: String) {
		self.title = title
		self.author = author
	}
}
