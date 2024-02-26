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
	// MARK: - Properties
	
	private(set) var authors: [String] {
		didSet {
			joinedAuthors = authors.joined(separator: ", ")
		}
	}
	
	private(set) var categories: [String] {
		didSet {
			joinedCategories = categories.joined(separator: ", ")
		}
	}
	
	private var finishDate: Date? {
		didSet {
			safeFinishDate = finishDate ?? Date.now
		}
	}
	
	var currentPage: Int = 0
	var notes: String = ""
	var pagesCount: Int = 0
	var rating: Int = 3
	var title: String
	
	private(set) var imageData: Data?
	private(set) var isFinished: Bool = false
	
	/// Property used in query predicate. Contains comma separated authors list
	private(set) var joinedAuthors: String = ""
	
	/// Property used in query predicate. Contains comma separated categoreis list
	private(set) var joinedCategories: String = ""
	
	/// Property used in query predicate. Contains finish date or `Date.now`
	private(set) var safeFinishDate: Date = Date.now
	
	// MARK: - Inits
	
	/// Init for unfinished books
	/// - Parameters:
	///   - title: title
	///   - authors: comma separated authors
	///   - categories: comma separated categories
	init(title: String, authors: String, categories: String = "Other") {
		self.title = title.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
		self.authors = authors.components(separatedBy: ", ").map {
			$0.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
		}
		self.categories = categories.components(separatedBy: ", ").map {
			$0.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
		}
		
		self.joinedAuthors = self.authors.joined(separator: ", ")
		self.joinedCategories = self.categories.joined(separator: ", ")
	}
	
	/// Init for unfinished books
	/// - Parameters:
	///   - title: title
	///   - authors: list of authors
	///   - categories: list of categories
	init(title: String, authors: [String], categories: [String] = ["Other"]) {
		self.title = title.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
		self.authors = authors.map { $0.capitalized.trimmingCharacters(in: .whitespacesAndNewlines) }
		self.categories = categories
		
		self.joinedAuthors = self.authors.joined(separator: ", ")
		self.joinedCategories = self.categories.joined(separator: ", ")
	}
	
	/// Init for unfinished books
	///  - Parameters:
	///   - book: APIBook object
	init(_ book: APIBook) {
		self.title = book.title
		self.authors = book.authors.map { $0.capitalized.trimmingCharacters(in: .whitespacesAndNewlines) }
		self.categories = book.categories.map { $0.capitalized.trimmingCharacters(in: .whitespacesAndNewlines) }
		
		self.joinedAuthors = self.authors.joined(separator: ", ")
		self.joinedCategories = self.categories.joined(separator: ", ")
	}
	
	// MARK: - Methods
	
	/// Sets book `finishDate` to `.now` and  `isFinished` to `true`
	func markAsFinished() {
		finishDate = .now
		isFinished = true
	}
	
	func containsInTitle(_ text: String) -> Bool {
		title.localizedCaseInsensitiveContains(text)
	}
	
	func containsInAuthors(_ text: String) -> Bool {
		joinedAuthors.localizedCaseInsensitiveContains(text)
	}
	
	func containsInCategories(_ text: String) -> Bool {
		joinedCategories.localizedCaseInsensitiveContains(text)
	}
	
	// MARK: - Setters
	
	func setTitle(_ title: String) {
		self.title = title
	}
	
	func setAuthors(_ authors: String) {
		self.authors = authors.components(separatedBy: ", ").sorted()
	}
	
	func setCategories(_ categories: String) {
		self.categories = categories.components(separatedBy: ", ").sorted()
	}
	
	func setCategoreis(_ categories: [String]) {
		self.categories = categories.sorted()
	}
	
	func setImageData(_ data: Data?) {
		self.imageData = data
	}
}

// MARK: - Equatable protocol

extension Book: Equatable {
	static func ==(_ lhs: Book, _ rhs: Book) -> Bool {
		lhs.authors == rhs.authors && lhs.title == rhs.title
	}
}
