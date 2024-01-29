//
//  Book.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import Foundation
import SwiftData

@Model
class Book: BookDescription {
	var authors: [String] {
		didSet {
			joinedAuthors = newValue.joined()
		}
	}
	
	var categories: [String] {
		didSet {
			joinedCategories = newValue.joined()
		}
	}
	
	var notes: String = ""
	var rating: Int = 3
	var title: String
	
	private(set) var finishDate: Date?
	private(set) var image: Data?
	private(set) var isFinished: Bool = false
	private(set) var joinedAuthors: String = ""
	private(set) var joinedCategories: String = ""
	
	/// Init for unfinished books
	init(title: String, author: String, genre: Genre) {
		self.title = title
		self.authors = [author]
		self.categories = [genre.rawValue]
	}
	
	/// Init for finished books
	init(title: String, author: String, genre: Genre, readDate: Date, notes: String = "", rating: Int = 1) {
		self.title = title
		self.authors = [author]
		self.categories = [genre.rawValue]
		self.isFinished = true
		self.notes = notes
		self.rating = rating
		self.finishDate = readDate
	}
	
	func markAsFinished() {
		finishDate = .now
		isFinished = true
	}
	
	func set(image data: Data) {
		image = data
	}
	
	func containsInTitle(_ text: String) -> Bool {
		title.localizedCaseInsensitiveContains(text)
	}
	
	func containsInAuthors(_ text: String) -> Bool {
		authors.joined().localizedCaseInsensitiveContains(text)
	}
	
	func containsInCategories(_ text: String) -> Bool {
		categories.joined().localizedCaseInsensitiveContains(text)
	}
}

// MARK: - Equatable protocol

extension Book: Equatable {
	static func ==(_ lhs: Book, _ rhs: Book) -> Bool {
		lhs.authors == rhs.authors && lhs.title == rhs.title
	}
}
